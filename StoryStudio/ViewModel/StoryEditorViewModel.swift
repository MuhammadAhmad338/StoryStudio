
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import Combine

@MainActor
final class StoryEditorViewModel: ObservableObject {
    @Published var title: String
    @Published var subtitle: String
    @Published var sticker: String
    @Published var backgroundIndex = 0
    @Published var exportedURL: URL?
    @Published var errorMessage: String?

    let template: StoryTemplate

    let backgrounds: [[Color]]

    init(template: StoryTemplate) {
        self.template = template
        self.title = template.title
        self.subtitle = template.subtitle
        self.sticker = template.sticker

        self.backgrounds = [
            template.colors,
            [.black, .purple],
            [.orange, .pink, .purple],
            [.mint, .teal, .blue],
            [
                Color(red: 0.96, green: 0.91, blue: 0.83),
                Color(red: 0.85, green: 0.70, blue: 0.58)
            ]
        ]
    }

    func exportStory() {
        let canvas = StoryCanvasView(
            colors: backgrounds[backgroundIndex],
            title: title,
            subtitle: subtitle,
            sticker: sticker
        )
        .frame(width: 1080, height: 1920)

        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 1

        #if os(iOS)
        guard let image = renderer.uiImage,
              let data = image.pngData() else {
            errorMessage = "Unable to generate the image."
            return
        }
        #else
        guard let image = renderer.cgImage else {
            errorMessage = "Unable to generate the image."
            return
        }

        let bitmapRep = NSBitmapImageRep(cgImage: image)
        guard let data = bitmapRep.representation(using: .png, properties: [:]) else {
            errorMessage = "Unable to encode the image."
            return
        }
        #endif

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                "StoryStudio-\(UUID().uuidString).png"
            )

        do {
            try data.write(to: url, options: .atomic)
            exportedURL = url
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
//
//  StoryEditorViewModel.swift
//  StoryStudio
//
//  Created by Muhammad Ahmad on 2026-10-14.
//

