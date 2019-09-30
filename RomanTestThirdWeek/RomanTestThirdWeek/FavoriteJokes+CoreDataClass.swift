//
//  FavoriteJokes+CoreDataClass.swift
//  RomanTestThirdWeek
//
//  Created by MCS on 9/27/19.
//  Copyright © 2019 MCS. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoriteJokes)
public class FavoriteJokes: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey{
        case category
        case type
        case joke
        case setup
        case delivery
        case id
    }
        public convenience  required init(from decoder: Decoder) throws{
            guard let description = NSEntityDescription.entity(forEntityName: "FavoriteJokes", in: CoreDataManagerThingy.shared.context) else {
                throw CoreDataErrors.invalidEntityDescription }
            self .init(entity: description, insertInto: nil)//CoreDataManagerThingy.shared.context)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            category = try container.decode(String.self, forKey: .category)
            type = try container.decode(String.self, forKey: .type)
            id = try container.decode(Int64.self, forKey: .id)
            if type == "single" {
            joke = try container.decode(String.self, forKey: .joke)
            } else if type == "twopart" {
            setup = try container.decode(String.self, forKey: .setup)
            delivery = try container.decode(String.self, forKey: .delivery)
            }
            
        }
        public func encode(to encoder: Encoder){
            var container = encoder.container(keyedBy: CodingKeys.self)
            try? container.encode(category, forKey: .category)
            try? container.encode(type, forKey: .type)
            try? container.encode(id, forKey: .id)
            if type == "single" {
                try? container.encode(joke, forKey: .joke)
            } else if type == "twopart" {
                try? container.encode(setup, forKey: .setup)
                try? container.encode(delivery, forKey: .delivery)
            }
           }

}

enum CoreDataErrors: Error{
    case invalidEntityDescription
}
