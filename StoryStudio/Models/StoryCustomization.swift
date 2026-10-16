import SwiftUI

enum StoryFontDesign: String, CaseIterable, Identifiable, Codable {
    case rounded = "Rounded"
    case sans = "Modern Sans"
    case serif = "Editorial Serif"
    case monospaced = "Retro Mono"

    var id: String { rawValue }

    var design: Font.Design {
        switch self {
        case .rounded: return .rounded
        case .sans: return .default
        case .serif: return .serif
        case .monospaced: return .monospaced
        }
    }
}

enum StoryAspectRatio: String, CaseIterable, Identifiable, Codable {
    case story9x16 = "Story 9:16"
    case square1x1 = "Post 1:1"
    case portrait4x5 = "Feed 4:5"

    var id: String { rawValue }

    var ratio: CGFloat {
        switch self {
        case .story9x16: return 9.0 / 16.0
        case .square1x1: return 1.0
        case .portrait4x5: return 4.0 / 5.0
        }
    }

    var iconName: String {
        switch self {
        case .story9x16: return "iphone"
        case .square1x1: return "square"
        case .portrait4x5: return "rectangle.portrait"
        }
    }
}

enum StoryFrameStyle: String, CaseIterable, Identifiable, Codable {
    case none = "None"
    case minimal = "Thin Minimal"
    case polaroid = "Polaroid"
    case film = "Film Strip"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .none: return "slash.circle"
        case .minimal: return "square"
        case .polaroid: return "photo.artframe"
        case .film: return "film"
        }
    }
}

enum StoryTextAlignmentOption: String, CaseIterable, Identifiable, Codable {
    case leading = "Left"
    case center = "Center"
    case trailing = "Right"

    var id: String { rawValue }

    var textAlignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var alignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var systemImage: String {
        switch self {
        case .leading: return "text.alignleft"
        case .center: return "text.aligncenter"
        case .trailing: return "text.alignright"
        }
    }
}

struct StoryColorOption: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let hex: String

    init(name: String, color: Color) {
        self.name = name
        self.color = color
        self.hex = color.toHex()
    }

    static let textOptions: [StoryColorOption] = [
        StoryColorOption(name: "Pure White", color: .white),
        StoryColorOption(name: "Charcoal", color: Color(red: 0.12, green: 0.12, blue: 0.14)),
        StoryColorOption(name: "Gold Champagne", color: Color(red: 0.98, green: 0.85, blue: 0.55)),
        StoryColorOption(name: "Electric Lavender", color: Color(red: 0.82, green: 0.65, blue: 1.0)),
        StoryColorOption(name: "Sunset Coral", color: Color(red: 1.0, green: 0.55, blue: 0.45)),
        StoryColorOption(name: "Mint Frost", color: Color(red: 0.6, green: 0.95, blue: 0.82)),
        StoryColorOption(name: "Cyber Neon", color: Color(red: 0.35, green: 1.0, blue: 0.75))
    ]
}
