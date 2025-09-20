//
//  EpisodeList.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI

/// Component for displaying a list of episodes with watched status
struct EpisodeList: View {
    let episodes: [String]
    let characterId: Int
    let localStorageUseCase: LocalStorageUseCase
    @State private var watchedEpisodes: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Episodes")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                Text("\(watchedEpisodes.count)/\(episodes.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 8)
            }

            // Progress bar
            ProgressView(value: Double(watchedEpisodes.count), total: Double(episodes.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(y: 2)

            // Episodes list
            if episodes.isEmpty {
                emptyState
            } else {
                episodesList
            }
        }
        .onAppear {
            loadWatchedEpisodes()
        }
    }

    // MARK: - Views

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tv.slash")
                .font(.system(size: 32))
                .foregroundColor(.secondary)

            Text("No Episodes")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text("This character doesn't appear in any episodes")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 12)
    }

    private var episodesList: some View {
        LazyVStack(spacing: 8) {
            ForEach(episodes, id: \.self) { episodeUrl in
                EpisodeRow(
                    episodeUrl: episodeUrl,
                    characterId: characterId,
                    isWatched: Binding(
                        get: { watchedEpisodes.contains(episodeUrl) },
                        set: { _ in toggleEpisode(episodeUrl) }
                    ),
                    onToggle: {
                        toggleEpisode(episodeUrl)
                    }
                )
            }
        }
    }

    // MARK: - Methods

    private func loadWatchedEpisodes() {
        watchedEpisodes = Set(localStorageUseCase.getWatchedEpisodes(for: characterId))
    }

    private func toggleEpisode(_ episodeUrl: String) {
        let episodeId = extractEpisodeId(from: episodeUrl)

        if watchedEpisodes.contains(episodeUrl) {
            // Mark as not watched
            localStorageUseCase.markEpisodeAsNotWatched(episodeId: episodeId, characterId: characterId)
            watchedEpisodes.remove(episodeUrl)
        } else {
            // Mark as watched
            localStorageUseCase.markEpisodeAsWatched(episodeId: episodeId, characterId: characterId)
            watchedEpisodes.insert(episodeUrl)
        }
    }

    private func extractEpisodeId(from url: String) -> String {
        // Extract episode ID from URL (e.g., "https://rickandmortyapi.com/api/episode/1" -> "1")
        if let url = URL(string: url),
           let episodeId = url.lastPathComponent.components(separatedBy: "/").last {
            return episodeId
        }
        return url // Fallback to full URL if extraction fails
    }
}

#Preview {
    EpisodeList(
        episodes: [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            "https://rickandmortyapi.com/api/episode/3"
        ],
        characterId: 1,
        localStorageUseCase: LocalStorageUseCase()
    )
    .padding()
    .background(Color("Background"))
}
