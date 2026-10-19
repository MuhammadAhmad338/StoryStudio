import SwiftUI
import StoreKit

enum SubscriptionTier: String, Codable {
    case free = "free"
    case pro = "pro"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .pro: return "Pro"
        }
    }
    
    var features: [String] {
        switch self {
        case .free:
            return [
                "18 Free Templates",
                "10 Gradient Backgrounds",
                "Basic Stickers",
                "Export to PNG",
                "Save Creations",
                "9:16 Aspect Ratio Only",
                "Includes Watermark"
            ]
        case .pro:
            return [
                "23+ Templates (18 Free + 5 Premium)",
                "10 Gradient Backgrounds",
                "Custom Gradient Creator",
                "Multiple Aspect Ratios",
                "Background Blur & Vignette",
                "No Watermark on Exports",
                "Text Alignment Options",
                "Title Size Adjustment"
            ]
        }
    }
}

enum SubscriptionStatus: String, Codable {
    case unknown = "unknown"
    case notSubscribed = "notSubscribed"
    case subscribed = "subscribed"
    case inTrial = "inTrial"
    case expired = "expired"
    case cancelled = "cancelled"
}

struct SubscriptionPlan: Identifiable {
    let id: String
    let tier: SubscriptionTier
    let productId: String
    let monthlyPrice: String
    let yearlyPrice: String
    let yearlySavings: String
    let trialDays: Int?

    static let plans: [SubscriptionPlan] = [
        SubscriptionPlan(
            id: "pro_monthly",
            tier: .pro,
            productId: "com.storystudio.pro.monthly",
            monthlyPrice: "$4.99",
            yearlyPrice: "$39.99",
            yearlySavings: "33%",
            trialDays: 7
        )
    ]
}
