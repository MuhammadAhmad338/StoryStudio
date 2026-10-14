
import Foundation

struct StoryDesign: Identifiable {
    let id: UUID
    var templateID: String
    var title: String
    var subtitle: String
    var sticker: String
    var backgroundIndex: Int

    init(template: StoryTemplate) {
        id = UUID()
        templateID = template.id
        title = template.title
        subtitle = template.subtitle
        sticker = template.sticker
        backgroundIndex = 0
    }
}

