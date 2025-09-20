//
//  ViewModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import Observation

@Observable class HomeViewModel {
    // MARK: - Properties
    
    /// Use case for managing character-related logic.
    private let useCase: CharacterUseCase
    
    /// Local storage use case for CoreData operations
    private let localStorageUseCase: LocalStorageUseCase
    
    /// Array of characters that will be displayed.
    var characterList: [CharacterBusinessModel] = []
    
    /// Any error that occurs during view-related actions.
    var viewError: AppError?
    
    /// Boolean flag indicating whether an error has occurred.
    var hasError: Bool = false
    
    /// Boolean flag indicating whether a network request is in progress.
    var isLoading: Bool = false
    
    /// The current page for pagination.
    private var currentPage: Int = 1
    
    /// Initializes a new HomeViewModel.
    ///
    /// - Parameters:
    ///   - useCase: The use case for character-related logic. Defaults to `DefaultCharacterUseCase()`.
    ///   - localStorageUseCase: The use case for local storage operations. Defaults to `LocalStorageUseCase()`.
    init(useCase: CharacterUseCase = DefaultCharacterUseCase(), 
         localStorageUseCase: LocalStorageUseCase = LocalStorageUseCase()) {
        self.useCase = useCase
        self.localStorageUseCase = localStorageUseCase
        
        // Load local characters immediately on initialization
        loadLocalCharacters()
    }
    
    /// Loads characters from local storage synchronously
    private func loadLocalCharacters() {
        let localCharacters = localStorageUseCase.getAllCharacters()
        characterList = localCharacters
    }
    
    /// Loads the character list from the network or cache.
    func loadCharacterList() async {
        // Exit if already loading data
        guard !isLoading else { return }
        
        // Set loading flag
        isLoading = true
        
        do {
            // Fetch fresh data from the network
            let response = try await useCase.getCharacterList(pageNumber: "\(currentPage)")
            
            // Save characters to local storage
            localStorageUseCase.saveCharacters(response.results)
            
            // Update the UI on the main thread.
            await MainActor.run {
                characterList += response.results // Append new characters to existing array
                hasError = false
                currentPage += 1 // Increment current page for pagination
                isLoading = false
            }
        } catch {
            // Handle error and update the UI on the main thread.
            await MainActor.run {
                isLoading = false
                viewError = .unExpectedError
                hasError = true
            }
        }
    }
    
    /// Refreshes the character list by resetting pagination and loading fresh data
    func refreshCharacterList() async {
        // Reset pagination
        currentPage = 1
        
        // Set loading flag
        isLoading = true
        
        // Network connectivity is automatically monitored
        
        do {
            // Fetch fresh data from the network
            let response = try await useCase.getCharacterList(pageNumber: "\(currentPage)")
            
            // Save characters to local storage
            localStorageUseCase.saveCharacters(response.results)
            
            // Update the UI on the main thread.
            await MainActor.run {
                characterList = response.results // Replace with fresh data
                hasError = false
                currentPage += 1 // Increment current page for pagination
                isLoading = false
                
                print("✅ HomeViewModel: Successfully fetched data")
            }
        } catch {
            // Handle error and update the UI on the main thread.
            await MainActor.run {
                isLoading = false
                // Check if it's a network error
                if let appError = error as? AppError, case AppError.networkUnavailable = appError {
                    viewError = .networkUnavailable
                } else {
                    viewError = .unExpectedError
                }
                hasError = true
            }
        }
    }
}

/// Extension to initialize `SectionRowModel` from `CharacterBusinessModel`.
extension SectionRowModel {
    init(businessModel: CharacterBusinessModel) {
        self.id = businessModel.id
        self.title = businessModel.name
        self.subtitle = businessModel.species
        self.text = "\(String(describing: businessModel.gender?.rawValue ?? "")) - \(businessModel.origin.name) - \(String(describing: businessModel.status?.rawValue ?? ""))"
        self.image = businessModel.image
        self.progress = businessModel.status == .alive ? 1.0 : 0.1
    }
}
