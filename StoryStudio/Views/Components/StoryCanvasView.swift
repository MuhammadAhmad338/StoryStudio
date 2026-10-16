import SwiftUI

struct StoryCanvasView: View {
    var colors: [Color] = [.orange, .pink, .purple]
    var backgroundImage: UIImage? = nil
    var backgroundBlur: Double = 0.0
    var overlayOpacity: Double = 0.15
    var title: String = ""
    var subtitle: String = ""
    var sticker: String = "✦"
    var brandName: String = "YOUR BRAND"
    var handle: String = "@YOURUSERNAME"
    var fontDesign: StoryFontDesign = .rounded
    var titleScale: CGFloat = 1.0
    var textAlignment: StoryTextAlignmentOption = .center
    var textColor: Color = .white
    var frameStyle: StoryFrameStyle = .none
    var showVignette: Bool = false

    // Convenience initializer for backwards compatibility with TemplateCardView & simple calls
    init(
        colors: [Color],
        title: String,
        subtitle: String,
        sticker: String
    ) {
        self.colors = colors
        self.backgroundImage = nil
        self.backgroundBlur = 0.0
        self.overlayOpacity = 0.15
        self.title = title
        self.subtitle = subtitle
        self.sticker = sticker
        self.brandName = "YOUR BRAND"
        self.handle = "@YOURUSERNAME"
        self.fontDesign = .rounded
        self.titleScale = 1.0
        self.textAlignment = .center
        self.textColor = .white
        self.frameStyle = .none
        self.showVignette = false
    }

    // Full custom initializer
    init(
        colors: [Color] = [.orange, .pink, .purple],
        backgroundImage: UIImage? = nil,
        backgroundBlur: Double = 0.0,
        overlayOpacity: Double = 0.15,
        title: String,
        subtitle: String,
        sticker: String = "✦",
        brandName: String = "YOUR BRAND",
        handle: String = "@YOURUSERNAME",
        fontDesign: StoryFontDesign = .rounded,
        titleScale: CGFloat = 1.0,
        textAlignment: StoryTextAlignmentOption = .center,
        textColor: Color = .white,
        frameStyle: StoryFrameStyle = .none,
        showVignette: Bool = false
    ) {
        self.colors = colors
        self.backgroundImage = backgroundImage
        self.backgroundBlur = backgroundBlur
        self.overlayOpacity = overlayOpacity
        self.title = title
        self.subtitle = subtitle
        self.sticker = sticker
        self.brandName = brandName
        self.handle = handle
        self.fontDesign = fontDesign
        self.titleScale = titleScale
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.frameStyle = frameStyle
        self.showVignette = showVignette
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height

            ZStack {
                // Background Layer: Image or Gradient
                if let bgImage = backgroundImage {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: w, height: h)
                        .blur(radius: backgroundBlur)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Ambient decorative circle
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: w * 0.85)
                        .offset(x: w * 0.35, y: -h * 0.3)
                }

                // Dark/Light Overlay Tint for Text Legibility
                if overlayOpacity > 0 {
                    Color.black.opacity(overlayOpacity)
                }

                // Vignette Effect
                if showVignette {
                    RadialGradient(
                        colors: [.clear, .black.opacity(0.65)],
                        center: .center,
                        startRadius: w * 0.35,
                        endRadius: h * 0.75
                    )
                }

                // Frame Decorator
                switch frameStyle {
                case .minimal:
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(textColor.opacity(0.35), lineWidth: 2)
                        .padding(w * 0.04)

                case .polaroid:
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: h * 0.16)
                    }
                    .allowsHitTesting(false)

                case .film:
                    HStack {
                        filmPerforations(height: h)
                        Spacer()
                        filmPerforations(height: h)
                    }
                    .padding(.horizontal, 4)

                case .none:
                    EmptyView()
                }

                // Main Content Canvas
                VStack(spacing: 0) {
                    // Header: Brand & Sparkle
                    HStack {
                        if !brandName.isEmpty {
                            Text(brandName.uppercased())
                                .font(.system(
                                    size: max(10, w * 0.033),
                                    weight: .bold,
                                    design: fontDesign.design
                                ))
                                .tracking(2)
                        }

                        Spacer()

                        Image(systemName: "sparkles")
                            .font(.system(size: max(11, w * 0.035)))
                    }

                    Spacer()

                    // Sticker / Badge
                    if !sticker.isEmpty {
                        stickerView(w: w)
                            .padding(.bottom, h * 0.02)
                    }

                    // Headline Title
                    let titleText = title.isEmpty ? "YOUR STORY" : title
                    Text(titleText)
                        .font(.system(
                            size: max(16, w * 0.105 * titleScale),
                            weight: .black,
                            design: fontDesign.design
                        ))
                        .multilineTextAlignment(textAlignment.textAlignment)
                        .frame(maxWidth: .infinity, alignment: textAlignment.alignment)
                        .minimumScaleFactor(0.4)
                        .lineLimit(5)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)

                    // Subtitle
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(
                                size: max(11, w * 0.038),
                                weight: .medium,
                                design: fontDesign.design
                            ))
                            .multilineTextAlignment(textAlignment.textAlignment)
                            .frame(maxWidth: .infinity, alignment: textAlignment.alignment)
                            .lineLimit(4)
                            .padding(.top, h * 0.015)
                            .opacity(0.9)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    }

                    Spacer()

                    // Footer Handle / Username
                    if !handle.isEmpty {
                        HStack {
                            if textAlignment == .trailing { Spacer() }
                            Text(handle.uppercased())
                                .font(.system(
                                    size: max(9, w * 0.028),
                                    weight: .semibold,
                                    design: fontDesign.design
                                ))
                                .opacity(0.85)
                                .tracking(1)
                            if textAlignment == .leading { Spacer() }
                        }
                    }
                }
                .foregroundStyle(textColor)
                .padding(.horizontal, w * 0.09)
                .padding(.vertical, h * 0.07)
            }
            .frame(width: w, height: h)
            .clipped()
        }
    }

    // Sticker rendering: handles emojis, unicode symbols, or text badges (e.g., "SALE", "NEW")
    @ViewBuilder
    private func stickerView(w: CGFloat) -> some View {
        if sticker.count > 2 {
            // Text badge style
            Text(sticker)
                .font(.system(size: max(11, w * 0.035), weight: .heavy, design: .rounded))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(textColor)
                .foregroundStyle(colors.first ?? .black)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        } else {
            // Iconic symbol / emoji style
            Text(sticker)
                .font(.system(size: max(24, w * 0.16)))
                .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
        }
    }

    // Film border perforations
    private func filmPerforations(height: CGFloat) -> some View {
        VStack(spacing: 8) {
            ForEach(0..<18, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.white.opacity(0.45))
                    .frame(width: 5, height: 7)
            }
        }
        .padding(.vertical, 10)
    }
}
