//
//  CharacterListBusinessModel.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation

// MARK: - CharacterListBusinessModel
struct CharacterListBusinessModel {
    let info: InfoBusinessModel
    let results: [CharacterBusinessModel]
    
    init(response: CharacterListResponse) {
        info = InfoBusinessModel(next: response.info.next ?? "",
                                 prev: response.info.prev ?? "")
        results = response.results.map({ response in
            CharacterBusinessModel(response: response)
        })
    }
    
    // Convenience initializer for local data
    init(info: InfoBusinessModel, results: [CharacterBusinessModel]) {
        self.info = info
        self.results = results
    }
}

// MARK: - Info
struct InfoBusinessModel {
    let next, prev: String
    
    init(next: String, prev: String) {
        self.next = next
        self.prev = prev
    }
}

// MARK: - Result
struct CharacterBusinessModel {
    let id: Int
    let name: String
    let status: StatusBusinessModel?
    let species, type: String
    let gender: GenderBusinessModel?
    let origin, location: LocationBusinessModel
    let image: String
    let episodes: [String]
    let url: String
    let created: String
    
    var listOfEpisodes: String {
        episodes.compactMap { URL(string: $0)?.lastPathComponent }.joined(separator: ", ")
    }
    
    init(response: CharacterResponse) {
        id = response.id
        name = response.name
        status = StatusBusinessModel(rawValue: response.status.rawValue)
        species = response.species
        type = response.type
        gender = GenderBusinessModel(rawValue: response.gender.rawValue)
        origin = LocationBusinessModel(response: response.origin)
        location = LocationBusinessModel(response: response.location)
        image = response.image
        episodes = response.episode
        url = response.url
        created = response.created
    }
    
    // Convenience initializer for local data
    init(id: Int, name: String, status: StatusBusinessModel?, species: String, type: String, gender: GenderBusinessModel?, origin: LocationBusinessModel, location: LocationBusinessModel, image: String, episodes: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episodes = episodes
        self.url = url
        self.created = created
    }
}

// MARK: - Location
struct LocationBusinessModel {
    let name: String
    let url: String
    
    init(response: LocationResponse) {
        self.name = response.name
        self.url = response.url
    }
    
    // Convenience initializer for local data
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

enum GenderBusinessModel: String {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

enum StatusBusinessModel: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}




