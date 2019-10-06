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

class JokeController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
   
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var creatdField: UITextField!
    @IBOutlet weak var lastEditedField: UITextField!
    @IBOutlet weak var countOfSetsField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    
    var displayJoke: Joke?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.titleField.delegate = self
        
        self.durationField.delegate = self
        
        
        bodyView.delegate = self as? UITextViewDelegate
        
        titleField.text = displayJoke?.title
        
        bodyView.text = displayJoke?.body

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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
       
        if (text == "\n"){
            
            textView.resignFirstResponder()
            
            return updateDBValues()
            
        }
        return true
    }
    
   func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
      
        return updateDBValues()
    
      }
    
    func updateDBValues() -> Bool{
        
        let durationInteger = Int(durationField.text ?? "0")
        
        let edited = Date()
            
        let dict: [String: Any?] = ["title": titleField.text, "body": bodyView.text, "duration": durationInteger, "dateEdited": edited]
        
        lastEditedField.text = "Edited " + (displayJoke?.dateEditedAsString() ?? "")
        
        RealmDB.shared.update(displayJoke!, with: dict)
        
        return false
        
    }
    
    
}

