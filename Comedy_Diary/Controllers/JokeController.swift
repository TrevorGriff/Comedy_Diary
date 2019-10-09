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
        
        updateJokeDisplay()
    }
    
    func updateJokeDisplay(){
        
        titleField.text = displayJoke?.title
        
        bodyView.text = displayJoke?.body

        durationField.text = displayJoke?.durationString()
        
        lastEditedField.text = "Edited " + (displayJoke?.dateEditedAsString() ?? "")
  
        creatdField.text = "Created " +  (displayJoke?.dateCreatedAsString() ?? "")
       
        countOfSetsField.text = displayJoke?.CountOflinksToSetsAsString()
        
        reloadInputViews()
        
    }
    
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
        RealmDB.shared.delete(displayJoke!)
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        displayJoke = Joke()
        
        RealmDB.shared.create(displayJoke!)
        
        updateJokeDisplay()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
            if (text == "\n"){
                
                if ((textView.text ?? "").isEmpty){
                    
                    displayEmptyStringAlert()
                    
                }else{
                    
                textView.resignFirstResponder()
            
                updateDBValues()
            
                return false
                    
                }
            }
        
         return true
    }
    
   func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if ((textField.text ?? "").isEmpty){
        
        displayEmptyStringAlert ()
        
    }else{
        
        textField.resignFirstResponder()
        
        updateDBValues()
        
        return false
        
        }
    
        return true
    
    }
    
    func updateDBValues(){
        
        let durationInteger = Int(durationField.text ?? "0")
        
        let edited = Date()
            
        let dict: [String: Any?] = ["title": titleField.text, "body": bodyView.text, "duration": durationInteger, "dateEdited": edited]
        
        lastEditedField.text = "Edited " + (displayJoke?.dateEditedAsString() ?? "")
        
        RealmDB.shared.update(displayJoke!, with: dict)
        
    }
    
    func displayEmptyStringAlert () {
            
            let alert = UIAlertController(title: "The text field cannot be empty", message: "Please type some info.", preferredStyle: .alert)
           
            alert.addAction(UIAlertAction(title: "OK",style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        if titleField.text?.isEmpty ?? true || bodyView.text.isEmpty {
            
            RealmDB.shared.delete(displayJoke!)
            
        }
        
    }
}

