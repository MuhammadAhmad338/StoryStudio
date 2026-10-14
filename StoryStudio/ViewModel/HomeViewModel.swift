import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedCategory = "All"
    @Published var templates: [StoryTemplate] = StoryTemplate.samples.map { template in
        var mutableTemplate = template
        return mutableTemplate
    }

    let categories = [
        "All",
        "Lifestyle",
        "Quotes",
        "Announcements",
        "Promotions"
    ]

    var filteredTemplates: [StoryTemplate] {
        guard selectedCategory != "All" else {
            return templates
        }

        return templates.filter {
            $0.category == selectedCategory
        }
    }
}
