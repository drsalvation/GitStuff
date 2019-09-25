//
//  ViewController.swift
//  RomanPPCoreDataProject
//
//  Created by MCS on 9/24/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var colorTableContainer: UITableView!
    var colorCollection: [String] = ["Red", "Orange", "Purple", "Green", "Blue"]
    var favoriteColorCollection: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedColors = CoreDataManager.shared.getAllFavoriteColors()
        for color in savedColors{
            guard let colorToAdd = color.colorName else {return}
            favoriteColorCollection.append(colorToAdd)
        }
        // Do any additional setup after loading the view.
        colorTableContainer.dataSource = self
        colorTableContainer.delegate = self
    }
    func addFavorite(index: Int){
        if favoriteColorCollection.contains(colorCollection[index]) == false{
        favoriteColorCollection.append(colorCollection[index])
            CoreDataManager.shared.createNewColor(with: colorCollection[index])
        }
    }
    func removeFavorite(index: Int){
        CoreDataManager.shared.deleteItem(keyName: favoriteColorCollection[index])
        favoriteColorCollection.remove(at: index)
        
    }
    
    func saveData(){
        CoreDataManager.shared.saveData()
    }
    func deleteData(itemName: String){
        CoreDataManager.shared.deleteItem(keyName: itemName)
    }
    
    
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return colorCollection.count
        } else {
            return favoriteColorCollection.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           if section == 0 {
                 return "List of Colors"
             } else {
                 return "Favorite Colors"
             }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        if indexPath.section == 0 {
            cell.textLabel?.text = colorCollection[indexPath.row]
        } else {
            cell.textLabel?.text = favoriteColorCollection[indexPath.row]
        }
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            addFavorite(index: indexPath.row)
        } else {
            deleteData(itemName: favoriteColorCollection[indexPath.row])
            removeFavorite(index: indexPath.row)
        }
        colorTableContainer.reloadData()
        saveData()
    }
}
