//
//  CharacterMapView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI
import MapKit

struct CharacterMapView: View {
    let character: CharacterBusinessModel
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var annotations: [CharacterAnnotation] = []

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image("noImageAvailable")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                            .shadow(radius: 5)

                            Text(character.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        }
                    }
                }
                .ignoresSafeArea()

                VStack {
                    Spacer()

                    // Location Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                            Text("Última ubicación conocida")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                        Text(character.location.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Estado: \(character.status?.rawValue.capitalized ?? "Desconocido")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Ubicación de \(character.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            setupMapLocation()
        }
    }

    private func setupMapLocation() {
        // Simulate character location based on their location name
        let simulatedLocation = getSimulatedLocation(for: character.location.name)

        region = MKCoordinateRegion(
            center: simulatedLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        annotations = [
            CharacterAnnotation(
                coordinate: simulatedLocation,
                character: character
            )
        ]
    }

    private func getSimulatedLocation(for locationName: String) -> CLLocationCoordinate2D {
        // Simulate different locations based on character location names
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
        default:
            // Default to a random location for unknown places
            return CLLocationCoordinate2D(
                latitude: Double.random(in: -90...90),
                longitude: Double.random(in: -180...180)
            )
        }
    }
}

struct CharacterAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let character: CharacterBusinessModel
}

#Preview {
    CharacterMapView(character: CharacterBusinessModel(
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
    ))
}
