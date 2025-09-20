//
//  FavoritesView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI
import Observation

struct FavoritesView: View {
    @Bindable var viewModel: FavoritesViewModel
    @State private var authViewModel = AuthenticationViewModel()
    @State private var showCharacterDetail = false
    @State private var selectedCharacter: CharacterBusinessModel?
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            if !authViewModel.isAuthenticated {
                // Show authentication view
                AuthenticationView(authViewModel: authViewModel)
                    .navigationTitle("Secure Access")
                    .navigationBarTitleDisplayMode(.large)
            } else {
                // Show favorites content
                favoritesContent
                    .navigationTitle("Favorites")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Logout") {
                                authViewModel.logout()
                            }
                            .foregroundColor(.red)
                        }
                    }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadFavorites()
            }
        }
        .sheet(isPresented: $showCharacterDetail) {
            if let character = selectedCharacter {
                CharacterDetailView(character: character)
            }
        }
    }
    
    // MARK: - Favorites Content
    
    private var favoritesContent: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.favoriteCharacters.isEmpty {
                emptyView
            } else {
                favoritesListView
            }
        }
        .refreshable {
            await viewModel.refreshFavorites()
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.viewError?.localizedDescription ?? "An unexpected error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading favorites...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Characters you mark as favorites will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteCharacters, id: \.id) { character in
                    FavoriteCharacterRow(
                        character: character,
                        onTap: {
                            selectedCharacter = character
                            showCharacterDetail = true
                        },
                        onRemoveFavorite: {
                            viewModel.removeFromFavorites(characterId: character.id)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - Favorite Character Row

struct FavoriteCharacterRow: View {
    let character: CharacterBusinessModel
    let onTap: () -> Void
    let onRemoveFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Character Image
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("noImageAvailable")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                
                // Character Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        StatusIndicator(status: character.status)
                        Spacer()
                        Text("\(character.episodes.count) episodes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Remove from favorites button
                Button(action: onRemoveFavorite) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Status Indicator

struct StatusIndicator: View {
    let status: StatusBusinessModel?
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status?.rawValue.capitalized ?? "Unknown")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        case .none:
            return .gray
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel())
}
