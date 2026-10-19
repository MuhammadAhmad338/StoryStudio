import SwiftUI

struct SettingsView: View {
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showSubscriptionSheet = false

    var body: some View {
        NavigationStack {
            List {
                subscriptionSection

                Section {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.purple)
                            .frame(width: 30)
                        Text("Subscription Status")
                        Spacer()
                        Text(subscriptionManager.currentTier.displayName)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Account")
                }

                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .frame(width: 30)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showSubscriptionSheet) {
                SubscriptionView()
            }
        }
    }

    private var subscriptionSection: some View {
        Section {
            if subscriptionManager.isSubscribed {
                Button {
                    // Manage subscription (opens App Store subscription management)
                    if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "creditcard")
                            .frame(width: 30)
                        Text("Manage Subscription")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }

                if subscriptionManager.isTrialActive {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.orange)
                            .frame(width: 30)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Trial Active")
                                .font(.subheadline)
                            Text("\(subscriptionManager.trialDaysRemaining) days remaining")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } else {
                Button {
                    showSubscriptionSheet = true
                } label: {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.purple)
                            .frame(width: 30)
                        Text("Upgrade to Premium")
                            .foregroundStyle(.purple)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }

                Button {
                    Task {
                        await subscriptionManager.restorePurchases()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 30)
                        Text("Restore Purchases")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } header: {
            Text("Subscription")
        }
    }
}

#Preview {
    SettingsView()
}
