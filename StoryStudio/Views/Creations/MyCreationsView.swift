import SwiftUI

struct MyCreationsView: View {
    @ObservedObject var creationsManager = CreationsManager.shared
    @State private var selectedStoryToEdit: SavedStory? = nil
    @State private var storyToDelete: SavedStory? = nil
    @State private var showDeleteConfirmation = false
    @State private var shareURL: URL? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if creationsManager.savedStories.isEmpty {
                        emptyStateView
                    } else {
                        creationsGrid
                    }
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("My Studio")
            .navigationDestination(isPresented: Binding(
                get: { selectedStoryToEdit != nil },
                set: { if !$0 { selectedStoryToEdit = nil } }
            )) {
                if let story = selectedStoryToEdit {
                    StoryEditorView(savedStory: story)
                }
            }
            .confirmationDialog(
                "Delete Story?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let story = storyToDelete {
                        withAnimation {
                            creationsManager.deleteStory(id: story.id)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 18) {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.system(size: 64))
                .foregroundStyle(.purple.opacity(0.6))
                .padding(.top, 60)

            Text("No Stories Saved Yet")
                .font(.title2.bold())

            Text("Designs you create and save from the editor will appear here. You can re-edit, duplicate, or export them anytime.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button {
                selectedStoryToEdit = SavedStory(
                    title: "MY NEW STORY",
                    subtitle: "Crafted with StoryStudio",
                    colors: [.orange, .pink, .purple]
                )
            } label: {
                Label("Create First Story", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.purple)
                    .clipShape(Capsule())
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var creationsGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("\(creationsManager.savedStories.count) Saved \(creationsManager.savedStories.count == 1 ? "Design" : "Designs")")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(creationsManager.savedStories) { story in
                    VStack(alignment: .leading, spacing: 8) {
                        // Canvas Card Preview
                        Button {
                            selectedStoryToEdit = story
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                StoryCanvasView(
                                    colors: story.colors,
                                    backgroundImage: story.imageFilename != nil ? creationsManager.loadImageFromDisk(filename: story.imageFilename!) : nil,
                                    backgroundBlur: story.backgroundBlur,
                                    overlayOpacity: story.overlayOpacity,
                                    title: story.title,
                                    subtitle: story.subtitle,
                                    sticker: story.sticker,
                                    brandName: story.brandName,
                                    handle: story.handle,
                                    fontDesign: story.fontDesign,
                                    textAlignment: story.textAlignment,
                                    textColor: story.textColor,
                                    frameStyle: story.frameStyle,
                                    showVignette: story.showVignette
                                )
                                .aspectRatio(story.aspectRatio.ratio, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                            }
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                selectedStoryToEdit = story
                            } label: {
                                Label("Edit Story", systemImage: "pencil")
                            }

                            Button {
                                creationsManager.duplicateStory(story)
                            } label: {
                                Label("Duplicate", systemImage: "doc.on.doc")
                            }

                            Divider()

                            Button(role: .destructive) {
                                storyToDelete = story
                                showDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }

                        // Meta details
                        Text(story.title.replacingOccurrences(of: "\n", with: " "))
                            .font(.subheadline.bold())
                            .lineLimit(1)

                        HStack {
                            Text(story.createdAt.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Menu {
                                Button {
                                    selectedStoryToEdit = story
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }

                                Button {
                                    creationsManager.duplicateStory(story)
                                } label: {
                                    Label("Duplicate", systemImage: "doc.on.doc")
                                }

                                Button(role: .destructive) {
                                    storyToDelete = story
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyCreationsView()
}
