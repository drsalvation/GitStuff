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
//            print("the description:\(description)\n\n\n\n\n\n\n\n\n\n\n")
//            print("the error: \(error)\n")
        })
        return container
    }()
    
    public var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    
}
