import SwiftUI
import StoreKit
import Combine

typealias VerificationResult<T> = StoreKit.VerificationResult<T>
typealias Transaction = StoreKit.Transaction
typealias Product = StoreKit.Product

@MainActor
final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var currentTier: SubscriptionTier = .free
    @Published var subscriptionStatus: SubscriptionStatus = .notSubscribed
    @Published var isTrialActive: Bool = false
    @Published var trialDaysRemaining: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var updateListenerTask: Task<Void, Error>?
    private let subscriptionStatusKey = "StoryStudio_SubscriptionStatus"
    private let subscriptionTierKey = "StoryStudio_SubscriptionTier"
    private let trialActiveKey = "StoryStudio_TrialActive"
    private let trialEndDateKey = "StoryStudio_TrialEndDate"
    
    private init() {
        loadSubscriptionState()
        updateListenerTask = listenForTransactions()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    var isSubscribed: Bool {
        subscriptionStatus == .subscribed || subscriptionStatus == .inTrial
    }
    
    var hasProAccess: Bool {
        currentTier == .pro
    }
    
    func canAccessFeature(feature: String) -> Bool {
        return currentTier == .pro
    }
    
    // MARK: - StoreKit Integration

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.handleTransaction(transaction)
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    private func handleTransaction(_ transaction: Transaction) async {
        await MainActor.run {
            isLoading = true
        }

        let productType = transaction.productType

        switch productType {
        case .autoRenewable:
            if transaction.revocationDate == nil {
                // Active subscription
                await MainActor.run {
                    updateSubscriptionStatus(to: .subscribed)
                    updateSubscriptionTier(to: .pro)
                }
            } else {
                // Revoked subscription
                await MainActor.run {
                    updateSubscriptionStatus(to: .cancelled)
                    updateSubscriptionTier(to: .free)
                }
            }
        default:
            break
        }

        await MainActor.run {
            isLoading = false
        }
    }
    
    // MARK: - Purchase Methods
    
    func purchase(plan: SubscriptionPlan, isYearly: Bool = false) async throws {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let productId = isYearly ? plan.productId.replacingOccurrences(of: ".monthly", with: ".yearly") : plan.productId
        
        guard let product = try await fetchProduct(productId: productId) else {
            throw SubscriptionError.productNotFound
        }
        
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try await MainActor.run {
                try checkVerified(verification)
            }
            
            // Update trial status if applicable
            if let trialPeriod = product.subscription?.introductoryOffer?.period {
                await MainActor.run {
                    startTrial(days: trialPeriod.value)
                }
            }
            
            await handleTransaction(transaction)
            
        case .userCancelled:
            await MainActor.run {
                errorMessage = "Purchase was cancelled"
            }

        case .pending:
            await MainActor.run {
                errorMessage = "Purchase is pending approval"
            }

        @unknown default:
            await MainActor.run {
                errorMessage = "Unknown purchase result"
            }
        }
    }
    
    private func fetchProduct(productId: String) async throws -> Product? {
        let products = try await Product.products(for: [productId])
        return products.first
    }
    
    // MARK: - Trial Management
    
    private func startTrial(days: Int) {
        isTrialActive = true
        trialDaysRemaining = days
        let endDate = Date().addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
        UserDefaults.standard.set(endDate, forKey: trialEndDateKey)
        UserDefaults.standard.set(true, forKey: trialActiveKey)
        updateSubscriptionStatus(to: .inTrial)
    }
    
    func updateTrialDaysRemaining() {
        guard isTrialActive,
              let endDate = UserDefaults.standard.object(forKey: trialEndDateKey) as? Date else {
            return
        }
        
        let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        
        if remainingDays <= 0 {
            isTrialActive = false
            trialDaysRemaining = 0
            subscriptionStatus = .expired
            currentTier = .free
            UserDefaults.standard.set(false, forKey: trialActiveKey)
        } else {
            trialDaysRemaining = remainingDays
        }
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        defer {
            Task { @MainActor in
                isLoading = false
            }
        }

        do {
            try await AppStore.sync()
            // Transaction listener will handle the restoration
        } catch {
            await MainActor.run {
                errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Subscription State Management
    
    private func updateSubscriptionStatus(to status: SubscriptionStatus) {
        subscriptionStatus = status
        UserDefaults.standard.set(status.rawValue, forKey: subscriptionStatusKey)
    }

    private func updateSubscriptionTier(to tier: SubscriptionTier) {
        currentTier = tier
        UserDefaults.standard.set(tier.rawValue, forKey: subscriptionTierKey)
    }
    
    private func loadSubscriptionState() {
        if let statusString = UserDefaults.standard.string(forKey: subscriptionStatusKey),
           let status = SubscriptionStatus(rawValue: statusString) {
            subscriptionStatus = status
        }
        
        if let tierString = UserDefaults.standard.string(forKey: subscriptionTierKey),
           let tier = SubscriptionTier(rawValue: tierString) {
            currentTier = tier
        }
        
        isTrialActive = UserDefaults.standard.bool(forKey: trialActiveKey)
        if isTrialActive {
            updateTrialDaysRemaining()
        }
    }
    
    // MARK: - Mock for Testing (Remove in production)
    func setMockSubscription(isPro: Bool) {
        currentTier = isPro ? .pro : .free
        subscriptionStatus = isPro ? .subscribed : .notSubscribed
        UserDefaults.standard.set(currentTier.rawValue, forKey: subscriptionTierKey)
        UserDefaults.standard.set(subscriptionStatus.rawValue, forKey: subscriptionStatusKey)
    }
}

enum SubscriptionError: LocalizedError {
    case verificationFailed
    case productNotFound
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .verificationFailed:
            return "Transaction verification failed"
        case .productNotFound:
            return "Product not found"
        case .purchaseFailed:
            return "Purchase failed"
        }
    }
}
