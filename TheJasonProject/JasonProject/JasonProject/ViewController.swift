//
//  ViewController.swift
//  JasonProject
//
//  Created by MCS on 9/16/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //how to get the data from the JSON file? We need to know where it is, and we do that with URL's. So we can get our JSON URL.
        print("This is the first line of text you'll see")
        //everything after "guard" and before "else {return}" is just the "if no data is null"
        guard let jsonURL = Bundle.main.url(forResource: "PokemonExample", withExtension: "json"), let data = try? Data(contentsOf: jsonURL), let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) else {return}
        print(pokemon)
        print("This is supposed to appear after printing pokemon")
        //Long story short: It's easier than using JSONSerialization.
        
        
        //this chunk of code below was for Swift 3. The code above (before the let pokemon = try?) is for Swift 4
        /* let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
        print(Pokemon(jsonDictionary: jsonDictionary))
 */
    }


}

struct Pokemon: Codable{
    let name: String
    let abilities: [Ability]
    let stats: [Stats]
    let base_experience: Int
    let sprites: Sprites
//
//    enum CodingKeysForRoot: String, CodingKey{
//        case baseExperience = "base_experience"
//    }
    //this is an experimental initializer, it's good for one property, but NOT for all;
    //there HAS to be an easier way
//    init?(jsonDictionary: [String: Any]){
  //      guard let name = jsonDictionary["name"] as? String else { return nil }
    //    self.name = name
   // }
    //if you were using Swift 3, then you were messed up. Thankfully, I was born into Swift 4, and the protocol is called "Codable"
    //Use "Codable" on your struct name
}

struct Ability: Codable{ //I'm using Codable so that the pokemon struct can use it
    let isHidden: Bool
    let slot: Int
    let name: String
    
    //this is more of an aesthetic code, so that your code can look nice, it's counterproductive here in this example.
    enum CodingKeys: String, CodingKey{
        case isHidden = "is_hidden"
        case slot = "slot"
        case ability
    }
    //the "aesthetic" code is no more "just aesthetic" but it will help us get this chunk of code below to get to the level 2 of our JSON File.
    enum AbilityContainerCodingKeys: String, CodingKey{
        case name
    }
    
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        slot = try container.decode(Int.self, forKey: .slot)
        let abilityContainer = try container.nestedContainer(keyedBy: AbilityContainerCodingKeys.self, forKey: .ability)
        name = try abilityContainer.decode(String.self, forKey: .name)
    }
    //so if you didn't want to encode, you should've thought about your future as a programmer!
    //you can use Decodable protocol, because Codable requires both decode and encode functions to work as a protocol.
    func encode(to encoder: Encoder) throws {
        //this encode function is currently just here to make "Ability" to comform to both Decodable and Encodable protocols that Codable needs.
        var container = encoder.container(keyedBy: CodingKeys.self)
        var abilityContainer = container.nestedContainer(keyedBy: AbilityContainerCodingKeys.self, forKey: .ability)
       try abilityContainer.encode(name, forKey: .name)
        try container.encode(isHidden, forKey: .isHidden)
        try container.encode(slot, forKey: .slot)
    }
}

struct Stats: Codable{
    let baseStat: Int
    let effort: Int
    let name: String
    
    enum TheCodingKeysThingy: String, CodingKey{
        case baseStat = "base_stat"
        case effort
        case stat
    }
    enum StatContainerCodingKeys: String, CodingKey{
        case name
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: TheCodingKeysThingy.self)
        baseStat = try container.decode(Int.self, forKey: .baseStat)
        effort = try container.decode(Int.self, forKey: .effort)
        let statContainer = try container.nestedContainer(keyedBy: StatContainerCodingKeys.self, forKey: .stat)
        name = try statContainer.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws{
     var container = encoder.container(keyedBy: TheCodingKeysThingy.self)
        var statContainer = container.nestedContainer(keyedBy: StatContainerCodingKeys.self, forKey: .stat)
        try statContainer.encode(name, forKey: .name)
        try container.encode(baseStat, forKey: .baseStat)
        try container.encode(effort, forKey: .effort)
    }
}

struct Sprites: Codable{
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum TheCodingKeys: String, CodingKey{
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TheCodingKeys.self)
        backDefault = try? container.decode(String.self, forKey: .backDefault)
        backFemale = try? container.decode(String.self, forKey: .backFemale)
        backShiny = try? container.decode(String.self, forKey: .backShiny)
        backShinyFemale = try? container.decode(String.self, forKey: .backShinyFemale)
        frontDefault = try? container.decode(String.self, forKey: .frontDefault)
        frontFemale = try? container.decode(String.self, forKey: .frontFemale)
        frontShiny = try? container.decode(String.self, forKey: .frontShiny)
        frontShinyFemale = try? container.decode(String.self, forKey: .frontShinyFemale)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TheCodingKeys.self)
        try container.encode(backDefault, forKey: .backDefault)
        try container.encode(backFemale, forKey: .backFemale)
        try container.encode(backShiny, forKey: .backShiny)
        try container.encode(backShinyFemale, forKey: .backShinyFemale)
        try container.encode(frontDefault, forKey: .frontDefault)
        try container.encode(frontFemale, forKey: .frontFemale)
        try container.encode(frontShiny, forKey: .frontShiny)
        try container.encode(frontShinyFemale, forKey: .frontShinyFemale)
    }
    
}
