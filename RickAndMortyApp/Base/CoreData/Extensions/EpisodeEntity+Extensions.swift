//
//  EpisodeEntity+Extensions.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import CoreData

extension EpisodeEntity {

    /// Creates an EpisodeEntity for a watched episode
    static func create(episodeId: String, characterId: Int, context: NSManagedObjectContext) -> EpisodeEntity {
        let entity = EpisodeEntity(context: context)
        entity.episodeId = episodeId
        entity.characterId = Int32(characterId)
        entity.watchedDate = Date()
        return entity
    }
}
