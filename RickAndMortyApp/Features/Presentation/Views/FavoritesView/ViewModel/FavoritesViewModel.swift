//
//  FavoritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import Foundation
import Observation

/// ViewModel for managing favorites functionality
@Observable class FavoritesViewModel {

    // MARK: - Properties

    /// Array of favorite characters
    var favoriteCharacters: [CharacterBusinessModel] = []

    /// Boolean flag indicating whether data is being loaded
    var isLoading: Bool = false

    /// Any error that occurs during view-related actions
    var viewError: AppError?

    /// Boolean flag indicating whether an error has occurred
    var hasError: Bool = false

    /// Use case for local storage operations
    private let localStorageUseCase: LocalStorageUseCase

    // MARK: - Initialization

    /// Initializes a new FavoritesViewModel
    /// - Parameter localStorageUseCase: The use case for local storage operations
    init(localStorageUseCase: LocalStorageUseCase = LocalStorageUseCase()) {
        self.localStorageUseCase = localStorageUseCase
    }

    // MARK: - Public Methods

    /// Loads favorite characters from local storage
    func loadFavorites() async {
        isLoading = true

        let favorites = localStorageUseCase.getFavoriteCharacters()

        await MainActor.run {
            self.favoriteCharacters = favorites
            self.isLoading = false
            self.hasError = false
        }
    }

    /// Removes a character from favorites
    /// - Parameter characterId: The ID of the character to remove from favorites
    func removeFromFavorites(characterId: Int) {
        localStorageUseCase.toggleFavorite(characterId: characterId)

        // Update the local array
        favoriteCharacters.removeAll { $0.id == characterId }
    }

    /// Checks if a character is favorite
    /// - Parameter characterId: The ID of the character to check
    /// - Returns: True if the character is favorite, false otherwise
    func isFavorite(characterId: Int) -> Bool {
        return localStorageUseCase.isFavorite(characterId: characterId)
    }

    /// Refreshes the favorites list
    func refreshFavorites() async {
        await loadFavorites()
    }
}
