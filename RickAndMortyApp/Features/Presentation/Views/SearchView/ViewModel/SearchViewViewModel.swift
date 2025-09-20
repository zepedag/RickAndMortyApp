//
//  SearchViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import Observation
import Combine

@Observable class SearchViewModel {
    /// The use case object for performing character-related operations.
    private var useCase: CharacterUseCase

    /// The current page number for API pagination.
    private var currentPage: Int = 1

    /// A flag indicating whether more characters can be fetched.
    private var canFetchMoreCharacters: Bool = true

    /// A flag to indicate whether the API call is in progress.
    var isLoading: Bool = false

    /// A list to store the fetched character models.
    var characterList: [CharacterBusinessModel] = []

    /// A list to store the filtered character models.
    var filteredCharacterList: [CharacterBusinessModel] = []

    /// Current status filter
    var currentStatusFilter: StatusBusinessModel?

    /// Current species filter
    var currentSpeciesFilter: String?

    /// A work item for debouncing, if needed.
    var workItem: DispatchWorkItem?

    init(useCase: CharacterUseCase = DefaultCharacterUseCase()) {
        self.useCase = useCase
    }

    /// Searches for characters based on the provided name.
    ///
    /// - Parameter name: The name of the character to search for.
    func searchCharacter(by name: String, isFirstLoad: Bool) async {
        if name.isEmpty {
            resetSearch()
            return
        }
        guard !isLoading, canFetchMoreCharacters else { return }
        isLoading = true

        // Network connectivity is automatically monitored

        if isFirstLoad {
            currentPage = 1
            characterList = []
        }
        await fetchSearchCharacter(by: name)
    }

    /// Applies filters to the current character list
    ///
    /// - Parameters:
    ///   - status: The status filter to apply
    ///   - species: The species filter to apply
    func applyFilters(status: StatusBusinessModel?, species: String?) {
        // Store the current filter values
        currentStatusFilter = status
        currentSpeciesFilter = species

        // Apply client-side filtering
        filteredCharacterList = characterList.filter { character in
            var matchesStatus = true
            var matchesSpecies = true

            // Check status filter
            if let statusFilter = status {
                matchesStatus = character.status == statusFilter
            }

            // Check species filter
            if let speciesFilter = species {
                matchesSpecies = character.species.lowercased().contains(speciesFilter.lowercased())
            }

            return matchesStatus && matchesSpecies
        }

        print("Applied filters - Status: \(status?.rawValue ?? "All"), Species: \(species ?? "All")")
        print("Filtered \(characterList.count) characters to \(filteredCharacterList.count)")
    }

    /// Clears all applied filters
    func clearFilters() {
        currentStatusFilter = nil
        currentSpeciesFilter = nil
        filteredCharacterList = characterList
    }
}

// MARK: - Private Methods
extension SearchViewModel {
    /// Internal method to fetch characters based on a name.
    ///
    /// - Parameter name: The name of the character to search for.
    private func fetchSearchCharacter(by name: String) async {
        do {
            let response = try await useCase.searchCharacter(by: name, and: "\(currentPage)")
            await MainActor.run {
                characterList += response.results  // Append new characters to existing list
                filteredCharacterList = characterList  // Update filtered list with new characters
                currentPage += 1  // Increment page number for next fetch
                isLoading = false
                canFetchMoreCharacters = true

                print("✅ SearchViewModel: Successfully fetched data")
            }
        } catch {
            await handleError()
        }
    }

    /// Resets the search state to the initial settings.
    private func resetSearch() {
        canFetchMoreCharacters = true
        characterList = []
        filteredCharacterList = []
        currentPage = 1
    }

    /// Handles any errors during API calls.
    private func handleError() async {
        if characterList.isEmpty {
            await MainActor.run {
                isLoading = false
            }
        } else {
            await MainActor.run {
                isLoading = false
                canFetchMoreCharacters = false
            }
        }
    }
}
