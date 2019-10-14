//
//  SetContoller.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit

class SetController : UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
        print("home")
        dismiss(animated: true, completion: nil)
        
    }
}
