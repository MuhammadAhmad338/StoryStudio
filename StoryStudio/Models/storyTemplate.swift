import SwiftUI

struct StoryTemplate: Identifiable {
    let id: String
    let name: String
    let category: String
    let colors: [Color]
    let title: String
    let subtitle: String
    let sticker: String
    var isFavorite: Bool

    static let samples: [StoryTemplate] = [
        StoryTemplate(
            id: "sunset",
            name: "Sunset Glow",
            category: "Lifestyle",
            colors: [.orange, .pink, .purple],
            title: "MAKE TODAY\nBEAUTIFUL",
            subtitle: "A little reminder to enjoy the moment.",
            sticker: "✦",
            isFavorite: false
        ),
        StoryTemplate(
            id: "minimal",
            name: "Soft Minimal",
            category: "Quotes",
            colors: [
                Color(red: 0.96, green: 0.91, blue: 0.83),
                Color(red: 0.85, green: 0.70, blue: 0.58)
            ],
            title: "LESS NOISE.\nMORE LIFE.",
            subtitle: "Find beauty in the simple things.",
            sticker: "✳",
            isFavorite: false
        ),
        StoryTemplate(
            id: "ocean",
            name: "Ocean Blue",
            category: "Announcements",
            colors: [.cyan, .blue, .indigo],
            title: "A FRESH\nNEW START",
            subtitle: "New ideas. New energy.",
            sticker: "✧",
            isFavorite: false
        ),
        StoryTemplate(
            id: "midnight",
            name: "Midnight",
            category: "Promotions",
            colors: [.black, .purple],
            title: "SOMETHING\nGOOD IS HERE",
            subtitle: "Stay tuned for what's coming next.",
            sticker: "✦",
            isFavorite: false
        ),
        StoryTemplate(
            id: "forest",
            name: "Forest Green",
            category: "Lifestyle",
            colors: [.green, .mint, .teal],
            title: "GROW\nEVERYDAY",
            subtitle: "Nature's beauty in every story.",
            sticker: "❋",
            isFavorite: false
        ),
        StoryTemplate(
            id: "rose",
            name: "Rose Gold",
            category: "Promotions",
            colors: [.pink, .red, .orange],
            title: "LIVE YOUR\nBEST LIFE",
            subtitle: "Embrace every moment.",
            sticker: "♡",
            isFavorite: false
        ),
        StoryTemplate(
            id: "aurora",
            name: "Aurora",
            category: "Quotes",
            colors: [.purple, .blue, .cyan],
            title: "DREAM\nBIG",
            subtitle: "Your journey starts here.",
            sticker: "☼",
            isFavorite: false
        ),
        StoryTemplate(
            id: "sunset2",
            name: "Golden Hour",
            category: "Lifestyle",
            colors: [.yellow, .orange, .red],
            title: "CHASE\nTHE SUN",
            subtitle: "Capture the golden moments.",
            sticker: "✦",
            isFavorite: false
        )
    ]
}

