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
import TagListView

class JokeController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIToolbarDelegate{
   
    @IBOutlet weak var jokeToolBar: UINavigationItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var creatdField: UITextField!
    @IBOutlet weak var lastEditedField: UITextField!
    @IBOutlet weak var countOfSetsField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var addJokeButton: UIBarButtonItem!
    @IBOutlet weak var deleteJokeButton: UIBarButtonItem!
    
    @IBOutlet weak var jokeTags: TagListView!
    @IBOutlet weak var masterListOfTags: TagListView!
    
    var displayJoke: Joke?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontSize:CGFloat = 20
        
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        
        let jokeButtonStyle = [NSAttributedString.Key.font: font]
        
        addJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
            
        deleteJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
        
        self.titleField.delegate = self
        
        self.durationField.delegate = self
        
        bodyView.delegate = self as? UITextViewDelegate
        
        getThisJokesTags()
        
        updateJokeDisplay()
    }
    
    func updateJokeDisplay(){
        
        titleField.text = displayJoke?.title
        
        bodyView.text = displayJoke?.body

        durationField.text = displayJoke?.durationString()
        
        lastEditedField.text =  (displayJoke?.dateEditedAsString() ?? "")
  
        creatdField.text = (displayJoke?.dateCreatedAsString() ?? "")
       
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
        
        lastEditedField.text = (displayJoke?.dateEditedAsString() ?? "")
        
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
    
    @IBAction func tagJoke(_ sender: Any) {
        
        var tagsView: UIView = UIView()
        
        let alert = UIAlertController(title: "Select Tag", message: "", preferredStyle: .alert)
        
//        alert.add
//        let tagJokeAction: UItagsView
        
    }
    
}

extension JokeController: TagListViewDelegate{
    
    
    func getThisJokesTags(){
        
        let tagArray = displayJoke!.tags
        
        for (index, tag) in tagArray.enumerated(){
            
            jokeTags.addTag(tag.tagName)
            
            }
        
        func getMasterListOfJokes(){
            
            
            
            
        }
        
        
    }
    
}

