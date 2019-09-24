//
//  ViewController.swift
//  RomanSharanPPCoreDataProject
//
//  Created by MAC on 9/23/19.
//  Copyright © 2019 PaulRenfrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var colorList: [String] = ["Red", "Green", "Yellow", "Purple", "Brown"]
  var favoriteColorList: [String] = []
  @IBOutlet weak var justATableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    if UserDefaults.standard.array(forKey: "favorites")?.isEmpty == false {
        print("the data that will be assigned is \(UserDefaults.standard.array(forKey: "favorites"))")
        favoriteColorList = UserDefaults.standard.array(forKey: "favorites") as! [String]
        print("the data assigned is \(favoriteColorList)")
    } else{
        print("there was no data to assign.")
    }
    justATableView.dataSource = self
    justATableView.delegate = self
  }
  func addToFavorites(index: Int){
    if (!favoriteColorList.contains(colorList[index])){
      favoriteColorList.append(colorList[index])}
    
  }
  
  func removeFromFavorites(index: Int){
    favoriteColorList.remove(at: index)
  }
    func updateStoredData(){
        print("the data to be stored is \(favoriteColorList)")
        UserDefaults.standard.set(favoriteColorList, forKey: "favorites")
        print("the stored data is now \(UserDefaults.standard.array(forKey: "favorites"))")
    }

}

extension ViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return colorList.count}
    else {return favoriteColorList.count}
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
    if section == 0{
      return "List of Colors"
    } else {
      return "List of Favorites"
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
    if indexPath.section == 0 {
      cell.textLabel?.text = colorList[indexPath.row]
      
    } else {
      cell.textLabel?.text = favoriteColorList[indexPath.row]
    }
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  
}

extension ViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
    addToFavorites(index: indexPath.row)
    } else {
      removeFromFavorites(index: indexPath.row)
    }
    updateStoredData()
    justATableView.reloadData()
  }
}
