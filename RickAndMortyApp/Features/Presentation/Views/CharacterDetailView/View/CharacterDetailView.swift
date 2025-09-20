//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    var character: CharacterBusinessModel?
    var localStorageUseCase: LocalStorageUseCase = LocalStorageUseCase()
    @State private var visibleEpisodesCount: Int = 5
    @State private var showMapView = false

    var body: some View {
        ScrollView {
            imageView
            detailView
        }
        .coordinateSpace(.named("scroll"))
        .toolbar(.visible, for: .navigationBar)
        .background(Color("Background"))
        .ignoresSafeArea()
        .sheet(isPresented: $showMapView) {
            if let character = character {
                CharacterMapView(character: character)
            }
        }
    }

    var imageView: some View {
        Group {
            if let character,
               let url = URL(string: character.image) {
                AsyncImageView(url: url)
            } else {
                Image("noImageAvailable")
            }
        }.overlay(alignment: .top) {
            closeButtonView
        }
        .frame(height: 400)
    }

    var closeButtonView: some View {
        ZStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .backgroundStyle(cornerRadius: 18)
            })
            .padding(15)
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .animation(.snappy, value: true)
    }

    var detailView: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY

            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .overlay(
                VStack(alignment: .leading, spacing: 16) {
                    Text(character?.name ?? "")
                        .font(.title).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)

                    Divider()
                        .foregroundColor(.secondary)

                    if let status = character?.status?.rawValue {
                        Text("Status: \(String(describing: status))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    if let species = character?.species {
                        Text("Species: \(String(describing: species))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    if let type = character?.type, !type.isEmpty {
                        Text("Type: \(String(describing: type))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    if let gender = character?.gender?.rawValue {

                        Text("Gender: \(String(describing: gender))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    if let origin = character?.origin.name {
                        Text("Origin: \(String(describing: origin))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    if let location = character?.location.name {
                        Text("Location: \(String(describing: location))".uppercased())
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary.opacity(0.7))

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    // Map Button
                    if let character = character {
                        Button(action: {
                            showMapView = true
                        }) {
                            HStack {
                                Image(systemName: "map")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Ver en mapa")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .foregroundColor(.secondary)
                    }

                    // Episodes section - Expandable version
                    if let character = character, !character.episodes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            // Episodes header
                            HStack {
                                Text("Episodes")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                Spacer()

                                Text("\(character.episodes.count) episodes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.ultraThinMaterial)
                                    .backgroundStyle(cornerRadius: 8)
                            }

                            // Expandable episodes list
                            LazyVStack(spacing: 6) {
                                ForEach(character.episodes.prefix(visibleEpisodesCount), id: \.self) { episodeUrl in
                                    CompactEpisodeRow(
                                        episodeUrl: episodeUrl,
                                        characterId: character.id,
                                        localStorageUseCase: localStorageUseCase
                                    )
                                }

                                // Show "more episodes" button if there are more episodes to show
                                if visibleEpisodesCount < character.episodes.count {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            let remainingEpisodes = character.episodes.count - visibleEpisodesCount
                                            let nextBatch = min(5, remainingEpisodes)
                                            visibleEpisodesCount += nextBatch
                                        }
                                    }) {
                                        Text("+ \(character.episodes.count - visibleEpisodesCount) more episodes")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                            .padding(.top, 4)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(.ultraThinMaterial)
                                            .backgroundStyle(cornerRadius: 8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 16)
                    }
                }
                .padding(20)
                .padding(.vertical, 10)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .cornerRadius(30)
                        .blur(radius: 30)
                )
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 30)
                )
                .offset(y: scrollY > 0 ? -scrollY * 1.8 : 0)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: 300)
                .padding(20)
            )
        }
        .frame(height: 500)
    }
}

// MARK: - Compact Episode Row Component

struct CompactEpisodeRow: View {
    let episodeUrl: String
    let characterId: Int
    let localStorageUseCase: LocalStorageUseCase
    @State private var isWatched: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            // Episode icon
            Image(systemName: "tv")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 16, height: 16)

            // Episode info
            Text(episodeTitle)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()

            // Watch status toggle
            Button(action: {
                isWatched = localStorageUseCase.toggleEpisodeStatus(
                    episodeId: extractEpisodeId(from: episodeUrl),
                    characterId: characterId
                )
            }) {
                Image(systemName: isWatched ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isWatched ? .green : .gray)
                    .animation(.easeInOut(duration: 0.2), value: isWatched)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 8)
        .opacity(isWatched ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isWatched)
        .onAppear {
            isWatched = localStorageUseCase.isEpisodeWatched(
                episodeId: extractEpisodeId(from: episodeUrl),
                characterId: characterId
            )
        }
    }

    private var episodeTitle: String {
        if let url = URL(string: episodeUrl),
           let episodeNumber = url.lastPathComponent.components(separatedBy: "/").last {
            return "Episode \(episodeNumber)"
        }
        return "Unknown Episode"
    }

    private func extractEpisodeId(from url: String) -> String {
        if let url = URL(string: url),
           let episodeId = url.lastPathComponent.components(separatedBy: "/").last {
            return episodeId
        }
        return url
    }
}
