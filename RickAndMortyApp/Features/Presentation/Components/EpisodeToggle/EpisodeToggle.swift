//
//  EpisodeToggle.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

struct EpisodeToggle: View {
    let episodeId: String
    let characterId: Int
    @State private var isWatched: Bool = false
    @State private var isLoading: Bool = false

    private let localStorageUseCase = LocalStorageUseCase()

    var body: some View {
        Button(action: toggleEpisode) {
            HStack(spacing: 8) {
                Image(systemName: isWatched ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isWatched ? .green : .gray)
                    .font(.title3)

                Text(isWatched ? "Watched" : "Mark as Watched")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .scaleEffect(isLoading ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isLoading)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .onAppear {
            checkEpisodeStatus()
        }
    }

    private func checkEpisodeStatus() {
        isWatched = localStorageUseCase.isEpisodeWatched(episodeId: episodeId, characterId: characterId)
    }

    private func toggleEpisode() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isWatched = self.localStorageUseCase.toggleEpisodeStatus(episodeId: self.episodeId, characterId: self.characterId)
            self.isLoading = false
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        EpisodeToggle(episodeId: "S01E01", characterId: 1)
        EpisodeToggle(episodeId: "S01E02", characterId: 1)
    }
    .padding()
}
