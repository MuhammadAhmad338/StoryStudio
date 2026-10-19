import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedCategory = "All"
    @Published var templates: [StoryTemplate] = StoryTemplate.samples
    @ObservedObject var creationsManager = CreationsManager.shared

    let categories = [
        "All",
        "Lifestyle",
        "Quotes",
        "Announcements",
        "Promotions",
        "Tech",
        "Food & Drink",
        "Travel",
        "Events",
        "Wellness",
        "Business"
    ]

    var filteredTemplates: [StoryTemplate] {
        let baseList: [StoryTemplate]
        if selectedCategory == "All" {
            baseList = templates
        } else {
            baseList = templates.filter { $0.category == selectedCategory }
        }

        // Return with synced favorite status from CreationsManager
        return baseList.map { template in
            var t = template
            t.isFavorite = creationsManager.isFavorite(templateID: template.id)
            return t
        }
    }

    func isFavorite(template: StoryTemplate) -> Bool {
        creationsManager.isFavorite(templateID: template.id)
    }

    func toggleFavorite(template: StoryTemplate) {
        creationsManager.toggleFavorite(templateID: template.id)
        objectWillChange.send()
    }
}
