//
//  JokeController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class JokeController: UIViewController {
   
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var bodyField: UITextField!
    
    var displayJoke: Joke?
   
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //print("Passed: \(selectedJoke)")

        titleField.text = displayJoke?.title
        
        
        bodyField.text = displayJoke?.body
        
        reloadInputViews()
    }
    
    
}
