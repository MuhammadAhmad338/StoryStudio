import SwiftUI
import PhotosUI
#if canImport(UIKit)
import UIKit
#endif
import Combine

@MainActor
final class StoryEditorViewModel: ObservableObject {
    // Content state
    @Published var title: String
    @Published var subtitle: String
    @Published var brandName: String = "STORYSTUDIO"
    @Published var handle: String = "@YOURHANDLE"
    @Published var sticker: String

    // Style & Canvas state
    @Published var backgroundIndex = 0
    @Published var customGradientColors: [Color]?
    @Published var backgroundImage: UIImage? = nil
    @Published var selectedPhotoItem: PhotosPickerItem? = nil {
        didSet {
            loadPhotoFromItem()
        }
    }
    @Published var backgroundBlur: Double = 0.0
    @Published var overlayOpacity: Double = 0.15
    @Published var fontDesign: StoryFontDesign = .rounded
    @Published var titleScale: CGFloat = 1.0
    @Published var textAlignment: StoryTextAlignmentOption = .center
    @Published var textColor: Color = .white
    @Published var frameStyle: StoryFrameStyle = .none
    @Published var aspectRatio: StoryAspectRatio = .story9x16
    @Published var showVignette: Bool = false

    // Export & Toast feedback state
    @Published var exportedURL: URL?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isSavedToCreations = false

    var currentStoryID: UUID? = nil
    let template: StoryTemplate?

    let backgrounds: [[Color]] = [
        [.orange, .pink, .purple],
        [.black, .purple],
        [.cyan, .blue, .indigo],
        [.green, .mint, .teal],
        [Color(red: 0.96, green: 0.91, blue: 0.83), Color(red: 0.85, green: 0.70, blue: 0.58)],
        [Color(red: 0.08, green: 0.05, blue: 0.2), Color(red: 0.6, green: 0.1, blue: 0.9), Color(red: 0.1, green: 0.9, blue: 0.8)],
        [.pink, .red, .orange],
        [.purple, .blue, .cyan],
        [.yellow, .orange, .red],
        [Color(red: 0.1, green: 0.12, blue: 0.15), Color(red: 0.2, green: 0.25, blue: 0.35)]
    ]

    // Init from Template
    init(template: StoryTemplate) {
        self.template = template
        self.title = template.title
        self.subtitle = template.subtitle
        self.sticker = template.sticker
        self.currentStoryID = UUID()

        // Match template background colors if exists
        if let idx = backgrounds.firstIndex(where: { $0.count == template.colors.count && $0.first == template.colors.first }) {
            self.backgroundIndex = idx
        } else {
            self.backgroundIndex = 0
            self.customGradientColors = template.colors
        }
    }

    // Init from SavedStory
    init(savedStory: SavedStory) {
        self.template = nil
        self.currentStoryID = savedStory.id
        self.title = savedStory.title
        self.subtitle = savedStory.subtitle
        self.brandName = savedStory.brandName
        self.handle = savedStory.handle
        self.sticker = savedStory.sticker
        self.textColor = savedStory.textColor
        self.fontDesign = savedStory.fontDesign
        self.textAlignment = savedStory.textAlignment
        self.aspectRatio = savedStory.aspectRatio
        self.frameStyle = savedStory.frameStyle
        self.backgroundBlur = savedStory.backgroundBlur
        self.overlayOpacity = savedStory.overlayOpacity
        self.showVignette = savedStory.showVignette

        // Load background image if saved
        if let filename = savedStory.imageFilename {
            self.backgroundImage = CreationsManager.shared.loadImageFromDisk(filename: filename)
        }

        // Match colors
        if let match = backgrounds.firstIndex(where: {
            $0.map { $0.toHex() } == savedStory.colorHexes
        }) {
            self.backgroundIndex = match
        } else {
            self.backgroundIndex = 0
            self.customGradientColors = savedStory.colors
        }
    }

    // Init Blank Canvas
    init() {
        self.template = nil
        self.currentStoryID = UUID()
        self.title = "NEW STORY"
        self.subtitle = "Tap to edit your inspirational story."
        self.sticker = ""
        self.brandName = "STORYSTUDIO"
        self.handle = "@YOURHANDLE"
        self.backgroundIndex = 0
    }

    var currentBackgroundColors: [Color] {
        if let customGradientColors {
            return customGradientColors
        }
        if backgrounds.indices.contains(backgroundIndex) {
            return backgrounds[backgroundIndex]
        }
        return [.purple, .indigo]
    }

    func selectBackgroundPalette(at index: Int) {
        guard backgrounds.indices.contains(index) else { return }
        backgroundImage = nil
        customGradientColors = nil
        backgroundIndex = index
    }

    func updateGradientColor(at index: Int, to color: Color) {
        var colors = currentBackgroundColors
        guard colors.indices.contains(index) else { return }
        colors[index] = color
        customGradientColors = colors
        backgroundImage = nil
    }

    func addGradientColor() {
        guard currentBackgroundColors.count < 5 else { return }
        customGradientColors = currentBackgroundColors + [currentBackgroundColors.last ?? .purple]
        backgroundImage = nil
    }

    func removeGradientColor(at index: Int) {
        var colors = currentBackgroundColors
        guard colors.count > 2, colors.indices.contains(index) else { return }
        colors.remove(at: index)
        customGradientColors = colors
        backgroundImage = nil
    }

    // MARK: - Photos Loading
    private func loadPhotoFromItem() {
        guard let item = selectedPhotoItem else { return }
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.backgroundImage = image
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load selected photo."
                }
            }
        }
    }

    func removeBackgroundImage() {
        self.backgroundImage = nil
        self.selectedPhotoItem = nil
    }

    // MARK: - Surprise Me / Inspiration Shuffle
    func surpriseMe() {
        let inspirationalQuotes = [
            ("DO WHAT YOU LOVE", "The journey is where happiness lives."),
            ("STAY HUNGRY\nSTAY FOOLISH", "Never stop learning and exploring."),
            ("EMBRACE THE\nUNKNOWN", "Great things never came from comfort zones."),
            ("MAKE MAGIC\nHAPPEN", "Your future self will thank you for trying."),
            ("PEACE OVER\nPERFECTION", "Progress is always better than pause."),
            ("MANIFEST\nYOUR DREAMS", "Energy flows where focus goes.")
        ]

        let stickers = ["✦", "✧", "✳", "♡", "☼", "❋", "⚡", "SALE", "VIBES", "𑁍"]
        let fonts = StoryFontDesign.allCases

        let randomQuote = inspirationalQuotes.randomElement()!
        title = randomQuote.0
        subtitle = randomQuote.1
        sticker = stickers.randomElement()!
        fontDesign = fonts.randomElement()!
        backgroundIndex = Int.random(in: 0..<backgrounds.count)
        backgroundImage = nil

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    // MARK: - Save to My Creations
    func saveToCreations() {
        let storyID = currentStoryID ?? UUID()
        currentStoryID = storyID

        let story = SavedStory(
            id: storyID,
            createdAt: Date(),
            title: title,
            subtitle: subtitle,
            brandName: brandName,
            handle: handle,
            sticker: sticker,
            colors: currentBackgroundColors,
            textColor: textColor,
            fontDesign: fontDesign,
            textAlignment: textAlignment,
            aspectRatio: aspectRatio,
            frameStyle: frameStyle,
            backgroundBlur: backgroundBlur,
            overlayOpacity: overlayOpacity,
            showVignette: showVignette,
            imageFilename: nil
        )

        CreationsManager.shared.saveStory(story, backgroundImage: backgroundImage)
        isSavedToCreations = true
        successMessage = "Saved to My Creations!"

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    // MARK: - Save to Photos Library
    func saveToPhotoLibrary() {
        guard let image = renderStoryImage() else {
            errorMessage = "Unable to render story."
            return
        }

        UIImageWriteToSavedPhotosAlbum(
            image,
            nil,
            nil,
            nil
        )

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        successMessage = "Saved directly to Photos!"
    }

    // MARK: - Export Story PNG for Sharing
    func exportStory() {
        guard let image = renderStoryImage(),
              let data = image.pngData() else {
            errorMessage = "Unable to generate image."
            return
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("StoryStudio-\(UUID().uuidString).png")

        do {
            try data.write(to: url, options: .atomic)
            exportedURL = url
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Render Canvas into UIImage at High Resolution (1080x1920 or matching aspect ratio)
    private func renderStoryImage() -> UIImage? {
        let canvasWidth: CGFloat = 1080
        let canvasHeight: CGFloat = canvasWidth / aspectRatio.ratio

        let canvas = StoryCanvasView(
            colors: currentBackgroundColors,
            backgroundImage: backgroundImage,
            backgroundBlur: backgroundBlur,
            overlayOpacity: overlayOpacity,
            title: title,
            subtitle: subtitle,
            sticker: sticker,
            brandName: brandName,
            handle: handle,
            fontDesign: fontDesign,
            titleScale: titleScale,
            textAlignment: textAlignment,
            textColor: textColor,
            frameStyle: frameStyle,
            showVignette: showVignette
        )
        .frame(width: canvasWidth, height: canvasHeight)

        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 1.0
        return renderer.uiImage
    }
}
