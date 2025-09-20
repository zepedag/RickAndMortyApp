//
//  LocalStorageUseCase.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation

/// Use case for local storage operations
class LocalStorageUseCase {
    private let localRepository: LocalStorageRepository

    init(localRepository: LocalStorageRepository = LocalStorageRepository()) {
        self.localRepository = localRepository
    }

    // MARK: - Character Operations

    /// Saves a character to local storage
    func saveCharacter(_ character: CharacterBusinessModel) {
        localRepository.saveCharacter(character)
    }

    /// Saves multiple characters to local storage
    func saveCharacters(_ characters: [CharacterBusinessModel]) {
        localRepository.saveCharacters(characters)
    }

    /// Gets a character by ID from local storage
    func getCharacter(by id: Int) -> CharacterBusinessModel? {
        return localRepository.getCharacter(by: id)
    }

    /// Gets all characters from local storage
    func getAllCharacters() -> [CharacterBusinessModel] {
        return localRepository.getAllCharacters()
    }

    /// Gets all favorite characters
    func getFavoriteCharacters() -> [CharacterBusinessModel] {
        return localRepository.getFavoriteCharacters()
    }

    // MARK: - Favorite Operations

    /// Toggles favorite status for a character
    func toggleFavorite(characterId: Int) -> Bool {
        return localRepository.toggleFavorite(characterId: characterId)
    }

    /// Checks if a character is favorite
    func isFavorite(characterId: Int) -> Bool {
        return localRepository.isFavorite(characterId: characterId)
    }

    // MARK: - Episode Operations

    /// Marks an episode as watched for a character
    func markEpisodeAsWatched(episodeId: String, characterId: Int) {
        localRepository.markEpisodeAsWatched(episodeId: episodeId, characterId: characterId)
    }

    /// Marks an episode as not watched for a character
    func markEpisodeAsNotWatched(episodeId: String, characterId: Int) {
        localRepository.markEpisodeAsNotWatched(episodeId: episodeId, characterId: characterId)
    }

    /// Checks if an episode is watched for a character
    func isEpisodeWatched(episodeId: String, characterId: Int) -> Bool {
        return localRepository.isEpisodeWatched(episodeId: episodeId, characterId: characterId)
    }

    /// Gets watched episodes for a character
    func getWatchedEpisodes(for characterId: Int) -> [String] {
        return localRepository.getWatchedEpisodes(for: characterId)
    }

    /// Toggles episode watching status
    func toggleEpisodeStatus(episodeId: String, characterId: Int) -> Bool {
        let isWatched = isEpisodeWatched(episodeId: episodeId, characterId: characterId)

        if isWatched {
            markEpisodeAsNotWatched(episodeId: episodeId, characterId: characterId)
            return false
        } else {
            markEpisodeAsWatched(episodeId: episodeId, characterId: characterId)
            return true
        }
    }
}
