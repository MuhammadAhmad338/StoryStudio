import SwiftUI

struct TemplateCardView: View {
    let template: StoryTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                StoryCanvasView(
                    colors: template.colors,
                    title: template.title,
                    subtitle: template.subtitle,
                    sticker: template.sticker
                )
                .aspectRatio(9.0 / 16.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Image(systemName: template.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundStyle(template.isFavorite ? .red : .white)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.3))
                    )
                    .padding(8)
            }

            Text(template.name)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)

            Text(template.category)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
//
//  TemplateCardView.swift
//  StoryStudio
//
//  Created by Muhammad Ahmad on 2026-10-14.
//

