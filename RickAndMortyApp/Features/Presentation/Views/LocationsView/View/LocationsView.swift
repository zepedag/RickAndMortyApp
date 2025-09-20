//
//  LocationsView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    @EnvironmentObject var router: Router
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0), // Center of world
        span: MKCoordinateSpan(latitudeDelta: 80.0, longitudeDelta: 80.0)
    )
    @State private var selectedCharacter: CharacterBusinessModel?
    @State private var showCharacterDetail = false

    // Sample characters with different locations for demonstration
    private let sampleCharacters: [CharacterBusinessModel] = [
        CharacterBusinessModel(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            location: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 2,
            name: "Morty Smith",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Citadel of Ricks", url: ""),
            location: LocationBusinessModel(name: "Citadel of Ricks", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 3,
            name: "Summer Smith",
            status: .alive,
            species: "Human",
            type: "",
            gender: .female,
            origin: LocationBusinessModel(name: "Interdimensional Cable", url: ""),
            location: LocationBusinessModel(name: "Interdimensional Cable", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 4,
            name: "Beth Smith",
            status: .alive,
            species: "Human",
            type: "",
            gender: .female,
            origin: LocationBusinessModel(name: "Purge Planet", url: ""),
            location: LocationBusinessModel(name: "Purge Planet", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 5,
            name: "Jerry Smith",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Venzenulon 7", url: ""),
            location: LocationBusinessModel(name: "Venzenulon 7", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 6,
            name: "Abadango Cluster Princess",
            status: .alive,
            species: "Alien",
            type: "",
            gender: .female,
            origin: LocationBusinessModel(name: "Bepis 9", url: ""),
            location: LocationBusinessModel(name: "Bepis 9", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/6.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 7,
            name: "Abradolf Lincler",
            status: .unknown,
            species: "Human",
            type: "Genetic experiment",
            gender: .male,
            origin: LocationBusinessModel(name: "Cronenberg World", url: ""),
            location: LocationBusinessModel(name: "Cronenberg World", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/7.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 8,
            name: "Adjudicator Rick",
            status: .dead,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Planet Squanch", url: ""),
            location: LocationBusinessModel(name: "Planet Squanch", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/8.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 9,
            name: "Agency Director",
            status: .dead,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Giant's Town", url: ""),
            location: LocationBusinessModel(name: "Giant's Town", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/9.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 10,
            name: "Alan Rails",
            status: .dead,
            species: "Human",
            type: "Superhuman (Ghost trains summoner)",
            gender: .male,
            origin: LocationBusinessModel(name: "Post-Apocalyptic Earth", url: ""),
            location: LocationBusinessModel(name: "Post-Apocalyptic Earth", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/10.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 11,
            name: "Albert Einstein",
            status: .dead,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            location: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/11.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 12,
            name: "Alexander",
            status: .dead,
            species: "Human",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            location: LocationBusinessModel(name: "Earth (C-137)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/12.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 13,
            name: "Alien Googah",
            status: .unknown,
            species: "Alien",
            type: "",
            gender: .unknown,
            origin: LocationBusinessModel(name: "Unknown", url: ""),
            location: LocationBusinessModel(name: "Unknown", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/13.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        ),
        CharacterBusinessModel(
            id: 14,
            name: "Alien Morty",
            status: .unknown,
            species: "Alien",
            type: "",
            gender: .male,
            origin: LocationBusinessModel(name: "Unknown", url: ""),
            location: LocationBusinessModel(name: "Unknown", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/14.jpeg",
            episodes: ["1", "2", "3"],
            url: "",
            created: ""
        )
    ]

    private var characterAnnotations: [CharacterAnnotation] {
        sampleCharacters.map { character in
            CharacterAnnotation(
                coordinate: getSimulatedLocation(for: character.location.name),
                character: character
            )
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: characterAnnotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        Button(action: {
                            selectedCharacter = annotation.character
                            showCharacterDetail = true
                        }) {
                            VStack {
                                AsyncImage(url: URL(string: annotation.character.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image("noImageAvailable")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(statusColor(for: annotation.character.status), lineWidth: 3)
                                )
                                .shadow(radius: 3)

                                Text(annotation.character.name)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .ignoresSafeArea()

                VStack {
                    Spacer()

                    // Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Text("Ubicaciones de Personajes")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                        Text("Toca cualquier personaje en el mapa para ver sus detalles")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("\(sampleCharacters.count) personajes")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("Coordenadas simuladas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Ubicaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        router.pop()
                    }
                }
            }
        }
        .sheet(isPresented: $showCharacterDetail) {
            if let character = selectedCharacter {
                CharacterDetailView(character: character)
            }
        }
    }

    private func statusColor(for status: StatusBusinessModel?) -> Color {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .orange
        case .none:
            return .gray
        }
    }

    private func getSimulatedLocation(for locationName: String) -> CLLocationCoordinate2D {
        switch locationName.lowercased() {
        case "earth (c-137)":
            return CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060) // New York
        case "citadel of ricks":
            return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        case "unknown":
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // Null Island
        case "interdimensional cable":
            return CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) // Los Angeles
        case "purge planet":
            return CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918) // Miami
        case "venzenulon 7":
            return CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278) // London
        case "bepis 9":
            return CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522) // Paris
        case "cronenberg world":
            return CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503) // Tokyo
        case "planet squanch":
            return CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093) // Sydney
        case "giant's town":
            return CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176) // Moscow
        case "post-apocalyptic earth":
            return CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074) // Beijing
        default:
            // Default to a random location for unknown places
            return CLLocationCoordinate2D(
                latitude: Double.random(in: -90...90),
                longitude: Double.random(in: -180...180)
            )
        }
    }
}

#Preview {
    LocationsView()
        .environmentObject(Router())
}
