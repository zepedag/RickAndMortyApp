//
//  FavoritesViewModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import Observation

@Observable class FavoritesViewModel {
    // MARK: - Properties
    
    private let localStorageUseCase: LocalStorageUseCase
    
    /// Array of favorite characters
    var favoriteCharacters: [CharacterBusinessModel] = []
    
    /// Boolean flag indicating whether data is loading
    var isLoading: Bool = false
    
    /// Any error that occurs during operations
    var viewError: AppError?
    
    /// Boolean flag indicating whether an error has occurred
    var hasError: Bool = false
    
    /// Boolean flag indicating if favorites list is empty
    var isEmpty: Bool {
        return favoriteCharacters.isEmpty && !isLoading
    }
    
    // MARK: - Initialization
    
    init(localStorageUseCase: LocalStorageUseCase = LocalStorageUseCase()) {
        self.localStorageUseCase = localStorageUseCase
    }
    
    // MARK: - Public Methods
    
    /// Loads all favorite characters
    func loadFavorites() async {
        isLoading = true
        hasError = false
        
        await MainActor.run {
            self.favoriteCharacters = self.localStorageUseCase.getFavoriteCharacters()
            self.isLoading = false
        }
    }
    
    /// Removes a character from favorites
    func removeFromFavorites(characterId: Int) async {
        await MainActor.run {
            let wasRemoved = self.localStorageUseCase.toggleFavorite(characterId: characterId)
            if wasRemoved {
                self.favoriteCharacters.removeAll { $0.id == characterId }
            }
        }
    }
    
    /// Toggles favorite status for a character
    func toggleFavorite(characterId: Int) async {
        await MainActor.run {
            let isNowFavorite = self.localStorageUseCase.toggleFavorite(characterId: characterId)
            
            if let index = self.favoriteCharacters.firstIndex(where: { $0.id == characterId }) {
                if !isNowFavorite {
                    self.favoriteCharacters.remove(at: index)
                }
            } else if isNowFavorite {
                // Character was added to favorites, reload to get the full character data
                Task {
                    await self.loadFavorites()
                }
            }
        }
    }
    
    /// Checks if a character is favorite
    func isFavorite(characterId: Int) -> Bool {
        return localStorageUseCase.isFavorite(characterId: characterId)
    }
    
    /// Refreshes the favorites list
    func refreshFavorites() async {
        await loadFavorites()
    }
}
