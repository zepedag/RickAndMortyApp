//
//  AuthenticationViewModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import Foundation
import Observation

/// ViewModel for handling authentication state in FavoritesView
@Observable class AuthenticationViewModel {

    // MARK: - Properties

    /// Whether the user is currently authenticated
    var isAuthenticated: Bool = false

    /// Whether authentication is in progress
    var isAuthenticating: Bool = false

    /// Error message if authentication fails
    var authenticationError: String?

    /// Whether to show authentication error
    var showAuthenticationError: Bool = false

    /// Whether biometric authentication is available
    var isBiometricAvailable: Bool = false

    /// The type of biometric authentication available
    var biometricType: String = "Biometric Authentication"

    // MARK: - Dependencies

    private let biometricService: BiometricAuthenticationService

    // MARK: - Initialization

    init(biometricService: BiometricAuthenticationService = .shared) {
        self.biometricService = biometricService
        checkBiometricAvailability()
    }

    // MARK: - Public Methods

    /// Authenticates the user using biometric authentication
    func authenticate() async {
        guard !isAuthenticating else { return }

        isAuthenticating = true
        authenticationError = nil
        showAuthenticationError = false

        let result = await biometricService.authenticateWithPasscode(
            reason: "Access your favorite characters securely"
        )

        await MainActor.run {
            isAuthenticating = false

            switch result {
            case .success:
                isAuthenticated = true

            case .failure(let message):
                authenticationError = message
                showAuthenticationError = true

            case .userCancel:
                // User cancelled, don't show error
                break

            case .userFallback:
                // User chose fallback, don't show error
                break

            case .systemCancel:
                // System cancelled, don't show error
                break

            case .passcodeNotSet:
                authenticationError = "Please set up a passcode to use biometric authentication"
                showAuthenticationError = true

            case .notAvailable:
                authenticationError = "Biometric authentication is not available on this device"
                showAuthenticationError = true
            }
        }
    }

    /// Logs out the user
    func logout() {
        isAuthenticated = false
        authenticationError = nil
        showAuthenticationError = false
    }

    /// Checks if biometric authentication is available
    private func checkBiometricAvailability() {
        isBiometricAvailable = biometricService.isBiometricAuthenticationAvailable()
        biometricType = biometricService.getBiometricTypeName()
    }
}
