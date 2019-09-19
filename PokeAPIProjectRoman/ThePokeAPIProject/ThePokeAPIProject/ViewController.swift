//
//  ViewController.swift
//  ThePokeAPIProject
//
//  Created by MCS on 9/17/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TheMainTableView: UITableView!
    var Pokemons: [String: Any] = [:]
    var ArrayPassedOn: [Any] = []
    var DictionaryPassedOn: [String: Any] = [:]
    var keysSorted: [String] = []
    var valuesSorted: [Any] = []
    
 //   var pokeKeyName: [String] = [""]
    var urlThingy = "https://pokeapi.co/api/v2"
//    var PokemonKeyName: [String] = ["Pikachu or whatever"]
//    var PokemonKeyValue: [String] = ["internet link my dude"]
    func loadNewTableWithData(theNewTable: UITableView)
    {
        theNewTable.dataSource = self
        theNewTable.delegate = self
        theNewTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //set up our table.
        loadNewTableWithData(theNewTable: TheMainTableView)
//        TheMainTableView.dataSource = self
//        TheMainTableView.delegate = self
//        TheMainTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
//
        
        // Do any additional setup after loading the view
        guard let theURL = URL(string: urlThingy) else {return}
        URLSession.shared.dataTask(with: theURL) { (data, response, error) in
            //make sure that there IS data
            //make sure it IS a JSON
            //make sure it IS a dictionary
            //THEN you can assign it to your own dict.
            guard let dataThingy = data else {
                print("no data")
                return}
            let myJSONThingy = try? JSONSerialization.jsonObject(with: dataThingy, options: [])
            guard let myDataThingy = myJSONThingy else {
                print("it isn't a JSON")
                return}
            guard let myDictionaryThingy = myDataThingy as? [String: Any] else {
                print("it is not a dictionary")
                return}
            self.Pokemons = myDictionaryThingy
            DispatchQueue.main.async {
                self.TheMainTableView.reloadData()
            }
        }.resume()
        
        
    }
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ArrayPassedOn.isEmpty == false) {return ArrayPassedOn.count }
        else if (DictionaryPassedOn.isEmpty == false) {return DictionaryPassedOn.count}
        else{
            return Pokemons.keys.count}
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        //use "cell" to fill in the data your cell should contain
        if (ArrayPassedOn.isEmpty == false){
            cell.titleLabel?.text = "Index[\(indexPath.row)]"
        }
        else if (DictionaryPassedOn.isEmpty == false){
            var myKeys = Array(self.DictionaryPassedOn.keys)
            var keyValue = Array(self.DictionaryPassedOn.values)
            cell.titleLabel?.text = myKeys[indexPath.row]
            if (keyValue[indexPath.row] is String){
                cell.urlLabel?.text = keyValue[indexPath.row] as! String}
        } else
        {
        var myKeys = Array(self.Pokemons.keys).sorted()
        keysSorted = myKeys
        var keyValue = Array(self.Pokemons.values)
        var indexForLoop=0
        for _ in 0..<Pokemons.count{
            
            keyValue[indexForLoop] = Pokemons[myKeys[indexForLoop]]
            indexForLoop += 1
        }
        valuesSorted = keyValue
     //   let value = Array(self.Pokemons.values)[indexPath.row]
        
        cell.titleLabel.text = myKeys[indexPath.row]
        cell.titleLabel.numberOfLines = 1
        cell.urlLabel.numberOfLines = 1
        
        switch keyValue[indexPath.row]{
        case is String:
            cell.urlLabel?.text = keyValue[indexPath.row] as? String
        case is Int:
            cell.urlLabel?.text = "\(keyValue[indexPath.row] as! Int)"
        case is Bool:
                        cell.urlLabel?.text = "\(keyValue[indexPath.row] as? Bool)"
        case is Array<Any>:
            cell.urlLabel?.text = "Array with \( (keyValue[indexPath.row] as! Array<Any>).count ) elements "

        //            cell.urlLabel?.text = "Array with \(keyValue.count) elements"
        case is Dictionary<String, Any>:
                        cell.urlLabel?.text = "Dictionary with \((keyValue[indexPath.row] as! Dictionary<String,Any>).count) elements"
        case is URL:
                        cell.urlLabel?.text = "\(keyValue[indexPath.row] as? URL)"
        case is NSNull:
            cell.urlLabel?.text = "it's null"
        default:
            cell.urlLabel?.text = ""
            
            }
            
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "veiwThingy") as! ViewController
        if (ArrayPassedOn.isEmpty == false){
            print("you pressed on an array element at \(indexPath.row)")
            switch ArrayPassedOn[indexPath.row]{
            case is Array<Any>:
                print("it's an array")
                detailViewController.ArrayPassedOn = ArrayPassedOn[indexPath.row] as! Array<Any>
            case is Dictionary<String, Any>:
                print("it's a dictionary!")
                detailViewController.DictionaryPassedOn = ArrayPassedOn[indexPath.row] as! Dictionary<String, Any>
            default:
                print("It's something else")
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else if (DictionaryPassedOn.isEmpty == false){
            var values = Array(DictionaryPassedOn.values)
            switch values[indexPath.row]{
            case is String:
                detailViewController.urlThingy = (values[indexPath.row] as! String)
            case is URL:
                detailViewController.urlThingy = (values[indexPath.row] as! URL).absoluteString
            case is Array<Any>:
                detailViewController.ArrayPassedOn = values[indexPath.row] as! Array<Any>
            case is Dictionary<String, Any>:
                detailViewController.DictionaryPassedOn = values[indexPath.row] as! Dictionary<String, Any>
            default:
                detailViewController.urlThingy = ""
            }
            if (detailViewController.urlThingy.contains("https://")){
                self.navigationController?.pushViewController(detailViewController, animated: true)}
            
        } else
        {
            
            /////////////////this is the new way to handle it allegedly
            let key = keysSorted[indexPath.row]
            detailViewController.title = key
            switch valuesSorted[indexPath.row]{
            case is URL:
                detailViewController.urlThingy = (valuesSorted[indexPath.row] as! URL).absoluteString
            case is String:
                detailViewController.urlThingy = (valuesSorted[indexPath.row] as! String)
            case is Array<Any>:
                print("pass the array and show it on the table \(valuesSorted[indexPath.row])")
                detailViewController.ArrayPassedOn = valuesSorted[indexPath.row] as! Array<Any>
                print(detailViewController.ArrayPassedOn)
            case is Dictionary<String, Any>:
                print("pass the dictionary and show it on the table")
                detailViewController.DictionaryPassedOn = valuesSorted[indexPath.row] as! Dictionary<String, Any>
            default:
                detailViewController.urlThingy = ""
            }
            if (detailViewController.urlThingy.contains("https://")){
                self.navigationController?.pushViewController(detailViewController, animated: true)}
        }
        /////////////
        
        
        ///////////////////////Uncomment this to get to show previous results/////////////////////
//        let value = valuesSorted[indexPath.row]
//        guard let theNewURLThingy = value as? String else {return}
//        self.navigationController?.pushViewController(detailViewController, animated: true)
//            detailViewController.urlThingy = theNewURLThingy
        //////////////////////////////////////////////////////////////////////////////////////////
    }
    
    
}
