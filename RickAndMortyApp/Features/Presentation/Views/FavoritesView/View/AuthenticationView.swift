//
//  AuthenticationView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI

/// View for biometric authentication before accessing favorites
struct AuthenticationView: View {
    @Bindable var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            VStack(spacing: 16) {
                Image(systemName: getBiometricIcon())
                    .font(.system(size: 80))
                    .foregroundColor(.primary)
                    .symbolEffect(.bounce, value: authViewModel.isAuthenticating)

                Text("Secure Access")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Use \(authViewModel.biometricType) to access your favorite characters")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            // Authentication Button
            VStack(spacing: 16) {
                Button(action: {
                    Task {
                        await authViewModel.authenticate()
                    }
                }) {
                    HStack {
                        if authViewModel.isAuthenticating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: getBiometricIcon())
                                .font(.system(size: 20, weight: .medium))
                        }

                        Text(authViewModel.isAuthenticating ? "Authenticating..." :
                                "Use \(authViewModel.biometricType)")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(authViewModel.isAuthenticating || !authViewModel.isBiometricAvailable)
                .opacity(authViewModel.isBiometricAvailable ? 1.0 : 0.6)

                if !authViewModel.isBiometricAvailable {
                    Text("Biometric authentication is not available on this device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
        .background(Color("Background").ignoresSafeArea())
        .alert("Authentication Error", isPresented: $authViewModel.showAuthenticationError) {
            Button("OK") {
                authViewModel.showAuthenticationError = false
            }
        } message: {
            Text(authViewModel.authenticationError ?? "Unknown error occurred")
        }
    }

    /// Gets the appropriate icon for the biometric type
    private func getBiometricIcon() -> String {
        switch authViewModel.biometricType {
        case "Face ID":
            return "faceid"
        case "Touch ID":
            return "touchid"
        case "Optic ID":
            return "opticid"
        default:
            return "lock.shield"
        }
    }
}

#Preview {
    AuthenticationView(authViewModel: AuthenticationViewModel())
}
