import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedTemplate: StoryTemplate?
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var isDarkMode = false

    init(selectedTemplate: Binding<StoryTemplate?> = .constant(nil)) {
        self._selectedTemplate = selectedTemplate
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                Text("Create something beautiful.")
                    .font(.googleSansFlexLargeTitle)

                Text("Choose a template and make it yours.")
                    .font(.googleSansFlexBody)
                    .foregroundStyle(.secondary)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search templates...", text: $searchText)
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
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Filter Options
                HStack {
                    Button {
                        showFavoritesOnly.toggle()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                            Text("Favorites")
                        }
                        .font(.googleSansFlex(size: 14, weight: .medium))
                        .foregroundStyle(showFavoritesOnly ? .purple : .primary)
                    }

                    Spacer()

                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 4)

                categoryPicker

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.filteredTemplates.filter { template in
                        (searchText.isEmpty || template.name.localizedCaseInsensitiveContains(searchText)) &&
                        (!showFavoritesOnly || template.isFavorite)
                    }) { template in
                        Button {
                            selectedTemplate = template
                        } label: {
                            TemplateCardView(template: template)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                toggleFavorite(template)
                            } label: {
                                Label(template.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                      systemImage: template.isFavorite ? "heart.slash" : "heart")
                            }
                        }
                    }
                }

                // Stats Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Stats")
                        .font(.googleSansFlex(size: 20, weight: .semibold))
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
                            value: "\(viewModel.templates.filter { $0.isFavorite }.count)"
                        )

                        StatCard(
                            icon: "checkmark.circle.fill",
                            title: "Created",
                            value: "0"
                        )
                    }
                }
            }
            .padding(20)
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
        #else
        .background(Color(NSColor.controlBackgroundColor))
        #endif
        #if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
        #endif
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.title)
                .foregroundStyle(.purple)

            Text("StoryStudio")
                .font(.googleSansFlexTitle2)

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
                            .font(.googleSansFlexSubheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                viewModel.selectedCategory == category
                                    ? Color.purple
                                    : Color.secondary.opacity(0.2)
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

    private func toggleFavorite(_ template: StoryTemplate) {
        if let index = viewModel.templates.firstIndex(where: { $0.id == template.id }) {
            viewModel.templates[index].isFavorite.toggle()
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(.purple)
                .frame(width: 50, height: 50)
                .background(Color.purple.opacity(0.1))
                .clipShape(Circle())

            Text(value)
                .font(.googleSansFlex(size: 20, weight: .bold))

            Text(title)
                .font(.googleSansFlex(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
