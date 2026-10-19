import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var creationsManager = CreationsManager.shared
    @Binding var selectedTemplate: StoryTemplate?
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var isDarkMode = false
    @State private var openBlankCanvas = false

    init(selectedTemplate: Binding<StoryTemplate?> = .constant(nil)) {
        self._selectedTemplate = selectedTemplate
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var displayedTemplates: [StoryTemplate] {
        viewModel.filteredTemplates.filter { template in
            (searchText.isEmpty || template.name.localizedCaseInsensitiveContains(searchText) || template.title.localizedCaseInsensitiveContains(searchText)) &&
            (!showFavoritesOnly || template.isFavorite)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                // Tagline & Quick Action
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Create something beautiful.")
                            .font(.googleSansFlex(.title2, weight: .bold))

                        Text("Choose a template or craft from blank.")
                            .font(.googleSansFlex(.subheadline))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        openBlankCanvas = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                            Text("Blank")
                        }
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.purple)
                        .clipShape(Capsule())
                    }
                }

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search templates, quotes, styles...", text: $searchText)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Filter Options
                HStack {
                    Button {
                        withAnimation {
                            showFavoritesOnly.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                            Text("Favorites (\(creationsManager.favoriteTemplateIDs.count))")
                        }
                        .font(.googleSansFlex(size: 14, weight: .medium))
                        .foregroundStyle(showFavoritesOnly ? .purple : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(showFavoritesOnly ? Color.purple.opacity(0.12) : Color.clear)
                        .clipShape(Capsule())
                    }

                    Spacer()

                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 2)

                categoryPicker

                // Template Grid
                if displayedTemplates.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "sparkle.magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                            .padding(.top, 24)

                        Text("No templates match your search")
                            .font(.googleSansFlex(.headline))

                        Button("Reset Filters") {
                            searchText = ""
                            showFavoritesOnly = false
                            viewModel.selectedCategory = "All"
                        }
                        .font(.googleSansFlex(.subheadline, weight: .bold))
                        .foregroundStyle(.purple)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(displayedTemplates) { template in
                            Button {
                                selectedTemplate = template
                            } label: {
                                TemplateCardView(template: template) {
                                    viewModel.toggleFavorite(template: template)
                                }
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    selectedTemplate = template
                                } label: {
                                    Label("Open in Editor", systemImage: "paintbrush")
                                }

                                Button {
                                    viewModel.toggleFavorite(template: template)
                                } label: {
                                    Label(
                                        template.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                        systemImage: template.isFavorite ? "heart.slash" : "heart"
                                    )
                                }
                            }
                        }
                    }
                }

                // Dynamic Live Stats Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Studio Stats")
                        .font(.googleSansFlex(size: 18, weight: .bold))
                        .padding(.top, 10)

                    HStack(spacing: 12) {
                        StatCard(
                            icon: "rectangle.stack.fill",
                            title: "Templates",
                            value: "\(viewModel.templates.count)"
                        )

                        StatCard(
                            icon: "heart.fill",
                            title: "Favorites",
                            value: "\(creationsManager.favoriteTemplateIDs.count)"
                        )

                        StatCard(
                            icon: "folder.fill",
                            title: "Saved",
                            value: "\(creationsManager.savedStories.count)"
                        )
                    }
                }
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationDestination(isPresented: $openBlankCanvas) {
            StoryEditorView()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.googleSansFlex(.title2))
                .foregroundStyle(.purple)

            Text("StoryStudio")
                .font(.googleSansFlex(.title2, weight: .bold))

            Spacer()
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.googleSansFlex(size: 14, weight: .medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedCategory == category
                                    ? Color.purple
                                    : Color.secondary.opacity(0.12)
                            )
                            .foregroundStyle(
                                viewModel.selectedCategory == category
                                    ? .white
                                    : .primary
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.purple)
                .frame(width: 44, height: 44)
                .background(Color.purple.opacity(0.12))
                .clipShape(Circle())

            Text(value)
                .font(.googleSansFlex(.title3, weight: .bold))

            Text(title)
                .font(.googleSansFlex(.caption))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
