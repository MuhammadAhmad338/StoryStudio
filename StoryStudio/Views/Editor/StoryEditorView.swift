import SwiftUI
import PhotosUI

struct StoryEditorView: View {
    @StateObject private var viewModel: StoryEditorViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: EditorTab = .text
    @State private var customStickerText: String = ""

    enum EditorTab: String, CaseIterable, Identifiable {
        case text = "Typography"
        case background = "Background"
        case stickers = "Stickers"
        case style = "Frames & Style"

        var id: String { rawValue }

        var iconName: String {
            switch self {
            case .text: return "textformat"
            case .background: return "paintpalette"
            case .stickers: return "sparkles"
            case .style: return "slider.horizontal.3"
            }
        }
    }

    init(template: StoryTemplate) {
        _viewModel = StateObject(
            wrappedValue: StoryEditorViewModel(template: template)
        )
    }

    init(savedStory: SavedStory) {
        _viewModel = StateObject(
            wrappedValue: StoryEditorViewModel(savedStory: savedStory)
        )
    }

    init() {
        _viewModel = StateObject(
            wrappedValue: StoryEditorViewModel()
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Live Canvas Preview
                canvasPreviewSection

                // Aspect Ratio Selector
                aspectRatioSelector

                // Editor Tab Bar
                editorTabBar

                // Tool Content based on Selected Tab
                VStack(alignment: .leading, spacing: 18) {
                    switch selectedTab {
                    case .text:
                        textEditingSection
                    case .background:
                        backgroundEditingSection
                    case .stickers:
                        stickersSection
                    case .style:
                        styleSection
                    }
                }
                .padding(18)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // Bottom Action Buttons
                actionButtonsSection
            }
            .padding(18)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Story Studio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.surpriseMe()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "dice.fill")
                        Text("Surprise")
                    }
                    .font(.googleSansFlex(.subheadline, weight: .bold))
                    .foregroundStyle(.purple)
                }
            }
        }
        .alert(
            "Notification",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil || viewModel.successMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil; viewModel.successMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? viewModel.successMessage ?? "")
        }
    }

    // MARK: - Canvas Preview
    private var canvasPreviewSection: some View {
        ZStack {
            StoryCanvasView(
                colors: viewModel.currentBackgroundColors,
                backgroundImage: viewModel.backgroundImage,
                backgroundBlur: viewModel.backgroundBlur,
                overlayOpacity: viewModel.overlayOpacity,
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                sticker: viewModel.sticker,
                brandName: viewModel.brandName,
                handle: viewModel.handle,
                fontDesign: viewModel.fontDesign,
                titleScale: viewModel.titleScale,
                textAlignment: viewModel.textAlignment,
                textColor: viewModel.textColor,
                frameStyle: viewModel.frameStyle,
                showVignette: viewModel.showVignette
            )
            .aspectRatio(viewModel.aspectRatio.ratio, contentMode: .fit)
            .frame(maxHeight: 460)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .shadow(color: Color.black.opacity(0.18), radius: 16, x: 0, y: 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }

    // MARK: - Aspect Ratio Selector
    private var aspectRatioSelector: some View {
        HStack(spacing: 12) {
            ForEach(StoryAspectRatio.allCases) { ratio in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        viewModel.aspectRatio = ratio
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: ratio.iconName)
                        Text(ratio.rawValue)
                    }
                    .font(.googleSansFlex(.caption, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        viewModel.aspectRatio == ratio
                            ? Color.purple
                            : Color(uiColor: .secondarySystemGroupedBackground)
                    )
                    .foregroundStyle(viewModel.aspectRatio == ratio ? .white : .primary)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Editor Tool Tab Bar
    private var editorTabBar: some View {
        HStack(spacing: 8) {
            ForEach(EditorTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 16, weight: .semibold))
                        Text(tab.rawValue)
                            .font(.googleSansFlex(.caption2, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        selectedTab == tab
                            ? Color.purple.opacity(0.15)
                            : Color(uiColor: .secondarySystemGroupedBackground)
                    )
                    .foregroundStyle(selectedTab == tab ? Color.purple : Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedTab == tab ? Color.purple : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - 1. Text Editing Section
    private var textEditingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Headline")
                .font(.googleSansFlex(.subheadline, weight: .bold))
            TextField("Enter headline", text: $viewModel.title, axis: .vertical)
                .textFieldStyle(.roundedBorder)

            Text("Subtitle")
                .font(.googleSansFlex(.subheadline, weight: .bold))
            TextField("Enter subtitle", text: $viewModel.subtitle, axis: .vertical)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Brand / Category")
                        .font(.googleSansFlex(.caption, weight: .bold))
                        .foregroundStyle(.secondary)
                    TextField("Brand Name", text: $viewModel.brandName)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Handle")
                        .font(.googleSansFlex(.caption, weight: .bold))
                        .foregroundStyle(.secondary)
                    TextField("@handle", text: $viewModel.handle)
                        .textFieldStyle(.roundedBorder)
                }
            }

            Divider()

            Text("Typography Style")
                .font(.googleSansFlex(.subheadline, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(StoryFontDesign.allCases) { font in
                        Button {
                            viewModel.fontDesign = font
                        } label: {
                            Text(font.rawValue)
                                .font(.system(size: 13, weight: .semibold, design: font.design))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    viewModel.fontDesign == font
                                        ? Color.purple
                                        : Color(uiColor: .tertiarySystemGroupedBackground)
                                )
                                .foregroundStyle(viewModel.fontDesign == font ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack {
                Text("Alignment")
                    .font(.googleSansFlex(.subheadline, weight: .bold))
                Spacer()
                HStack(spacing: 8) {
                    ForEach(StoryTextAlignmentOption.allCases) { align in
                        Button {
                            viewModel.textAlignment = align
                        } label: {
                            Image(systemName: align.systemImage)
                                .font(.system(size: 15, weight: .bold))
                                .frame(width: 36, height: 32)
                                .background(
                                    viewModel.textAlignment == align
                                        ? Color.purple
                                        : Color(uiColor: .tertiarySystemGroupedBackground)
                                )
                                .foregroundStyle(viewModel.textAlignment == align ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Divider()
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 20) {
                Text("Text Color")
                    .font(.googleSansFlex(.subheadline, weight: .bold))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(StoryColorOption.textOptions) { option in
                            Button {
                                viewModel.textColor = option.color
                            } label: {
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(option.color)
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                        )
                                        .overlay {
                                            if viewModel.textColor == option.color {
                                                Circle()
                                                    .stroke(Color.purple, lineWidth: 3)
                                                    .padding(-4)
                                            }
                                        }
                                    Text(option.name)
                                        .font(.googleSansFlex(size: 10))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .frame(width: 76, height: 28)
                                }
                                .frame(width: 76)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Title Size")
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                    Spacer()
                    Text(String(format: "%.1fx", viewModel.titleScale))
                        .font(.googleSansFlex(.caption).monospaced())
                        .foregroundStyle(.secondary)
                }
                Slider(value: $viewModel.titleScale, in: 0.7...1.5, step: 0.05)
                    .tint(.purple)
            }
        }
    }

    // MARK: - 2. Background Editing Section
    private var backgroundEditingSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Custom Photo Background")
                .font(.googleSansFlex(.subheadline, weight: .bold))

            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $viewModel.selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(
                        viewModel.backgroundImage != nil ? "Replace Photo" : "Choose from Photos",
                        systemImage: "photo.badge.plus"
                    )
                    .font(.googleSansFlex(.subheadline, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if viewModel.backgroundImage != nil {
                    Button(role: .destructive) {
                        viewModel.removeBackgroundImage()
                    } label: {
                        Label("Remove", systemImage: "trash")
                            .font(.googleSansFlex(.subheadline))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.12))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }

            if viewModel.backgroundImage != nil {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Photo Blur")
                            .font(.googleSansFlex(.subheadline, weight: .bold))
                        Spacer()
                        Text("\(Int(viewModel.backgroundBlur)) px")
                            .font(.googleSansFlex(.caption).monospaced())
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $viewModel.backgroundBlur, in: 0...25, step: 1)
                        .tint(.purple)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Dark Tint Overlay")
                            .font(.googleSansFlex(.subheadline, weight: .bold))
                        Spacer()
                        Text("\(Int(viewModel.overlayOpacity * 100))%")
                            .font(.googleSansFlex(.caption).monospaced())
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $viewModel.overlayOpacity, in: 0...0.8, step: 0.05)
                        .tint(.purple)
                }
                Divider()
            }

            Text("Build Your Gradient")
                .font(.googleSansFlex(.subheadline, weight: .bold))

            Text("Choose a palette or customize each color stop.")
                .font(.googleSansFlex(.caption))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                ForEach(viewModel.currentBackgroundColors.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Text("Color \(index + 1)")
                            .font(.googleSansFlex(.subheadline))
                        Spacer()
                        ColorPicker(
                            "Color \(index + 1)",
                            selection: gradientColorBinding(at: index),
                            supportsOpacity: false
                        )
                        .labelsHidden()
                        .accessibilityLabel("Gradient color \(index + 1)")

                        if viewModel.currentBackgroundColors.count > 2 {
                            Button {
                                viewModel.removeGradientColor(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Remove gradient color \(index + 1)")
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            if viewModel.currentBackgroundColors.count < 5 {
                Button {
                    viewModel.addGradientColor()
                } label: {
                    Label("Add Color Stop", systemImage: "plus.circle.fill")
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                        .foregroundStyle(.purple)
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.backgrounds.indices, id: \.self) { index in
                        Button {
                            viewModel.selectBackgroundPalette(at: index)
                        } label: {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: viewModel.backgrounds[index],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                                .overlay {
                                    if viewModel.backgroundImage == nil
                                        && viewModel.customGradientColors == nil
                                        && viewModel.backgroundIndex == index {
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 3)
                                            .padding(-4)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func gradientColorBinding(at index: Int) -> Binding<Color> {
        Binding(
            get: {
                let colors = viewModel.currentBackgroundColors
                guard colors.indices.contains(index) else { return .purple }
                return colors[index]
            },
            set: { viewModel.updateGradientColor(at: index, to: $0) }
        )
    }

    // MARK: - 3. Stickers & Badges Section
    private var stickersSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Sticker & Badge Tray")
                    .font(.googleSansFlex(.subheadline, weight: .bold))

                Spacer()

                Button {
                    viewModel.sticker = ""
                    customStickerText = ""
                } label: {
                    Label("No Sticker", systemImage: "xmark.circle")
                        .font(.googleSansFlex(.caption, weight: .bold))
                        .foregroundStyle(viewModel.sticker.isEmpty ? .purple : .secondary)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Removes the sticker from your story")
            }

            // Celestial
            stickerGroup(title: "Celestial & Stars", items: ["✦", "✧", "☼", "☽", "⋆", "✪"])

            // Love & Mood
            stickerGroup(title: "Love & Mood", items: ["♡", "♥", "❥", "❦", "𑁍", "☕"])

            // Promo Badges
            stickerGroup(title: "Badges & Tags", items: ["NEW", "VIBES", "SALE", "MOOD", "100%", "DAILY QUOTE", "MUST HAVE"])

            // Nature & Flora
            stickerGroup(title: "Nature & Symbols", items: ["❋", "✿", "𖤣", "𖥸", "𓇢", "⚡", "✳"])

            Divider()

            // Custom Sticker Input
            Text("Custom Sticker / Emoji")
                .font(.googleSansFlex(.subheadline, weight: .bold))
            HStack {
                TextField("Type emoji or text (e.g. 🔥, DREAM)", text: $customStickerText)
                    .textFieldStyle(.roundedBorder)

                Button("Set") {
                    let sticker = customStickerText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !sticker.isEmpty else { return }
                    viewModel.sticker = sticker
                    customStickerText = ""
                }
                .font(.googleSansFlex(.subheadline, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(customStickerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(customStickerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            }
        }
    }

    private func stickerGroup(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.googleSansFlex(.caption, weight: .bold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        Button {
                            viewModel.sticker = viewModel.sticker == item ? "" : item
                        } label: {
                            Text(item)
                                .font(item.count > 2 ? .caption.bold() : .title3)
                                .padding(.horizontal, item.count > 2 ? 12 : 10)
                                .padding(.vertical, 8)
                                .background(
                                    viewModel.sticker == item
                                        ? Color.purple.opacity(0.2)
                                        : Color(uiColor: .tertiarySystemGroupedBackground)
                                )
                                .foregroundStyle(viewModel.sticker == item ? Color.purple : Color.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(viewModel.sticker == item ? Color.purple : Color.clear, lineWidth: 1.5)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - 4. Frames & Style Section
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Aesthetic Frame Style")
                .font(.googleSansFlex(.subheadline, weight: .bold))

            HStack(spacing: 12) {
                ForEach(StoryFrameStyle.allCases) { style in
                    Button {
                        viewModel.frameStyle = style
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: style.iconName)
                                .font(.system(size: 20))
                            Text(style.rawValue)
                                .font(.googleSansFlex(.caption2, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            viewModel.frameStyle == style
                                ? Color.purple
                                : Color(uiColor: .tertiarySystemGroupedBackground)
                        )
                        .foregroundStyle(viewModel.frameStyle == style ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            Toggle(isOn: $viewModel.showVignette) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Vintage Vignette")
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                    Text("Adds cinematic darkened edges")
                        .font(.googleSansFlex(.caption))
                        .foregroundStyle(.secondary)
                }
            }
            .tint(.purple)
        }
    }

    // MARK: - Bottom Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Save to My Creations
                Button {
                    viewModel.saveToCreations()
                } label: {
                    Label("Save to Studio", systemImage: "folder.badge.plus")
                        .font(.googleSansFlex(.headline))
                        .foregroundStyle(.purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Save Direct to Photos
                Button {
                    viewModel.saveToPhotoLibrary()
                } label: {
                    Label("Save to Photos", systemImage: "arrow.down.to.line.circle.fill")
                        .font(.googleSansFlex(.headline))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }

            // Export & Share Link
            Button {
                viewModel.exportStory()
            } label: {
                Label("Export & Share PNG", systemImage: "square.and.arrow.up.fill")
                    .font(.googleSansFlex(.headline))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            if let url = viewModel.exportedURL {
                ShareLink(item: url) {
                    Label("Tap here to send via AirDrop / Messages", systemImage: "paperplane.fill")
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                        .foregroundStyle(.purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StoryEditorView(template: StoryTemplate.samples[0])
    }
}
