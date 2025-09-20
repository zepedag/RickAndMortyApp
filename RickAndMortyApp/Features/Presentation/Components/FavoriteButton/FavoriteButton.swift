//
//  FavoriteButton.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

struct FavoriteButton: View {
    let characterId: Int
    @State private var isFavorite: Bool = false
    @State private var isLoading: Bool = false

    private let localStorageUseCase = LocalStorageUseCase()

    var body: some View {
        Button(action: toggleFavorite) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .font(.title2)
                .scaleEffect(isLoading ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isLoading)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .onAppear {
            checkFavoriteStatus()
        }
    }

    private func checkFavoriteStatus() {
        isFavorite = localStorageUseCase.isFavorite(characterId: characterId)
    }

    private func toggleFavorite() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isFavorite = self.localStorageUseCase.toggleFavorite(characterId: self.characterId)
            self.isLoading = false
        }
    }
}

#Preview {
    HStack {
        FavoriteButton(characterId: 1)
        FavoriteButton(characterId: 2)
    }
    .padding()
}
