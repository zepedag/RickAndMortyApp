//
//  BiometricAuthenticationService.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import Foundation
import LocalAuthentication

/// Service for handling biometric authentication using LocalAuthentication framework
class BiometricAuthenticationService {

    /// Available biometric types
    enum BiometricType {
        case none
        case touchID
        case faceID
        case opticID
    }

    /// Authentication result
    enum AuthenticationResult {
        case success
        case failure(String)
        case userCancel
        case userFallback
        case systemCancel
        case passcodeNotSet
        case notAvailable
    }

    /// Singleton instance
    static let shared = BiometricAuthenticationService()

    private init() {}

    /// Checks if biometric authentication is available
    func isBiometricAuthenticationAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Gets the available biometric type
    func getBiometricType() -> BiometricType {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            return .opticID
        @unknown default:
            return .none
        }
    }

    /// Gets the localized name for the biometric type
    func getBiometricTypeName() -> String {
        switch getBiometricType() {
        case .none:
            return "Biometric Authentication"
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        case .opticID:
            return "Optic ID"
        }
    }

    /// Authenticates using biometric authentication
    func authenticate(reason: String? = nil) async -> AuthenticationResult {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error = error {
                switch error.code {
                case LAError.passcodeNotSet.rawValue:
                    return .passcodeNotSet
                case LAError.biometryNotAvailable.rawValue:
                    return .notAvailable
                default:
                    return .failure("Biometric authentication is not available")
                }
            }
            return .notAvailable
        }

        // Use default reason if none provided
        let authenticationReason = reason ?? "Access your favorites securely"

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: authenticationReason
            )

            return success ? .success : .failure("Authentication failed")

        } catch let error as LAError {
            switch error.code {
            case .userCancel:
                return .userCancel
            case .userFallback:
                return .userFallback
            case .systemCancel:
                return .systemCancel
            case .passcodeNotSet:
                return .passcodeNotSet
            case .biometryNotAvailable:
                return .notAvailable
            case .biometryNotEnrolled:
                return .failure("No biometric data enrolled")
            case .biometryLockout:
                return .failure("Biometric authentication is locked out")
            default:
                return .failure("Authentication failed: \(error.localizedDescription)")
            }
        } catch {
            return .failure("Unexpected error: \(error.localizedDescription)")
        }
    }

    /// Authenticates with fallback to passcode
    func authenticateWithPasscode(reason: String? = nil) async -> AuthenticationResult {
        let context = LAContext()
        var error: NSError?

        // Check if device owner authentication is available (biometric + passcode)
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            if let error = error {
                switch error.code {
                case LAError.passcodeNotSet.rawValue:
                    return .passcodeNotSet
                default:
                    return .failure("Device authentication is not available")
                }
            }
            return .notAvailable
        }

        let authenticationReason = reason ?? "Access your favorites securely"

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: authenticationReason
            )

            return success ? .success : .failure("Authentication failed")

        } catch let error as LAError {
            switch error.code {
            case .userCancel:
                return .userCancel
            case .userFallback:
                return .userFallback
            case .systemCancel:
                return .systemCancel
            case .passcodeNotSet:
                return .passcodeNotSet
            default:
                return .failure("Authentication failed: \(error.localizedDescription)")
            }
        } catch {
            return .failure("Unexpected error: \(error.localizedDescription)")
        }
    }
}
