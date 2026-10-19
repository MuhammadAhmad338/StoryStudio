import SwiftUI

struct LockedFeatureView: View {
    let featureName: String
    let icon: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(featureName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Premium Feature")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
                
                Spacer()
                
                Image(systemName: "lock.fill")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LockOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)

            VStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundStyle(.white)

                Text("PRO")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.caption2)
            Text("PRO")
                .font(.caption2)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.purple)
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
}

struct UpgradePromptView: View {
    let title: String
    let message: String
    let onUpgrade: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.purple)
                
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button(action: onUpgrade) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: onDismiss) {
                    Text("Maybe Later")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(24)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        LockedFeatureView(featureName: "Custom Gradients", icon: "paintpalette.fill") {
            print("Upgrade tapped")
        }
        
        PremiumBadge()
        
        UpgradePromptView(
            title: "Unlock Premium Features",
            message: "Get access to 50+ templates, advanced editing tools, and more with StoryStudio Pro.",
            onUpgrade: { print("Upgrade") },
            onDismiss: { print("Dismiss") }
        )
    }
    .padding()
}
