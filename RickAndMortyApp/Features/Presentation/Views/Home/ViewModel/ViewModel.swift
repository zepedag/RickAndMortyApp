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
    
    /// Flag to prevent multiple simultaneous API calls
    private var isApiCallInProgress: Bool = false
    
    /// Flag to track if initial load has been completed
    private var hasInitialLoadCompleted: Bool = false

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
        // Exit if already loading data or API call in progress
        guard !isLoading && !isApiCallInProgress else { 
            print("HomeViewModel: Skipping loadCharacterList - already in progress")
            return 
        }
        
        // If we already have characters and this is not a refresh, skip loading
        if hasInitialLoadCompleted && !characterList.isEmpty {
            print("HomeViewModel: Skipping loadCharacterList - data already loaded")
            return
        }

        // Set loading flags
        isLoading = true
        isApiCallInProgress = true

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
                isApiCallInProgress = false
                hasInitialLoadCompleted = true
                print("HomeViewModel: Successfully loaded page \(currentPage - 1)")
            }
        } catch {
            // Handle error and update the UI on the main thread.
            await MainActor.run {
                isLoading = false
                isApiCallInProgress = false
                viewError = .unExpectedError
                hasError = true
                print("HomeViewModel: Error loading characters - \(error)")
            }
        }
    }

    /// Refreshes the character list by resetting pagination and loading fresh data
    func refreshCharacterList() async {
        // Exit if already loading data or API call in progress
        guard !isLoading && !isApiCallInProgress else { 
            print("HomeViewModel: Skipping refreshCharacterList - already in progress")
            return 
        }
        
        // Reset pagination and flags
        currentPage = 1
        hasInitialLoadCompleted = false

        // Set loading flags
        isLoading = true
        isApiCallInProgress = true

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
                isApiCallInProgress = false

                print("✅ HomeViewModel: Successfully refreshed data")
            }
        } catch {
            // Handle error and update the UI on the main thread.
            await MainActor.run {
                isLoading = false
                isApiCallInProgress = false
                // Check if it's a network error
                if let appError = error as? AppError, case AppError.networkUnavailable = appError {
                    viewError = .networkUnavailable
                } else {
                    viewError = .unExpectedError
                }
                hasError = true
                print("HomeViewModel: Error refreshing characters - \(error)")
            }
        }
    }
    
    /// Forces initial load if no data is available
    func ensureInitialLoad() async {
        if characterList.isEmpty && !hasInitialLoadCompleted {
            await loadCharacterList()
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
        self.progress = 1.0 // Always show full circle, color will indicate status
        self.status = businessModel.status
    }
}
