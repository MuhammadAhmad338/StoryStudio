import SwiftUI

extension Font {
    static func googleSansFlex(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("GoogleSansFlex-Regular", size: size).weight(weight)
    }

    static func googleSansFlex(_ textStyle: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        let size: CGFloat
        switch textStyle {
        case .largeTitle: size = 34
        case .title: size = 28
        case .title2: size = 22
        case .title3: size = 20
        case .headline: size = 17
        case .subheadline: size = 15
        case .body: size = 17
        case .callout: size = 16
        case .footnote: size = 13
        case .caption: size = 12
        case .caption2: size = 11
        @unknown default: size = 17
        }

        let styleWeight: Font.Weight = textStyle == .headline ? .semibold : weight
        return .custom("GoogleSansFlex-Regular", size: size, relativeTo: textStyle).weight(styleWeight)
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
