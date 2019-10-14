//
//  DetailedViewController.swift
//  FinalTestRoman
//
//  Created by MCS on 10/11/19.
//  Copyright © 2019 MCS. All rights reserved.
//

import Foundation
import UIKit
class DetailedViewController: UIViewController{
    
    @IBOutlet weak var theDetailedViewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func onButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
