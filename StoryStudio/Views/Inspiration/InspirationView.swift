import SwiftUI

struct InspirationItem: Identifiable {
    let id = UUID()
    let category: String
    let quote: String
    let author: String
    let colors: [Color]
    let sticker: String
}

struct InspirationView: View {
    @State private var selectedQuote: InspirationItem? = nil
    @State private var activeStoryTemplate: StoryTemplate? = nil

    private let dailyInspirations: [InspirationItem] = [
        InspirationItem(
            category: "Mindset",
            quote: "Small daily improvements over time lead to stunning results.",
            author: "Robin Sharma",
            colors: [.orange, .pink, .purple],
            sticker: "✦"
        ),
        InspirationItem(
            category: "Creativity",
            quote: "Creativity is intelligence having fun.",
            author: "Albert Einstein",
            colors: [.cyan, .blue, .indigo],
            sticker: "✳"
        ),
        InspirationItem(
            category: "Courage",
            quote: "Everything you've ever wanted is sitting on the other side of fear.",
            author: "George Addair",
            colors: [.purple, .indigo, .black],
            sticker: "⚡"
        ),
        InspirationItem(
            category: "Minimalism",
            quote: "Simplicity is the ultimate sophistication.",
            author: "Leonardo da Vinci",
            colors: [Color(red: 0.96, green: 0.91, blue: 0.83), Color(red: 0.85, green: 0.70, blue: 0.58)],
            sticker: "𑁍"
        ),
        InspirationItem(
            category: "Growth",
            quote: "The only limit to our realization of tomorrow will be our doubts of today.",
            author: "F.D. Roosevelt",
            colors: [.green, .mint, .teal],
            sticker: "❋"
        )
    ]

    private let paletteSuggestions: [([Color], String)] = [
        ([.orange, .pink, .purple], "Sunset Serenade"),
        ([.cyan, .blue, .indigo], "Ocean Drift"),
        ([.mint, .teal, .blue], "Fresh Glacier"),
        ([.purple, .blue, .cyan], "Northern Lights"),
        ([Color(red: 0.98, green: 0.2, blue: 0.35), Color(red: 0.5, green: 0.0, blue: 0.4)], "Berry Velvet"),
        ([Color(red: 0.08, green: 0.05, blue: 0.2), Color(red: 0.6, green: 0.1, blue: 0.9)], "Cyber Neon")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    // Header card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .font(.googleSansFlex(.title2))
                                .foregroundStyle(.yellow)
                            Text("Daily Studio Inspiration")
                                .font(.googleSansFlex(.headline))
                        }

                        Text("Fresh ideas, curated quotes, and color schemes to spark your next viral story.")
                            .font(.googleSansFlex(.subheadline))
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Quotes Carousel / Cards
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Quote of the Day")
                            .font(.googleSansFlex(.title3, weight: .bold))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(dailyInspirations) { item in
                                    VStack(alignment: .leading, spacing: 14) {
                                        HStack {
                                            Text(item.category.uppercased())
                                                .font(.googleSansFlex(.caption2, weight: .bold))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.white.opacity(0.25))
                                                .clipShape(Capsule())

                                            Spacer()

                                            Text(item.sticker)
                                                .font(.googleSansFlex(.headline))
                                        }

                                        Text("\"\(item.quote)\"")
                                            .font(.googleSansFlex(.headline))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(4)
                                            .fixedSize(horizontal: false, vertical: true)

                                        Text("— \(item.author)")
                                            .font(.googleSansFlex(.caption))
                                            .opacity(0.85)

                                        Spacer()

                                        Button {
                                            activeStoryTemplate = StoryTemplate(
                                                id: item.id.uuidString,
                                                name: item.category,
                                                category: "Quotes",
                                                colors: item.colors,
                                                title: item.quote.uppercased(),
                                                subtitle: "— \(item.author)",
                                                sticker: item.sticker,
                                                isFavorite: false,
                                                isPremium: false
                                            )
                                        } label: {
                                            HStack {
                                                Text("Create with Quote")
                                                Image(systemName: "arrow.right.circle.fill")
                                            }
                                            .font(.googleSansFlex(.subheadline, weight: .bold))
                                            .foregroundStyle(item.colors.first ?? .black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .foregroundStyle(.white)
                                    .padding(18)
                                    .frame(width: 260, height: 260)
                                    .background(
                                        LinearGradient(
                                            colors: item.colors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: Color.black.opacity(0.14), radius: 10, y: 5)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    // Curated Color Palettes
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Trending Color Palettes")
                            .font(.googleSansFlex(.title3, weight: .bold))

                        ForEach(paletteSuggestions, id: \.1) { palette in
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: palette.0,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(palette.1)
                                        .font(.googleSansFlex(.subheadline, weight: .bold))
                                    Text("\(palette.0.count) harmonious gradient tones")
                                        .font(.googleSansFlex(.caption))
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Button {
                                    activeStoryTemplate = StoryTemplate(
                                        id: UUID().uuidString,
                                        name: palette.1,
                                        category: "Lifestyle",
                                        colors: palette.0,
                                        title: "YOUR STORY",
                                        subtitle: "Designed with \(palette.1)",
                                        sticker: "✦",
                                        isFavorite: false,
                                        isPremium: false
                                    )
                                } label: {
                                    Text("Use")
                                        .font(.googleSansFlex(.subheadline, weight: .bold))
                                        .foregroundStyle(.purple)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(Color.purple.opacity(0.12))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    // Best practices / Tips card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Story Creator Tips")
                            .font(.googleSansFlex(.headline))

                        tipRow(icon: "text.aligncenter", tip: "Keep headlines under 5 words for instant readability.")
                        tipRow(icon: "photo.fill", tip: "Use blur on busy photos so viewers focus on your message.")
                        tipRow(icon: "slider.horizontal.3", tip: "Add subtle vignettes for a moody cinematic editorial look.")
                    }
                    .padding(18)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Inspiration")
            .navigationDestination(isPresented: Binding(
                get: { activeStoryTemplate != nil },
                set: { if !$0 { activeStoryTemplate = nil } }
            )) {
                if let t = activeStoryTemplate {
                    StoryEditorView(template: t)
                }
            }
        }
    }

    private func tipRow(icon: String, tip: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.purple)
                .frame(width: 22)
            Text(tip)
                .font(.googleSansFlex(.subheadline))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    InspirationView()
}
