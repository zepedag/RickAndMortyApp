//
//  DependencyContainer.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import Foundation
import Swinject

/// Main dependency injection container for the Rick and Morty App
class DependencyContainer {

    // MARK: - Singleton
    static let shared = DependencyContainer()

    // MARK: - Properties
    private let container = Container()

    // MARK: - Initialization
    private init() {
        setupDependencies()
    }

    // MARK: - Public Methods

    /// Resolves a dependency of the specified type
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Failed to resolve dependency of type \(T.self)")
        }
        return resolved
    }

    /// Resolves a dependency of the specified type with a name
    func resolve<T>(_ type: T.Type, name: String) -> T {
        guard let resolved = container.resolve(type, name: name) else {
            fatalError("Failed to resolve dependency of type \(T.self) with name \(name)")
        }
        return resolved
    }

    // MARK: - Private Methods

    private func setupDependencies() {
        setupServices()
        setupRepositories()
        setupUseCases()
        setupViewModels()
    }

    // MARK: - Services Registration

    private func setupServices() {
        // API Service
        container.register(ApiService.self) { _ in
            DefaultApiService()
        }.inObjectScope(.container)

        // CoreData Stack - Singleton scope
        container.register(CoreDataStack.self) { _ in
            CoreDataStack()
        }.inObjectScope(.container)

        // Network Monitor - Singleton scope
        container.register(NetworkMonitor.self) { _ in
            NetworkMonitor()
        }.inObjectScope(.container)

        // Biometric Authentication Service - Singleton scope
        container.register(BiometricAuthenticationService.self) { _ in
            BiometricAuthenticationService()
        }.inObjectScope(.container)

        // Integration Service - Singleton scope
        container.register(IntegrationService.self) { resolver in
            IntegrationService(localStorageUseCase: resolver.resolve(LocalStorageUseCase.self)!)
        }.inObjectScope(.container)
    }

    // MARK: - Repositories Registration

    private func setupRepositories() {
        // Character Repository
        container.register(CharacterRepository.self) { resolver in
            DefaultCharacterRepository(
                apiService: resolver.resolve(ApiService.self)!
            )
        }.inObjectScope(.container)

        // Local Storage Repository
        container.register(LocalStorageRepository.self) { resolver in
            LocalStorageRepository(
                coreDataStack: resolver.resolve(CoreDataStack.self)!
            )
        }.inObjectScope(.container)
    }

    // MARK: - Use Cases Registration

    private func setupUseCases() {
        // Character Use Case
        container.register(CharacterUseCase.self) { resolver in
            DefaultCharacterUseCase(
                repository: resolver.resolve(CharacterRepository.self)!
            )
        }.inObjectScope(.container)

        // Local Storage Use Case
        container.register(LocalStorageUseCase.self) { resolver in
            LocalStorageUseCase(
                localRepository: resolver.resolve(LocalStorageRepository.self)!
            )
        }.inObjectScope(.container)
    }

    // MARK: - ViewModels Registration

    private func setupViewModels() {
        // Home ViewModel
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                useCase: resolver.resolve(CharacterUseCase.self)!,
                localStorageUseCase: resolver.resolve(LocalStorageUseCase.self)!
            )
        }.inObjectScope(.transient) // New instance for each resolution

        // Search ViewModel
        container.register(SearchViewModel.self) { resolver in
            SearchViewModel(
                useCase: resolver.resolve(CharacterUseCase.self)!
            )
        }.inObjectScope(.transient)

        // Favorites ViewModel
        container.register(FavoritesViewModel.self) { resolver in
            FavoritesViewModel(
                localStorageUseCase: resolver.resolve(LocalStorageUseCase.self)!
            )
        }.inObjectScope(.transient)

        // Authentication ViewModel
        container.register(AuthenticationViewModel.self) { resolver in
            AuthenticationViewModel(
                biometricService: resolver.resolve(BiometricAuthenticationService.self)!
            )
        }.inObjectScope(.transient)
    }
}

// MARK: - Convenience Extensions

extension DependencyContainer {

    /// Convenience method to resolve HomeViewModel
    func resolveHomeViewModel() -> HomeViewModel {
        return resolve(HomeViewModel.self)
    }

    /// Convenience method to resolve SearchViewModel
    func resolveSearchViewModel() -> SearchViewModel {
        return resolve(SearchViewModel.self)
    }

    /// Convenience method to resolve FavoritesViewModel
    func resolveFavoritesViewModel() -> FavoritesViewModel {
        return resolve(FavoritesViewModel.self)
    }

    /// Convenience method to resolve AuthenticationViewModel
    func resolveAuthenticationViewModel() -> AuthenticationViewModel {
        return resolve(AuthenticationViewModel.self)
    }
}
