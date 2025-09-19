//
//  CharacterEntity+Extensions.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import CoreData

extension CharacterEntity {
    
    /// Creates a CharacterEntity from CharacterBusinessModel
    static func create(from character: CharacterBusinessModel, context: NSManagedObjectContext) -> CharacterEntity {
        let entity = CharacterEntity(context: context)
        entity.id = Int32(character.id)
        entity.name = character.name
        entity.status = character.status?.rawValue
        entity.species = character.species
        entity.type = character.type
        entity.gender = character.gender?.rawValue
        entity.image = character.image
        entity.url = character.url
        entity.created = character.created
        entity.originName = character.origin.name
        entity.originUrl = character.origin.url
        entity.locationName = character.location.name
        entity.locationUrl = character.location.url
        entity.episodes = character.episodes as NSObject
        entity.lastUpdated = Date()
        return entity
    }
    
    /// Converts CharacterEntity to CharacterBusinessModel
    func toBusinessModel() -> CharacterBusinessModel {
        let origin = LocationBusinessModel(name: originName ?? "", url: originUrl ?? "")
        let location = LocationBusinessModel(name: locationName ?? "", url: locationUrl ?? "")
        
        return CharacterBusinessModel(
            id: Int(id),
            name: name ?? "",
            status: StatusBusinessModel(rawValue: status ?? "unknown"),
            species: species ?? "",
            type: type ?? "",
            gender: GenderBusinessModel(rawValue: gender ?? "unknown"),
            origin: origin,
            location: location,
            image: image ?? "",
            episodes: episodes as? [String] ?? [],
            url: url ?? "",
            created: created ?? ""
        )
    }
    
    /// Updates existing CharacterEntity with new data
    func update(with character: CharacterBusinessModel) {
        self.name = character.name
        self.status = character.status?.rawValue
        self.species = character.species
        self.type = character.type
        self.gender = character.gender?.rawValue
        self.image = character.image
        self.url = character.url
        self.created = character.created
        self.originName = character.origin.name
        self.originUrl = character.origin.url
        self.locationName = character.location.name
        self.locationUrl = character.location.url
        self.episodes = character.episodes as NSObject
        self.lastUpdated = Date()
    }
}
