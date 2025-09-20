//
//  FavoriteEntity+Extensions.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import CoreData

extension FavoriteEntity {

    /// Creates a FavoriteEntity for a character
    static func create(characterId: Int, context: NSManagedObjectContext) -> FavoriteEntity {
        let entity = FavoriteEntity(context: context)
        entity.characterId = Int32(characterId)
        entity.addedDate = Date()
        return entity
    }
}
