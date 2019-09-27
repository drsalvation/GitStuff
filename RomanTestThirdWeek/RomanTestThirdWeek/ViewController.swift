//
//  ViewController.swift
//  RomanTestThirdWeek
//
//  Created by MCS on 9/27/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

//TL;DR
/*
 For some reason, I'm getting a signal abort error on a random thread number, and it takes me to what I think is an objective-C chunk of code. I don't get it at all.
 I think it happens when the decoder tries to decode a two-part joke. When you try decoding mostly "program" jokes, which most of them are single line jokes, it will work, but it will randomly crash the app. As I said, I guess it's because of the 2-part jokes?
 I thiink it's because I have joke, setup and deliver properties, even tho my JSON can have only joke, OR setup AND delivery... so does this mean I have to create a different DataModel for single jokes and two-part jokes?
 Well, I'm about to find out, as I write this, I'll attempt to do 2 data models. But just so you know, before I wrote this, I only had one. So if you're reading this, it means it didn't work, so at least, you'll already know I failed.
 
 UPDATE: I'm just gonna leave it instead so you can laugh at it... Apparently I forgot to create the "setup" and "delivery" attributes. I had created them before, which is why I added them in my code, but I must've spaced out, but I don't know why they weren't there anymore, maybe I deleted them, or maybe I never did add them in my data model.
 It works now, just so you know.
 */


class ViewController: UIViewController {

    @IBOutlet weak var theTable: UITableView!
    @IBOutlet weak var theSegmentController: UISegmentedControl!
    @IBOutlet weak var theButton: UIButton!
    var jokeType: String = "Any"
    var collectionOfJokes: [FavoriteJokes] = []
    var jokeContainer: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theTable.delegate = self
        theTable.dataSource = self
    }
    // https://sv443.net/jokeapi/category/
    
    func decodeLink(){
        guard let url = URL(string: "https://sv443.net/jokeapi/category/" + jokeType) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            guard let decodedJoke = try? JSONDecoder().decode(FavoriteJokes.self, from: data) else {
                print("failed to decode, check your optionals in your json")
                return
            }
            if decodedJoke.type == "single"{
                self.jokeContainer.append(decodedJoke.joke)
            } else {
                self.jokeContainer.append(decodedJoke.setup + "\n\n\n" + decodedJoke.delivery)
            }
            self.collectionOfJokes.append(decodedJoke)
            DispatchQueue.main.async {
                self.theTable.reloadData()
            }
        }.resume()
    }
    
//    func serializeLink(){
//        guard let url = URL(string: "https://sv443.net/jokeapi/category/" + jokeType) else {return}
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            guard let data = data else {return}
//
//
//        }.resume()
//    }
    

    @IBAction func onIndexChange(_ sender: Any) {
        switch theSegmentController.selectedSegmentIndex{
        case 0:
            jokeType = "Any"
        case 1:
            jokeType = "Programming"
        case 2:
            jokeType = "Miscellaneous"
        case 3:
            jokeType = "Dark"
        default:
            print("it should say Favorites")
        }
        filerTableByCategory(category: jokeType)
        theTable.reloadData()
        
    }
    func filerTableByCategory(category: String){
        jokeContainer.removeAll()
        for joke in collectionOfJokes{
            if category == "Any"{
                jokeContainer.append(getJoke(theJoke: joke))
            } else if joke.category == category{
                jokeContainer.append(getJoke(theJoke: joke))
            }
        }
    }

    func getJoke(theJoke: FavoriteJokes) -> String{
        if theJoke.type == "single"{
            return theJoke.joke
        } else {
            return theJoke.setup + "\n\n" + theJoke.delivery
        }
    }
    
    @IBAction func onButtonPress(_ sender: Any) {
        decodeLink()
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this line doesn't do anything, but the code stops working when I delete it
        return jokeContainer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = jokeContainer[indexPath.row]
        cell.textLabel?.numberOfLines = 0
      //  cell.detailTextLabel?.text = collectionOfJokes[indexPath.row].category //uncomment it to view the category as a subtitle in the cell.
        if indexPath.row%2 == 0{
            cell.backgroundColor = .lightGray
        }
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate{
    
}
