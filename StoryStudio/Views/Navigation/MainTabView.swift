import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var selectedTemplate: StoryTemplate? = nil
    @ObservedObject private var creationsManager = CreationsManager.shared
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(selectedTemplate: $selectedTemplate)
                    .navigationDestination(isPresented: Binding(
                        get: { selectedTemplate != nil },
                        set: { if !$0 { selectedTemplate = nil } }
                    )) {
                        if let template = selectedTemplate {
                            StoryEditorView(template: template)
                        }
                    }
            }
            .tabItem {
                Label("Templates", systemImage: "sparkles.rectangle.stack.fill")
            }
            .tag(0)

            MyCreationsView()
                .tabItem {
                    Label("My Studio", systemImage: "folder.fill")
                }
                .badge(creationsManager.savedStories.count)
                .tag(1)

            InspirationView()
                .tabItem {
                    Label("Inspiration", systemImage: "lightbulb.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.purple)
    }
}

#Preview {
    MainTabView()
}
