//
//  IntegrationService.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation

/// Service to integrate CoreData functionality with existing app without modifying current code
class IntegrationService {
    static let shared = IntegrationService()

    private let localStorageUseCase: LocalStorageUseCase

    init(localStorageUseCase: LocalStorageUseCase = LocalStorageUseCase()) {
        self.localStorageUseCase = localStorageUseCase
    }

    // MARK: - Public Integration Methods

    /// Saves characters to local storage when they are loaded from API
    func saveCharactersToLocal(_ characters: [CharacterBusinessModel]) {
        localStorageUseCase.saveCharacters(characters)
    }

    /// Gets favorite characters for display
    func getFavoriteCharacters() -> [CharacterBusinessModel] {
        return localStorageUseCase.getFavoriteCharacters()
    }

    /// Checks if a character is favorite
    func isCharacterFavorite(_ characterId: Int) -> Bool {
        return localStorageUseCase.isFavorite(characterId: characterId)
    }

    /// Toggles favorite status for a character
    func toggleCharacterFavorite(_ characterId: Int) -> Bool {
        return localStorageUseCase.toggleFavorite(characterId: characterId)
    }

    /// Gets watched episodes for a character
    func getWatchedEpisodes(for characterId: Int) -> [String] {
        return localStorageUseCase.getWatchedEpisodes(for: characterId)
    }

    /// Checks if an episode is watched
    func isEpisodeWatched(episodeId: String, characterId: Int) -> Bool {
        return localStorageUseCase.isEpisodeWatched(episodeId: episodeId, characterId: characterId)
    }

    /// Toggles episode watching status
    func toggleEpisodeWatched(episodeId: String, characterId: Int) -> Bool {
        return localStorageUseCase.toggleEpisodeStatus(episodeId: episodeId, characterId: characterId)
    }

    /// Gets watching progress for a character
    func getWatchingProgress(for characterId: Int, totalEpisodes: Int) -> Double {
        let watchedCount = localStorageUseCase.getWatchedEpisodes(for: characterId).count
        guard totalEpisodes > 0 else { return 0.0 }
        return Double(watchedCount) / Double(totalEpisodes)
    }
}
