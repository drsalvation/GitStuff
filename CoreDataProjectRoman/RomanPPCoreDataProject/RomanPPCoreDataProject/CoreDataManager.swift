//
//  CoreDataManager.swift
//  RomanPPCoreDataProject
//
//  Created by MCS on 9/24/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    static var shared = CoreDataManager()
    private init(){}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteColors")
        container.loadPersistentStores(completionHandler: {(description, error) in
            print(description)
            print(error)
        })
        return container
    }()
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func createNewColor(with name: String) -> FavoriteColors?{
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavoriteColors", in: context) else {return nil}
        let newColor = FavoriteColors(entity: entityDescription, insertInto: context)
        newColor.colorName = name
        return newColor
    }
    
    func getAllFavoriteColors() -> [FavoriteColors]{
        let fetchRequest = NSFetchRequest<FavoriteColors>.init(entityName: "FavoriteColors")
       let fetchedColors = try? context.fetch(fetchRequest)
        return fetchedColors ?? []
    }
    
    func saveData(){
        guard context.hasChanges else {return}
        try? context.save()
    }
    
    func deleteItem(keyName: String){
        let fetchRequest = NSFetchRequest<FavoriteColors>.init(entityName: "FavoriteColors")
        guard var fetchedColors = try? context.fetch(fetchRequest) else { return }
        for colors in fetchedColors {
            if colors.colorName == keyName {
                context.delete(colors)
            }
        }
        
    }
}
