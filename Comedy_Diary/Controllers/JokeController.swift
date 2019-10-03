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

class JokeController: UIViewController, UITextFieldDelegate{
   
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    @IBOutlet weak var creatdField: UITextField!
    @IBOutlet weak var lastEditedField: UITextField!
    @IBOutlet weak var countOfSetsField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    
    var displayJoke: Joke?
    
   
    override func viewDidLoad(){
        super.viewDidLoad()
            
        
        bodyField.delegate = self as! UITextFieldDelegate
        
        titleField.text = displayJoke?.title
        
        bodyField.text = displayJoke?.body

        durationField.text = displayJoke?.durationString()
        
        creatdField.text = "Created " +  (displayJoke?.dateCreatedAsString() ?? "")
        
        lastEditedField.text = "Edited " + (displayJoke?.dateEditedAsString() ?? "")
        
        countOfSetsField.text = displayJoke?.CountOflinksToSetsAsString()
        
        reloadInputViews()
    }
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        print("Delete")
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        print("Add")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        bodyField.text = displayJoke?.body
//        let realm = RealmDB.shared.realm
//        realm.up
        
        
        bodyField.resignFirstResponder()
        
        return true
    }
    
    
}
