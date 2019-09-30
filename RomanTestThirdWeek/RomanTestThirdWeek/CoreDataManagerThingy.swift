//
//  CoreDataManagerThingy.swift
//  RomanTestThirdWeek
//
//  Created by MCS on 9/27/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManagerThingy{
    static let shared = CoreDataManagerThingy()
    private init(){}
    
        lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModelThingy")
        container.loadPersistentStores(completionHandler: {(description, error) in
        })
        return container
    }()
    
    public var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    public func saveState(){
        if context.hasChanges {
            try? context.save()
        }
    }
    public func createNewJoke(with joke: FavoriteJokes) -> FavoriteJokes?{
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavoriteJokes", in: context) else {return nil}
        let newJoke = FavoriteJokes(entity: entityDescription, insertInto: context)
        newJoke.id = joke.id
        newJoke.category = joke.category
        newJoke.type = joke.type
        if newJoke.type == "single"{
            newJoke.joke = joke.joke
        } else {
            newJoke.setup = joke.setup
            newJoke.delivery = joke.delivery
        }
        print("a new joke has been created \(newJoke.category)")
        return newJoke
    }
    public func getAllFavoriteJokes() -> [FavoriteJokes]{
         let fetchRequest = NSFetchRequest<FavoriteJokes>.init(entityName: "FavoriteJokes")
        let fetchedJokes = try? context.fetch(fetchRequest)
         return fetchedJokes ?? []
    }
    public func deleteAllFavoriteJokes(){
        let fetchRequest = NSFetchRequest<FavoriteJokes>.init(entityName: "FavoriteJokes")
            guard var fetchedJokes = try? context.fetch(fetchRequest) else { return }
            for joke in fetchedJokes {
                    context.delete(joke)
        }
        saveState()
    }
    public func deleteAFavoriteJoke(jokeToDelete: FavoriteJokes){
        let fetchRequest = NSFetchRequest<FavoriteJokes>.init(entityName: "FavoriteJokes")
        guard var fetchedJokes = try? context.fetch(fetchRequest) else {return}
        for joke in fetchedJokes{
            if jokeToDelete.id == joke.id{
                context.delete(joke)
            }
        }
        saveState()
    }
}
