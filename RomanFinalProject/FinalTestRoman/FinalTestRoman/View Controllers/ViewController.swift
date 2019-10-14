//
//  ViewController.swift
//  FinalTestRoman
//
//  Created by MCS on 10/11/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var theTableView: UITableView!
    
    @IBOutlet weak var theInputTextField: UITextField!
    
    @IBOutlet weak var theLabelInMainView: UILabel!
    
    @IBOutlet weak var theButtonInMainView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theTableView.dataSource = self
        theTableView.delegate = self
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        let secondViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
        present(secondViewController, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedViewController = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        present(detailedViewController, animated: true)
    }
}
