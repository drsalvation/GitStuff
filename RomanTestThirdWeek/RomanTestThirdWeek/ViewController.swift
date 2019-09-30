//
//  ViewController.swift
//  RomanTestThirdWeek
//
//  Created by MCS on 9/27/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theTable: UITableView!
    @IBOutlet weak var theSegmentController: UISegmentedControl!
    @IBOutlet weak var theButton: UIButton!
    var jokeType: String = "Any"
    var collectionOfJokes: [FavoriteJokes] = []
    var favoriteJokeContainer: [FavoriteJokes] = []
    var filteredJokes: [FavoriteJokes] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       //CoreDataManagerThingy.shared.deleteAllFavoriteJokes() //uncomment this line to delete all your saved favorite jokes.
        theTable.delegate = self
        theTable.dataSource = self
        favoriteJokeContainer = CoreDataManagerThingy.shared.getAllFavoriteJokes()
        for joke in favoriteJokeContainer{
            filteredJokes.insert(joke, at: 0)
            print("the joke is \(joke.category)")
        }
        filerTableByCategory(category: jokeType)
        theTable.reloadData()
    }
    func getFavoritesToArray(){
        
    }
    func decodeLink(){
        guard let url = URL(string: "https://sv443.net/jokeapi/category/" + jokeType) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            guard let decodedJoke = try? JSONDecoder().decode(FavoriteJokes.self, from: data) else {
                print("failed to decode, check your optionals in your json")
                return
            }
            self.collectionOfJokes.append(decodedJoke)
            self.filteredJokes.append(decodedJoke)
            DispatchQueue.main.async {
                self.theTable.reloadData()
            }
        }.resume()
    }

    @IBAction func onIndexChange(_ sender: Any) {
        switch theSegmentController.selectedSegmentIndex{
        case 0:
            jokeType = "Any"
            filerTableByCategory(category: jokeType)
        case 1:
            jokeType = "Programming"
            filerTableByCategory(category: jokeType)
        case 2:
            jokeType = "Miscellaneous"
            filerTableByCategory(category: jokeType)
        case 3:
            jokeType = "Dark"
            filerTableByCategory(category: jokeType)
        default:
            jokeType = "Favorites"
            getFavorites()
        }
        theTable.reloadData()
    }
    
    func getFavorites(){
        filteredJokes.removeAll()
        for joke in favoriteJokeContainer{
            filteredJokes.append(joke)
        }
    }
    
    func filerTableByCategory(category: String){
        filteredJokes.removeAll()
        for joke in collectionOfJokes{
            if category == "Any"{
                filteredJokes.insert(joke, at: 0)
                //filteredJokes.append(joke)
            } else if joke.category == category{
                filteredJokes.insert(joke, at: 0)
                //filteredJokes.append(joke)
            }
        }
    }
    
    func getJokesAsString(joke: FavoriteJokes) -> String{
        if joke.type == "single"{
        return joke.joke
        } else {
            return joke.setup + "\n\n" + joke.delivery
        }
    }
    
    @IBAction func onButtonPress(_ sender: Any) {
        if jokeType != "Favorites"{
        decodeLink()
            filerTableByCategory(category: jokeType)
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = getJokesAsString(joke: filteredJokes[indexPath.row])
        cell.textLabel?.numberOfLines = 0
      //  cell.detailTextLabel?.text = collectionOfJokes[indexPath.row].category //uncomment it to view the category as a subtitle in the cell.
        if indexPath.row%2 == 0{
            cell.backgroundColor = .lightGray
        }
        for joke in favoriteJokeContainer{
            if filteredJokes[indexPath.row].id == joke.id{
                cell.backgroundColor = .yellow
            }
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if favoriteJokeContainer.isEmpty == false {
            for joke in favoriteJokeContainer{
                if joke.id != filteredJokes[indexPath.row].id{
                    favoriteJokeContainer.append(filteredJokes[indexPath.row])
                    CoreDataManagerThingy.shared.createNewJoke(with: filteredJokes[indexPath.row])
                    CoreDataManagerThingy.shared.saveState()
                }
                else {
                    CoreDataManagerThingy.shared.deleteAFavoriteJoke(jokeToDelete: filteredJokes[indexPath.row])
                      filerTableByCategory(category: jokeType)
                }
            }
        } else {
            favoriteJokeContainer.append(filteredJokes[indexPath.row])
            CoreDataManagerThingy.shared.createNewJoke(with: filteredJokes[indexPath.row])
            CoreDataManagerThingy.shared.saveState()
        }
        theTable.reloadData()
    }
}
