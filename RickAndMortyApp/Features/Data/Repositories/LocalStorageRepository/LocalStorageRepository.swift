//
//  LocalStorageRepository.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import Foundation
import CoreData

/// Repository for local storage operations using CoreData
class LocalStorageRepository {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Character Operations
    
    /// Saves a character to local storage
    func saveCharacter(_ character: CharacterBusinessModel) {
        let context = coreDataStack.context
        
        if let existingEntity = getCharacterEntity(by: character.id, context: context) {
            existingEntity.update(with: character)
        } else {
            _ = CharacterEntity.create(from: character, context: context)
        }
        
        coreDataStack.saveContext()
    }
    
    /// Saves multiple characters to local storage
    func saveCharacters(_ characters: [CharacterBusinessModel]) {
        let context = coreDataStack.context
        
        for character in characters {
            if let existingEntity = getCharacterEntity(by: character.id, context: context) {
                existingEntity.update(with: character)
            } else {
                _ = CharacterEntity.create(from: character, context: context)
            }
        }
        
        coreDataStack.saveContext()
    }
    
    /// Gets a character by ID from local storage
    func getCharacter(by id: Int) -> CharacterBusinessModel? {
        let context = coreDataStack.context
        
        guard let entity = getCharacterEntity(by: id, context: context) else {
            return nil
        }
        
        return entity.toBusinessModel()
    }
    
    /// Gets all characters from local storage
    func getAllCharacters() -> [CharacterBusinessModel] {
        let context = coreDataStack.context
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toBusinessModel() }
        } catch {
            print("Error fetching characters: \(error)")
            return []
        }
    }
    
    /// Gets all favorite characters
    func getFavoriteCharacters() -> [CharacterBusinessModel] {
        let context = coreDataStack.context
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        
        do {
            let favoriteEntities = try context.fetch(request)
            var characters: [CharacterBusinessModel] = []
            
            for favorite in favoriteEntities {
                if let character = getCharacter(by: Int(favorite.characterId)) {
                    characters.append(character)
                }
            }
            
            return characters.sorted { $0.name < $1.name }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    // MARK: - Favorite Operations
    
    /// Toggles favorite status for a character
    func toggleFavorite(characterId: Int) -> Bool {
        let context = coreDataStack.context
        
        // Check if already favorite
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "characterId == %d", characterId)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            
            if let existingFavorite = results.first {
                // Remove from favorites
                context.delete(existingFavorite)
                coreDataStack.saveContext()
                return false
            } else {
                // Add to favorites
                _ = FavoriteEntity.create(characterId: characterId, context: context)
                coreDataStack.saveContext()
                return true
            }
        } catch {
            print("Error toggling favorite: \(error)")
            return false
        }
    }
    
    /// Checks if a character is favorite
    func isFavorite(characterId: Int) -> Bool {
        let context = coreDataStack.context
        let request: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "characterId == %d", characterId)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    
    // MARK: - Episode Operations
    
    /// Marks an episode as watched for a character
    func markEpisodeAsWatched(episodeId: String, characterId: Int) {
        let context = coreDataStack.context
        
        // Check if already watched
        let request: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "episodeId == %@ AND characterId == %d", episodeId, characterId)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            
            if results.isEmpty {
                // Add to watched episodes
                _ = EpisodeEntity.create(episodeId: episodeId, characterId: characterId, context: context)
                coreDataStack.saveContext()
            }
        } catch {
            print("Error marking episode as watched: \(error)")
        }
    }
    
    /// Marks an episode as not watched for a character
    func markEpisodeAsNotWatched(episodeId: String, characterId: Int) {
        let context = coreDataStack.context
        
        let request: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "episodeId == %@ AND characterId == %d", episodeId, characterId)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            
            if let episodeEntity = results.first {
                context.delete(episodeEntity)
                coreDataStack.saveContext()
            }
        } catch {
            print("Error marking episode as not watched: \(error)")
        }
    }
    
    /// Checks if an episode is watched for a character
    func isEpisodeWatched(episodeId: String, characterId: Int) -> Bool {
        let context = coreDataStack.context
        let request: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "episodeId == %@ AND characterId == %d", episodeId, characterId)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking episode status: \(error)")
            return false
        }
    }
    
    /// Gets watched episodes for a character
    func getWatchedEpisodes(for characterId: Int) -> [String] {
        let context = coreDataStack.context
        let request: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "characterId == %d", characterId)
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.episodeId }
        } catch {
            print("Error fetching watched episodes: \(error)")
            return []
        }
    }
    
    // MARK: - Private Methods
    
    private func getCharacterEntity(by id: Int, context: NSManagedObjectContext) -> CharacterEntity? {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching character entity: \(error)")
            return nil
        }
    }
}
