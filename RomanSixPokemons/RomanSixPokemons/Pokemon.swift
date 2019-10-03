//
//  Pokemon.swift
//  RomanSixPokemons
//
//  Created by MCS on 10/2/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation

struct Pokemon: Codable{
    var name: String
    var id: Int
    var sprites: Sprites
    var species: Species
}
struct Sprites: Codable{
    var frontDefault: String
    enum CodingKeys: String, CodingKey{
        case frontDefault = "front_default"
    }
}
struct Species: Codable{
    var url: String
}


struct FlavorEntries: Codable {
    var base_happiness: Int
    var flavor_text_entries: [Flavor]
}
struct Flavor: Codable{
    var flavor_text: String
    var language: Language
}
struct Language: Codable{
    var name: String
}
