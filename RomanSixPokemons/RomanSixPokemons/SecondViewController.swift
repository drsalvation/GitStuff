//
//  SecondViewController.swift
//  RomanSixPokemons
//
//  Created by MCS on 10/2/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController{
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var theLabel: UILabel!
    var imageURL: String = ""
    var pokemonName: String = ""
    var pokemonNumber: Int = 0
    var flavorDescription: String = ""
    
    func transferData(pokemon: TheJSONDecoder, index: Int){
        imageURL = pokemon.pokemon[index].sprites.frontDefault
        pokemonName = pokemon.pokemon[index].name
        pokemonNumber = pokemon.pokemon[index].id
        flavorDescription = pokemon.pokemonFlavor(index: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let theImageURL = URL(string: imageURL) else {return}
        URLSession.shared.dataTask(with: theImageURL){ (data, _, _) in
            guard let image = data else {return}
            DispatchQueue.main.async {
                self.imageViewOutlet.image = UIImage(data: image)
            }
        }.resume()
        theLabel.text = "Name: \(pokemonName)\nNumber: \(pokemonNumber)\nFlavor Description: \(flavorDescription)"
    }
    @IBAction func onButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
