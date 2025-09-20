//
//  EpisodeRow.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI

/// Row component for displaying an episode with watched status toggle
struct EpisodeRow: View {
    let episodeUrl: String
    let characterId: Int
    @Binding var isWatched: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Episode icon
            Image(systemName: "tv")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            // Episode info
            VStack(alignment: .leading, spacing: 2) {
                Text(episodeTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(episodeNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Watch status toggle
            Button(action: onToggle) {
                Image(systemName: isWatched ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isWatched ? .green : .gray)
                    .animation(.easeInOut(duration: 0.2), value: isWatched)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 12)
        .opacity(isWatched ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isWatched)
    }

    // MARK: - Computed Properties

    private var episodeTitle: String {
        // Extract episode title from URL (e.g., "https://rickandmortyapi.com/api/episode/1" -> "Episode 1")
        if let url = URL(string: episodeUrl),
           let episodeNumber = url.lastPathComponent.components(separatedBy: "/").last {
            return "Episode \(episodeNumber)"
        }
        return "Unknown Episode"
    }

    private var episodeNumber: String {
        // Extract just the number (e.g., "1", "2", etc.)
        if let url = URL(string: episodeUrl),
           let episodeNumber = url.lastPathComponent.components(separatedBy: "/").last {
            return "#\(episodeNumber)"
        }
        return "#??"
    }
}

#Preview {
    VStack(spacing: 8) {
        EpisodeRow(
            episodeUrl: "https://rickandmortyapi.com/api/episode/1",
            characterId: 1,
            isWatched: .constant(false),
            onToggle: {}
        )

        EpisodeRow(
            episodeUrl: "https://rickandmortyapi.com/api/episode/2",
            characterId: 1,
            isWatched: .constant(true),
            onToggle: {}
        )
    }
    .padding()
    .background(Color("Background"))
}
