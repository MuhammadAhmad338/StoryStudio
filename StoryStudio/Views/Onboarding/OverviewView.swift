import SwiftUI

struct OverviewView: View {
    let onNext: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.purple)

                    Text("Welcome to StoryStudio")
                        .font(.googleSansFlex(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)

                    Text("Create beautiful, engaging stories with our intuitive editor")
                        .font(.googleSansFlex(size: 18, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 40)

                VStack(spacing: 24) {
                    FeatureCard(
                        icon: "rectangle.stack.fill",
                        title: "Template Library",
                        description: "Choose from multiple pre-designed templates across categories"
                    )

                    FeatureCard(
                        icon: "pencil",
                        title: "Custom Text",
                        description: "Edit headlines and subtitles to tell your story"
                    )

                    FeatureCard(
                        icon: "paintpalette.fill",
                        title: "Gradient Backgrounds",
                        description: "Select from 5 beautiful gradient color schemes"
                    )

                    FeatureCard(
                        icon: "sparkles",
                        title: "Decorative Stickers",
                        description: "Add decorative stickers to enhance your stories"
                    )

                    FeatureCard(
                        icon: "square.and.arrow.up",
                        title: "Export to PNG",
                        description: "Save your stories as high-quality PNG images"
                    )

                    FeatureCard(
                        icon: "paperplane.fill",
                        title: "Share Directly",
                        description: "Share your creations instantly from the app"
                    )
                }
                .padding(.horizontal, 20)

                Spacer()

                Button {
                    onNext("getStarted")
                } label: {
                    Text("Get Started")
                        .font(.googleSansFlex(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(NSColor.controlBackgroundColor))
        #endif
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(.purple)
                .frame(width: 60, height: 60)
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.googleSansFlex(size: 18, weight: .semibold))

                Text(description)
                    .font(.googleSansFlex(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(NSColor.textBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    OverviewView { _ in }
}
