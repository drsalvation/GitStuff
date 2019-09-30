//
//  FavoriteJokes+CoreDataProperties.swift
//  RomanTestThirdWeek
//
//  Created by MCS on 9/27/19.
//  Copyright © 2019 MCS. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteJokes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteJokes> {
        return NSFetchRequest<FavoriteJokes>(entityName: "FavoriteJokes")
    }
    
    @NSManaged public var category: String
    @NSManaged public var type: String
    @NSManaged public var joke: String
    @NSManaged public var setup: String
    @NSManaged public var delivery: String
    @NSManaged public var id: Int64

}
