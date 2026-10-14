import SwiftUI

struct StoryEditorView: View {
    @StateObject private var viewModel: StoryEditorViewModel

    init(template: StoryTemplate) {
        _viewModel = StateObject(
            wrappedValue: StoryEditorViewModel(template: template)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StoryCanvasView(
                    colors: viewModel.backgrounds[viewModel.backgroundIndex],
                    title: viewModel.title,
                    subtitle: viewModel.subtitle,
                    sticker: viewModel.sticker
                )
                .aspectRatio(9.0 / 16.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Group {
                    Text("Headline")
                        .font(.headline)

                    TextField("Enter headline", text: $viewModel.title, axis: .vertical)
                        .textFieldStyle(.roundedBorder)

                    Text("Subtitle")
                        .font(.headline)

                    TextField("Enter subtitle", text: $viewModel.subtitle, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                }

                Text("Background")
                    .font(.headline)

                HStack(spacing: 14) {
                    ForEach(viewModel.backgrounds.indices, id: \.self) { index in
                        Button {
                            viewModel.backgroundIndex = index
                        } label: {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: viewModel.backgrounds[index],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .overlay {
                                    if viewModel.backgroundIndex == index {
                                        Circle()
                                            .stroke(.primary, lineWidth: 2)
                                            .padding(-4)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("Sticker")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(["✦", "♡", "✳", "✧", "☼", "❋"], id: \.self) { sticker in
                        Button(sticker) {
                            viewModel.sticker = sticker
                        }
                        .font(.title2)
                        .padding(10)
                        .background(
                            viewModel.sticker == sticker
                                ? Color.purple.opacity(0.15)
                                : Color(uiColor: .secondarySystemGroupedBackground)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                Button {
                    viewModel.exportStory()
                } label: {
                    Label("Export Story PNG", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }

                if let url = viewModel.exportedURL {
                    ShareLink(item: url) {
                        Label("Share Design", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Export failed",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
}
//
//  StoryEditorView.swift
//  StoryStudio
//
//  Created by Muhammad Ahmad on 2026-10-14.
//

