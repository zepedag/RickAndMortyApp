//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

extension SearchView {
    var searchView: some View {
        ScrollView {
            scrollDetectionView
            ForEach(Array(viewModel.filteredCharacterList.enumerated()), id: \.offset) { index, character in
                if index != 0 {
                    Divider()
                }

                Button {
                    print("SearchView: Selected character: \(character.name)")
                    selectedCharacter = character
                } label: {
                    ListRow(title: character.name, image: character.image)
                    if viewModel.isLoading {
                        ProgressView()
                            .accentColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .searchViewStyle()
        .coordinateSpace(.named("scrollview"))
        .refreshable {
            await viewModel.searchCharacter(by: text, isFirstLoad: true)
        }
        .sheet(item: $selectedCharacter) { character in
            CharacterDetailView(character: character)
        }
    }

    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scrollview")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                let estimatedContentHeight = CGFloat(viewModel.filteredCharacterList.count * 50)
                let threshold = 0.4 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        await viewModel.searchCharacter(by: text, isFirstLoad: false)
                    }
                }
            }
        }
    }

    var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Results Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Try adjusting your search terms or filters")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Suggestions
            VStack(spacing: 8) {
                Text("Suggestions:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Text("• Check your spelling")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("• Try different keywords")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("• Clear filters")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .searchViewStyle()
    }
}
