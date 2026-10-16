import SwiftUI

struct SavedStory: Identifiable, Codable {
    let id: UUID
    var createdAt: Date
    var title: String
    var subtitle: String
    var brandName: String
    var handle: String
    var sticker: String
    var colorHexes: [String]
    var textColorHex: String
    var fontDesign: StoryFontDesign
    var textAlignment: StoryTextAlignmentOption
    var aspectRatio: StoryAspectRatio
    var frameStyle: StoryFrameStyle
    var backgroundBlur: Double
    var overlayOpacity: Double
    var showVignette: Bool
    var imageFilename: String?

    var colors: [Color] {
        if colorHexes.isEmpty {
            return [.purple, .indigo]
        }
        return colorHexes.map { Color(hex: $0) }
    }

    var textColor: Color {
        Color(hex: textColorHex)
    }

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        title: String,
        subtitle: String,
        brandName: String = "STORYSTUDIO",
        handle: String = "@YOURHANDLE",
        sticker: String = "✦",
        colors: [Color],
        textColor: Color = .white,
        fontDesign: StoryFontDesign = .rounded,
        textAlignment: StoryTextAlignmentOption = .center,
        aspectRatio: StoryAspectRatio = .story9x16,
        frameStyle: StoryFrameStyle = .none,
        backgroundBlur: Double = 0.0,
        overlayOpacity: Double = 0.15,
        showVignette: Bool = false,
        imageFilename: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.subtitle = subtitle
        self.brandName = brandName
        self.handle = handle
        self.sticker = sticker
        self.colorHexes = colors.map { $0.toHex() }
        self.textColorHex = textColor.toHex()
        self.fontDesign = fontDesign
        self.textAlignment = textAlignment
        self.aspectRatio = aspectRatio
        self.frameStyle = frameStyle
        self.backgroundBlur = backgroundBlur
        self.overlayOpacity = overlayOpacity
        self.showVignette = showVignette
        self.imageFilename = imageFilename
    }
}
