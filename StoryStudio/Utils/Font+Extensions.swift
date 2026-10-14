import SwiftUI

extension Font {
    // Google Sans Flex font extension
    // To use Google Sans Flex:
    // 1. Download Google Sans Flex font files (.ttf or .otf)
    // 2. Add them to the project in Assets.xcassets or directly in the StoryStudio folder
    // 3. Add "Fonts provided by application" key to Info.plist with font filenames
    // 4. Replace the system font below with: .custom("GoogleSansFlex-Regular", size: size)

    static func googleSansFlex(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Using system font as placeholder - replace with custom font once added
        switch weight {
        case .bold:
            return .system(size: size, weight: .bold, design: .rounded)
        case .semibold:
            return .system(size: size, weight: .semibold, design: .rounded)
        case .medium:
            return .system(size: size, weight: .medium, design: .rounded)
        case .light:
            return .system(size: size, weight: .light, design: .rounded)
        default:
            return .system(size: size, weight: .regular, design: .rounded)
        }
    }

    static let googleSansFlexLargeTitle = googleSansFlex(size: 34, weight: .bold)
    static let googleSansFlexTitle = googleSansFlex(size: 28, weight: .bold)
    static let googleSansFlexTitle2 = googleSansFlex(size: 22, weight: .bold)
    static let googleSansFlexTitle3 = googleSansFlex(size: 20, weight: .semibold)
    static let googleSansFlexHeadline = googleSansFlex(size: 17, weight: .semibold)
    static let googleSansFlexBody = googleSansFlex(size: 17, weight: .regular)
    static let googleSansFlexCallout = googleSansFlex(size: 16, weight: .medium)
    static let googleSansFlexSubheadline = googleSansFlex(size: 15, weight: .medium)
    static let googleSansFlexFootnote = googleSansFlex(size: 13, weight: .regular)
    static let googleSansFlexCaption = googleSansFlex(size: 12, weight: .regular)
    static let googleSansFlexCaption2 = googleSansFlex(size: 11, weight: .regular)
}
