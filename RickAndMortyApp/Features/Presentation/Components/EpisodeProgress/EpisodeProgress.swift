//
//  EpisodeProgress.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

struct EpisodeProgress: View {
    let characterId: Int
    let episodes: [String]
    @State private var watchedEpisodes: [String] = []
    @State private var isLoading: Bool = false

    private let localStorageUseCase = LocalStorageUseCase()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Episodes Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("\(watchedEpisodes.count)/\(episodes.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(y: 0.5)
        }
        .onAppear {
            loadWatchedEpisodes()
        }
    }

    private var progress: Double {
        guard !episodes.isEmpty else { return 0.0 }
        return Double(watchedEpisodes.count) / Double(episodes.count)
    }

    private func loadWatchedEpisodes() {
        isLoading = true
        watchedEpisodes = localStorageUseCase.getWatchedEpisodes(for: characterId)
        isLoading = false
    }
}

#Preview {
    EpisodeProgress(characterId: 1, episodes: ["S01E01", "S01E02", "S01E03"])
        .padding()
}
