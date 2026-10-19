import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var selectedPlan: SubscriptionPlan?
    @State private var isYearlyBilling = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    planCards

                    featuresSection

                    subscribeButton

                    restoreButton
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Upgrade to Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: Binding(
                get: { subscriptionManager.errorMessage != nil },
                set: { if !$0 { subscriptionManager.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = subscriptionManager.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundStyle(.purple)
            
            Text("Unlock Your Creative Potential")
                .font(.googleSansFlex(.title2, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Get access to premium templates, advanced editing tools, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var planCards: some View {
        VStack(spacing: 16) {
            ForEach(SubscriptionPlan.plans) { plan in
                PlanCard(
                    plan: plan,
                    isYearly: isYearlyBilling,
                    isSelected: selectedPlan?.id == plan.id
                ) {
                    selectedPlan = plan
                }
            }
        }
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's Included")
                .font(.headline)

            if let plan = selectedPlan {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(plan.tier.features, id: \.self) { feature in
                        FeatureRow(icon: "checkmark.circle.fill", text: feature)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var subscribeButton: some View {
        Button {
            Task {
                if let plan = selectedPlan {
                    do {
                        try await subscriptionManager.purchase(plan: plan, isYearly: isYearlyBilling)
                        dismiss()
                    } catch {
                        subscriptionManager.errorMessage = error.localizedDescription
                    }
                }
            }
        } label: {
            HStack {
                if subscriptionManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Subscribe to Pro")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedPlan != nil ? Color.purple : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(selectedPlan == nil || subscriptionManager.isLoading)
    }
    
    private var restoreButton: some View {
        Button {
            Task {
                await subscriptionManager.restorePurchases()
            }
        } label: {
            Text("Restore Purchases")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct PlanCard: View {
    let plan: SubscriptionPlan
    let isYearly: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plan.tier.displayName)
                            .font(.headline)
                        
                        if let trialDays = plan.trialDays {
                            Text("\(trialDays)-day free trial")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.purple)
                            .font(.title2)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isYearly ? plan.yearlyPrice : plan.monthlyPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(isYearly ? "per year" : "per month")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    if isYearly {
                        Spacer()
                        Text("Save \(plan.yearlySavings)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(16)
            .background(isSelected ? Color.purple.opacity(0.1) : Color(uiColor: .secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.green)
                .font(.title3)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    SubscriptionView()
}
