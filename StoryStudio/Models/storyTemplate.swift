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
            name: "Midnight Spark",
            category: "Promotions",
            colors: [.black, .purple],
            title: "SOMETHING\nGOOD IS HERE",
            subtitle: "Stay tuned for what's coming next.",
            sticker: "✦",
            isFavorite: false
        ),
        StoryTemplate(
            id: "forest",
            name: "Forest Mist",
            category: "Lifestyle",
            colors: [.green, .mint, .teal],
            title: "GROW\nEVERYDAY",
            subtitle: "Nature's beauty in every story.",
            sticker: "❋",
            isFavorite: false
        ),
        StoryTemplate(
            id: "rose",
            name: "Rose Quartz",
            category: "Promotions",
            colors: [.pink, .red, .orange],
            title: "LIVE YOUR\nBEST LIFE",
            subtitle: "Embrace every vibrant moment.",
            sticker: "♡",
            isFavorite: false
        ),
        StoryTemplate(
            id: "aurora",
            name: "Nordic Aurora",
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
        ),
        StoryTemplate(
            id: "cyberpunk",
            name: "Cyber Neon",
            category: "Tech",
            colors: [
                Color(red: 0.08, green: 0.05, blue: 0.2),
                Color(red: 0.6, green: 0.1, blue: 0.9),
                Color(red: 0.1, green: 0.9, blue: 0.8)
            ],
            title: "FUTURE IS\nLOADING...",
            subtitle: "Next-gen creative drops tonight.",
            sticker: "⚡",
            isFavorite: false
        ),
        StoryTemplate(
            id: "vintage_paper",
            name: "Vintage Editorial",
            category: "Quotes",
            colors: [
                Color(red: 0.25, green: 0.22, blue: 0.2),
                Color(red: 0.45, green: 0.38, blue: 0.32)
            ],
            title: "THE POWER OF\nSTILLNESS",
            subtitle: "In silence, answers find you.",
            sticker: "❦",
            isFavorite: false
        ),
        StoryTemplate(
            id: "flash_drop",
            name: "Flash Drop",
            category: "Promotions",
            colors: [
                Color(red: 0.98, green: 0.2, blue: 0.35),
                Color(red: 0.5, green: 0.0, blue: 0.4)
            ],
            title: "LIMITED\nEDITION",
            subtitle: "Available for the next 24 hours.",
            sticker: "SALE",
            isFavorite: false
        ),
        StoryTemplate(
            id: "zen_wellness",
            name: "Zen Clarity",
            category: "Lifestyle",
            colors: [
                Color(red: 0.82, green: 0.88, blue: 0.85),
                Color(red: 0.65, green: 0.78, blue: 0.75)
            ],
            title: "INHALE PEACE\nEXHALE CHAOS",
            subtitle: "A mindful checkpoint for your day.",
            sticker: "𑁍",
            isFavorite: false
        )
    ]
}
