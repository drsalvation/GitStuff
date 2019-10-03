//
//  ViewController.swift
//  RomanSixPokemons
//
//  Created by MCS on 10/1/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theTableView: UITableView!
            let jsonDecoder = TheJSONDecoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        jsonDecoder.createTableWithPokemon(viewController: self)
        
        
    }


}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        //since we already know we need 6, I thought it would look cleaner to just add 6. But if you insist on me adding a function to return the number of the array... ok.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = jsonDecoder.pokemonName(index: indexPath.row)
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewC = storyboard.instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController
        secondViewC.transitioningDelegate = self
        secondViewC.transferData(pokemon: jsonDecoder, index: indexPath.row)
        present(secondViewC, animated: true)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return TransitionAnimationsThingy()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimationsThingy()
    }
}
