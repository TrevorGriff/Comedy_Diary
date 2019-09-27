//
//  HomeViewController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/2/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//
import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    private let jokeListIndex = 0
    private let setListIndex = 1
    private let showtimeIndex = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func jokeListTapped(_ sender: Any) {
        displayControllerbyIndex(index: jokeListIndex)
        
    }
    
    
    @IBAction func setListTapped(_ sender: Any) {
        displayControllerbyIndex(index: setListIndex)
    }
    
    @IBAction func showtimeTapped(_ sender: Any) {
        displayControllerbyIndex(index: showtimeIndex)
    }
    
    private func displayControllerbyIndex(index: Int){
        
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        mainTabController.selectedViewController = mainTabController.viewControllers?[index]
    
        present(mainTabController, animated: true, completion: nil)
        
    }
    
}

