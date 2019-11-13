//
//  UITabBarController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit

class MainTabController : UITabBarController {
    
    @IBOutlet weak var mainNavTabBar: UITabBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainNavTabBar.items?[0].title = "Joke List"
        mainNavTabBar.items?[1].title = "Set List"
        mainNavTabBar.items?[2].title = "Showtime"
        mainNavTabBar.items?[3].title = "Home"
        
    }
    
}
