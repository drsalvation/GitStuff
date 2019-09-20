//
//  ViewController.swift
//  RomanWeek2Test
//
//  Created by MCS on 9/20/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //these global variables will determine the behaviour of the whole code. TheURL will load up the new link. The Dictionary will load up the dictionary values we get from the URL, so basically, we'll work with theDictionary if we are getting a new URL, theNewDictionary (notice the keyword NEW) is the dictionary that will hold our new values if the cell we clicked on had a dictionary. If it's not empty, it will pass the values to the new dictionary loaded to our new view controller. Same goes with theArray, but instead it's an array and not a dictionary.
    var theURL: String = "https://api.tvmaze.com/shows/82?embed=seasons&embed=episodes"
    var theDictionary: [String: Any] = [:]
    var theNewDictionary: [String: Any] = [:]
    var theArray: [Any] = []
    
    //these variables are the assistant variables. They are what the class will work with based on the variables above. sortedKeys will be an array of keys from a dictionary sorted alphabetically. sortedValues is an array of values of any type; Since it's "any" it can't be simply sorted with the function arrays come with; So we'll have to manually sort it out.
    var sortedKeys: [String] = []
    var sortedValues: [Any] = []
    
    @IBOutlet weak var theTableInMainView: UITableView!
   // var theURL: String = "https://api.tvmaze.com/shows/82?embed=seasons&embed=episodes"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpMyTable() //first I set up my table to load up some cells, and create the cell pressed function, and register my own cell
        getTheDictionaryFromOurURL(tableView: theTableInMainView, urlToTest: theURL, theDict: theDictionary) //now I download data from the link and reload my table's data, and assign its collected dictionary to my dictionary. Yes, I'm still in desperate code mode, unless I take this test home for the weekend, then I'll try a more elegant solution with protocols.
       // sortDictionary()
    }
        /////////////////////////////////////////
    //this simply assigns the datasource, the delegate and registers a cell
    func setUpMyTable()
    {
        theTableInMainView.dataSource = self
        theTableInMainView.delegate = self
        theTableInMainView.register(UINib(nibName: "MyCellThingy", bundle: nil), forCellReuseIdentifier: "myCell")
    }
        /////////////////////////////////////////
    
    
        /////////////////////////////////////////
    //we will get a dictionary from the url provided assuming it's a JSON file, and will reload the data in our table view.
    func getTheDictionaryFromOurURL(tableView: UITableView, urlToTest: String, theDict: Dictionary<String, Any>)
    {
        guard let urlThingy = URL(string: urlToTest) else {print("it was NOT a URL"); return}
        URLSession.shared.dataTask(with: urlThingy) { (data, response, error) in
            guard let dataThingy = data else { print("no data found");  return}
            let jsonObjectThingy = try? JSONSerialization.jsonObject(with: dataThingy, options: [])
            guard let myJSONObject = jsonObjectThingy else {print("not a JSON"); return}
            guard let myDictionary = myJSONObject as? [String: Any] else {print("not a dictionary"); return}
            self.theDictionary = myDictionary //I'm simply pulling out the dictionary from the URL session onto our main class.
            self.sortDictionary()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }.resume()
    }
    /////////////////////////////////////////
    
    ////////////////////////////////////////
    //sort out our dictionary if it's not empty to an array of keys, and an array of values.
    func sortDictionary(){
        print("we ARE calling the dicionary sort")
        //we gotta make sure which dictionary are we using
        var index = 0;
        if (theNewDictionary.isEmpty == false){
            print("the new dictionary")
            sortedValues = Array(theNewDictionary.values)
            sortedKeys = Array(theNewDictionary.keys).sorted() //we can simply use this because our keyes are always strings. But values aren't
            for _ in 0..<theNewDictionary.values.count{
                sortedValues[index] = theNewDictionary[sortedKeys[index]]
                index += 1
            }
        }
        else if (theDictionary.isEmpty == false) {
            print("the main dictionary")
            sortedValues = Array(theDictionary.values)
            sortedKeys = Array(theDictionary.keys).sorted() //we can simply use this because our keyes are always strings. But values aren't
            for _ in 0..<theDictionary.values.count{
                sortedValues[index] = theDictionary[sortedKeys[index]]
                index += 1
            }
        }
        else {print("what the hecklers? No dictionaries?")}
    }
    ////////////////////////////////////////
    
    
    /////////////////////////////////////////
    //this will determine what kind of value was passed onto our view, and will return a count for it (if applicable) to set up our new cell size. My default, it will attempt to get "theDictionary" which is where we store the dictionary collected from the URL, but only if our new array and dictionary is empty.
    func getCountOfItems() -> Int{
        if (theArray.isEmpty == false) { return theArray.count }
        else if (theNewDictionary.isEmpty == false) {return theNewDictionary.count }
        else if (theDictionary.isEmpty == false) {return theDictionary.count}
        else {return 5}
    }
    /////////////////////////////////////////
    
    
    /////////////////////////////////////////
    //We will determine the data we got passed on, and check return it's content.
    func getTitleForCellFromKey(theIndex: Int) -> String{
        if (theArray.isEmpty == false) {return getValueAsString(valuePassed: theArray, indexThingy: theIndex)}
        else if (theNewDictionary.isEmpty == false) {
            if (sortedKeys.isEmpty){
                return "sorted keys are empty"}
            else {
                return sortedKeys[theIndex]}}
        else if (theDictionary.isEmpty == false) {
            if (sortedKeys.isEmpty){
                return "sorted keys are empty"}
            else {
            return sortedKeys[theIndex]}
        }
        else {return "what the hell? It's nothing!!"}
    }
    /////////////////////////////////////////
    //same as the previous function, but this will be getting the value data of a dictionary, or return nothing if it's an array. The value from here can be longer than the key value. Remember above how I said I was in desperate code mode? I'm sure both functions above and below can work as one, but not today, sir, oh, not today.
    func getSubtitleForCellFromValue(theIndex: Int) -> String{
        if (theArray.isEmpty == false) {return ""}
        else if (theNewDictionary.isEmpty == false) {return getValueAsString(valuePassed: sortedValues, indexThingy: theIndex)}
        else if (theDictionary.isEmpty == false) {return getValueAsString(valuePassed: sortedValues, indexThingy: theIndex)}
        else {return "what the hell? It's nothing!!"}
    }
    /////////////////////////////////////////
    
    
    /////////////////////////////////////////
    //This function will get a value from whatever it is we're passing it on, check what type of value it is, and return it as a string. We'll use it to be able to give our labels the data we need to view as a name.
    func getValueAsString(valuePassed: Array<Any>, indexThingy: Int) -> String{
        switch valuePassed[indexThingy]{
        case is String:
            return valuePassed[indexThingy] as! String
        case is Array<Any>:
            return "it's an array with \((valuePassed[indexThingy] as! Array<Any>).count) elements"
        case is Dictionary<String, Any>:
            return "it's a dictionary with \((valuePassed[indexThingy] as! Dictionary<String, Any>).count) elements"
        case is URL:
            return (valuePassed[indexThingy] as! URL).absoluteString
        case is NSNull:
            return "it's null"
        case is Int:
            return String(valuePassed[indexThingy] as! Int)
        case is Bool:
            return String(valuePassed[indexThingy] as! Bool)
        default:
            return "wot?"
        }
    }
    /////////////////////////////////////////
    
    func clickedOnTheCell(navController: UINavigationController?, detailedVController: ViewController, valuePassed: Array<Any>, indexPassed: Int)
    {
        switch valuePassed {
        case <#pattern#>:
            <#code#>
        default:
            <#code#>
        }
        navigationController?.pushViewController(detailedVController, animated: true)
    }
    func clickedOnAnURLValue(){
        print("it's a URL")
    }
    func clickedOnAnArrayValue(){
        print("it's an Array")
        
    }
    func clickedOnADictionaryValue(){
        print("it's a Dictionary")
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCountOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCellThingy  
        cell.textLabel?.text = getTitleForCellFromKey(theIndex: indexPath.row)
        cell.detailTextLabel?.text = getSubtitleForCellFromValue(theIndex: indexPath.row)
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //instantiate this one to create another copy of your viewController. Otherwise, create another one with the detailedViewController ID to show the detailed status.
        let detailedViewController = storyboard?.instantiateViewController(withIdentifier: "theFirstViewControllerThingy") as! ViewController
        clickedOnTheCell(navController: self.navigationController, detailedVController: detailedViewController)
        
    }
}
