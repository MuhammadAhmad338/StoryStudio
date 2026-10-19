import SwiftUI

struct TemplateCardView: View {
    let template: StoryTemplate
    var onToggleFavorite: (() -> Void)? = nil
    var onUpgrade: (() -> Void)? = nil
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                StoryCanvasView(
                    colors: template.colors,
                    title: template.title,
                    subtitle: template.subtitle,
                    sticker: template.sticker
                )
                .aspectRatio(9.0 / 16.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

                if template.isPremium && !subscriptionManager.hasProAccess {
                    LockOverlay()
                        .frame(width: 80, height: 80)
                }

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    onToggleFavorite?()
                } label: {
                    Image(systemName: template.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 17))
                        .foregroundStyle(template.isFavorite ? .red : .white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.45))
                        )
                }
                .buttonStyle(.plain)
                .padding(8)
            }

            HStack {
                Text(template.name)
                    .font(.googleSansFlex(.subheadline, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer()

                if template.isPremium {
                    PremiumBadge()
                }
            }

            Text(template.category)
                .font(.googleSansFlex(.caption))
                .foregroundStyle(.secondary)
        }
    }
}
