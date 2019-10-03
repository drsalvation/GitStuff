//
//  TheJSONDecoder.swift
//  RomanSixPokemons
//
//  Created by MCS on 10/2/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import UIKit
class TheJSONDecoder{
    
    var pokemon: [Pokemon] = []
    var pokemonFlavor: [FlavorEntries] = []
    let dispatchGroup = DispatchGroup()
    func decodeLink(){
        var indexInLoop = 0
        dispatchGroup.enter()
        for _ in 0 ... 6 {
        let pokemonNumberIndex = Int.random(in: 1...807)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonNumberIndex)") else {return}
        URLSession.shared.dataTask(with: url){ [weak self] (data, _, _) in
            guard let data = data, let decodedPokemon = try? JSONDecoder().decode(Pokemon.self, from: data) else {
                print("couldn't get your stuff, bruv")
                return
            }
            print("this IS happening")
            self?.getPokemonFlavors(pokemonToDecode: decodedPokemon)
            self?.pokemon.append(decodedPokemon)
        }.resume()
        }
        dispatchGroup.leave()
    }
    
    func getPokemonFlavors(pokemonToDecode: Pokemon){
        guard let url = URL(string: pokemonToDecode.species.url) else {
            return
            
        }
        print(url.absoluteString)
        URLSession.shared.dataTask(with: url){ [weak self] (data, _, _) in
            guard let data = data else {
                print("couldn't either get data")
                return
            }
            do{
            let decodedFlavor = try JSONDecoder().decode(FlavorEntries.self, from: data)
                self?.pokemonFlavor.append(decodedFlavor)
            } catch {
                print(error.localizedDescription)
            }
           // print(decodedFlavor)
        }.resume()
    }
    
    
    func createTableWithPokemon(viewController: ViewController)
    {
        decodeLink()
        dispatchGroup.notify(queue: .main){
            viewController.theTableView.delegate = viewController
            viewController.theTableView.dataSource = viewController
            }
    }
    func pokemonName(index: Int)->String{
        if pokemon.isEmpty{
            return "no pokemon found, try again later"
        } else {
        return pokemon[index].name
        }
    }
    func pokemonFlavor(index: Int) -> String{
        var indexToReturn = 0
        var indexCurrentLoop = 0
        for language in pokemonFlavor[index].flavor_text_entries{
            if language.language.name == "en"{
                indexToReturn = indexCurrentLoop
            }
            indexCurrentLoop += 1
        }
        return pokemonFlavor[index].flavor_text_entries[indexToReturn].flavor_text
        }
    }
    

