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
        ),
        StoryTemplate(
            id: "coffee_launch",
            name: "Sunday Coffee",
            category: "Food & Drink",
            colors: [
                Color(red: 0.29, green: 0.16, blue: 0.12),
                Color(red: 0.72, green: 0.40, blue: 0.23),
                Color(red: 0.93, green: 0.72, blue: 0.45)
            ],
            title: "A SLOW\nMORNING",
            subtitle: "Your new favorite cup is waiting.",
            sticker: "☕",
            isFavorite: false
        ),
        StoryTemplate(
            id: "coastal_escape",
            name: "Coastal Escape",
            category: "Travel",
            colors: [
                Color(red: 0.08, green: 0.52, blue: 0.67),
                Color(red: 0.25, green: 0.76, blue: 0.78),
                Color(red: 0.93, green: 0.81, blue: 0.62)
            ],
            title: "FIND YOUR\nBLUE",
            subtitle: "A little getaway goes a long way.",
            sticker: "☼",
            isFavorite: false
        ),
        StoryTemplate(
            id: "live_tonight",
            name: "Live Tonight",
            category: "Events",
            colors: [
                Color(red: 0.16, green: 0.09, blue: 0.31),
                Color(red: 0.55, green: 0.13, blue: 0.52),
                Color(red: 0.96, green: 0.30, blue: 0.49)
            ],
            title: "TONIGHT\nWE GLOW",
            subtitle: "Doors open at 8 · See you there.",
            sticker: "✦",
            isFavorite: false
        ),
        StoryTemplate(
            id: "new_arrivals",
            name: "New Arrivals",
            category: "Promotions",
            colors: [
                Color(red: 0.90, green: 0.44, blue: 0.36),
                Color(red: 0.72, green: 0.20, blue: 0.34),
                Color(red: 0.39, green: 0.12, blue: 0.28)
            ],
            title: "THE NEW\nEDIT",
            subtitle: "Fresh finds, just added to the collection.",
            sticker: "NEW",
            isFavorite: false
        ),
        StoryTemplate(
            id: "wellness_reset",
            name: "Daily Reset",
            category: "Wellness",
            colors: [
                Color(red: 0.75, green: 0.83, blue: 0.70),
                Color(red: 0.37, green: 0.59, blue: 0.49),
                Color(red: 0.15, green: 0.39, blue: 0.37)
            ],
            title: "PAUSE.\nBREATHE.",
            subtitle: "Make a little room for yourself today.",
            sticker: "✿",
            isFavorite: false
        ),
        StoryTemplate(
            id: "creative_studio",
            name: "Studio Notes",
            category: "Business",
            colors: [
                Color(red: 0.15, green: 0.23, blue: 0.48),
                Color(red: 0.29, green: 0.45, blue: 0.77),
                Color(red: 0.59, green: 0.72, blue: 0.92)
            ],
            title: "MADE WITH\nINTENTION",
            subtitle: "A peek behind the creative process.",
            sticker: "✎",
            isFavorite: false
        ),
        StoryTemplate(
            id: "weekend_market",
            name: "Weekend Market",
            category: "Food & Drink",
            colors: [
                Color(red: 0.92, green: 0.67, blue: 0.28),
                Color(red: 0.85, green: 0.37, blue: 0.26),
                Color(red: 0.53, green: 0.20, blue: 0.24)
            ],
            title: "FRESH FROM\nTHE MARKET",
            subtitle: "Local favorites for your weekend table.",
            sticker: "✿",
            isFavorite: false
        ),
        StoryTemplate(
            id: "city_break",
            name: "City Break",
            category: "Travel",
            colors: [
                Color(red: 0.12, green: 0.22, blue: 0.33),
                Color(red: 0.25, green: 0.43, blue: 0.54),
                Color(red: 0.91, green: 0.52, blue: 0.34)
            ],
            title: "TAKE THE\nSCENIC ROUTE",
            subtitle: "Somewhere new is closer than you think.",
            sticker: "↗",
            isFavorite: false
        )
    ]
}
