import SwiftUI
import Combine

@MainActor
final class CreationsManager: ObservableObject {
    static let shared = CreationsManager()

    @Published var savedStories: [SavedStory] = []
    @Published var favoriteTemplateIDs: Set<String> = []

    private let storiesKey = "StoryStudio_SavedStories"
    private let favoritesKey = "StoryStudio_FavoriteIDs"

    private init() {
        loadFavorites()
        loadStories()
    }

    // MARK: - Favorites
    private func loadFavorites() {
        if let stored = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteTemplateIDs = Set(stored)
        }
    }

    func isFavorite(templateID: String) -> Bool {
        favoriteTemplateIDs.contains(templateID)
    }

    func toggleFavorite(templateID: String) {
        if favoriteTemplateIDs.contains(templateID) {
            favoriteTemplateIDs.remove(templateID)
        } else {
            favoriteTemplateIDs.insert(templateID)
        }
        UserDefaults.standard.set(Array(favoriteTemplateIDs), forKey: favoritesKey)
    }

    // MARK: - Stories Persistence
    private func loadStories() {
        guard let data = UserDefaults.standard.data(forKey: storiesKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([SavedStory].self, from: data)
            savedStories = decoded
        } catch {
            print("Failed to decode saved stories: \(error)")
        }
    }

    func saveStory(_ story: SavedStory, backgroundImage: UIImage? = nil) {
        var updatedStory = story

        // If an image is provided, save it to app documents
        if let image = backgroundImage {
            let filename = "story_img_\(story.id.uuidString).jpg"
            if saveImageToDisk(image, filename: filename) {
                updatedStory.imageFilename = filename
            }
        }

        if let index = savedStories.firstIndex(where: { $0.id == updatedStory.id }) {
            savedStories[index] = updatedStory
        } else {
            savedStories.insert(updatedStory, at: 0)
        }

        persistStories()
    }

    func deleteStory(id: UUID) {
        if let story = savedStories.first(where: { $0.id == id }), let filename = story.imageFilename {
            deleteImageFromDisk(filename: filename)
        }
        savedStories.removeAll(where: { $0.id == id })
        persistStories()
    }

    func duplicateStory(_ story: SavedStory) {
        var copy = story
        let newID = UUID()
        copy = SavedStory(
            id: newID,
            createdAt: Date(),
            title: "\(story.title) (Copy)",
            subtitle: story.subtitle,
            brandName: story.brandName,
            handle: story.handle,
            sticker: story.sticker,
            colors: story.colors,
            textColor: story.textColor,
            fontDesign: story.fontDesign,
            textAlignment: story.textAlignment,
            aspectRatio: story.aspectRatio,
            frameStyle: story.frameStyle,
            backgroundBlur: story.backgroundBlur,
            overlayOpacity: story.overlayOpacity,
            showVignette: story.showVignette,
            imageFilename: nil
        )

        // Copy image if present
        if let oldFilename = story.imageFilename, let image = loadImageFromDisk(filename: oldFilename) {
            let newFilename = "story_img_\(newID.uuidString).jpg"
            if saveImageToDisk(image, filename: newFilename) {
                copy.imageFilename = newFilename
            }
        }

        savedStories.insert(copy, at: 0)
        persistStories()
    }

    private func persistStories() {
        do {
            let data = try JSONEncoder().encode(savedStories)
            UserDefaults.standard.set(data, forKey: storiesKey)
        } catch {
            print("Failed to persist stories: \(error)")
        }
    }

    // MARK: - Image Disk Storage
    func loadImageFromDisk(filename: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func saveImageToDisk(_ image: UIImage, filename: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return false }
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            print("Error saving image to disk: \(error)")
            return false
        }
    }

    private func deleteImageFromDisk(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
