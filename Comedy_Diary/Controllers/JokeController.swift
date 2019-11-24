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
    
    let realm = try! Realm()
    var tagMasterList: Results<JokeTag>? = nil
    var displayJoke: Joke?
    var tagArray: List<JokeTag>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontSize:CGFloat = 20
        
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        
        let jokeButtonStyle = [NSAttributedString.Key.font: font]
        
        addJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
            
        deleteJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
        
        self.titleField.delegate = self
        
        self.durationField.delegate = self
        
        masterListOfTags.delegate = self
        
        jokeTags.delegate = self
        
        doTagFormatting()
        
        bodyView.delegate = self as? UITextViewDelegate
        
        tagArray = displayJoke!.tags
        
        //getThisJokesTags()
        
        //getMasterListOfJokes()
        
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
    
}

extension JokeController: TagListViewDelegate{
    
    func doTagFormatting(){
        
        jokeTags.cornerRadius = 10
        
        masterListOfTags.cornerRadius = 10
        
    }
    
    
    func getThisJokesTags(){

        for tag in tagArray!{
            
            jokeTags.addTag(tag.tagName)
            
            }
    }
        
    func getMasterListOfJokes(){
    
        tagMasterList = realm.objects(JokeTag.self)
            
        for tag in tagMasterList!{
            
                masterListOfTags.addTag(tag.tagName)
            
            }
            
        }
        
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {

        //print("tag pressed: \(sender)  == \(masterListOfTags)")
        
        var doNotAdd: Bool = false
        
        if sender == masterListOfTags {
            
            print("match")
            
            for tag in tagArray!{
            
                if (tag.tagName == title) {
                    
                   print("flag 1 = \(doNotAdd)")
                    
                   doNotAdd = true
                
                }
                
            }
            if !doNotAdd {
                          
                // Same object from master list
                
                for tag in tagMasterList! {
                    
                    if (tag.tagName == title) {
                        
                        try! realm.write{
                            
                            jokeTags.addTag(title)
                            
                            displayJoke!.tags.append(tag)
                            
                            print("flag 2 = \(doNotAdd)")
                            
                            doNotAdd = false
                            
                        }

                    }
                    
                }
                
            }
            
        }

    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("remove tag pressed: \(sender)  == \(jokeTags)")
        
        if sender == jokeTags{
            
            for (index, tag) in (displayJoke?.tags.enumerated())! {
            
                if (tag.tagName == title) {
                
                    try! realm.write{
                    
                        displayJoke!.tags.remove(at: index)
                        
                        sender.removeTagView(tagView)

                    }

                }
            
            }
            
        }
    }

    override func viewWillAppear(_ animated: Bool){
        masterListOfTags.removeAllTags()
        jokeTags.removeAllTags()
        getMasterListOfJokes()
        getThisJokesTags()
    }
}
    

