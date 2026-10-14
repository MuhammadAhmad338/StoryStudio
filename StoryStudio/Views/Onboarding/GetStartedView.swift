import SwiftUI

struct GetStartedView: View {
    let onComplete: () -> Void
    @State private var selectedTemplate: String?

    private let templates = [
        ("photo.stack", "Photo Story", "Create stunning photo narratives"),
        ("text.bubble", "Text Story", "Share your thoughts beautifully"),
        ("chart.bar.fill", "Data Story", "Visualize your data"),
        ("wand.and.stars", "Creative", "Start from scratch")
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text("Let's Get Started")
                    .font(.googleSansFlex(size: 32, weight: .bold))
                    .padding(.top, 40)

                Text("Choose how you want to create your first story")
                    .font(.googleSansFlex(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 30)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(templates, id: \.1) { template in
                        TemplateSelectionCard(
                            icon: template.0,
                            title: template.1,
                            description: template.2,
                            isSelected: selectedTemplate == template.1
                        ) {
                            selectedTemplate = template.1
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            VStack(spacing: 16) {
                Button {
                    onComplete()
                } label: {
                    Text("Continue")
                        .font(.googleSansFlex(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedTemplate != nil ? Color.purple : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(selectedTemplate == nil)

                Button {
                    onComplete()
                } label: {
                    Text("Skip for now")
                        .font(.googleSansFlex(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            #if os(iOS)
            .background(Color(.systemBackground))
            #else
            .background(Color(NSColor.textBackgroundColor))
            #endif
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #else
        .background(Color(NSColor.controlBackgroundColor))
        #endif
    }
}

struct TemplateSelectionCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? .white : .purple)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? Color.purple : Color.purple.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.googleSansFlex(size: 16, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : .primary)

                    Text(description)
                        .font(.googleSansFlex(size: 14))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            .padding(16)
            #if os(iOS)
            .background(isSelected ? Color.purple : Color(.systemBackground))
            #else
            .background(isSelected ? Color.purple : Color(NSColor.textBackgroundColor))
            #endif
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GetStartedView {}
}
