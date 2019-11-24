//
//  TagListController.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 11/10/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import TagListView
import RealmSwift

class TagListController: UIViewController , TagListViewDelegate, UITextFieldDelegate{
    
    let realm = try! Realm()
    
    lazy var  tagList = realm.objects(JokeTag.self)
    
    @IBOutlet weak var tagListView: TagListView!
    
    @IBOutlet weak var jokeTags: TagListView!
    
    @IBOutlet weak var tagNameField: UITextField!
    
    var oldTitle = ""
    
    var tagIsSelected: Bool = false
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
    for tag in tagList{

            tagListView.addTag(tag.tagName)

        }
        
        tagListView.delegate = self
        
        tagNameField.delegate = self

        tagListView.textFont = UIFont.systemFont(ofSize: 14)

        tagListView.alignment = .center
        
    }
        
    @IBAction func addTagButton(_ sender: Any) {
        
        var tagName = UITextField()
        
         print("in add tag Button")
        
              let alert = UIAlertController(title: "Add New Tag" , message: "", preferredStyle: .alert)
               
               alert.addTextField { (alertTextField) in
                
                   alertTextField.placeholder = "Type name of new Tag"
                
                    tagName = alertTextField
                  
               }
               
               let addAction = UIAlertAction(title: "Add" , style: .default){ (action) in
                  
                if !tagName.text!.isEmpty {
                    
                    let newTag = JokeTag()
                    RealmDB.shared.create(newTag)
                    
                    let dict: [String: Any?] = ["tagName": tagName.text]
                    RealmDB.shared.update(newTag, with: dict)
                    
                    self.tagListView.addTag(tagName.text!)
                       
                   }
                   
               }
        
               alert.addAction(addAction)
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .default){(action) in }
        
               alert.addAction(cancelAction)
               
               present(alert, animated: true, completion: nil)
               
           }
    
 func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
    
        print("Tag Remove pressed: \(title), \(sender)")
    
        sender.removeTagView(tagView)
    
        // Delete from Master List DB
        let results = realm.objects(JokeTag.self).filter("tagName == %d", tagView.titleLabel?.text)
        
        for tagToBeDeleted in results{
            
            RealmDB.shared.delete(tagToBeDeleted )
            
        }
        
        //Delete from all Jokes using the tag
    
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        print("Is in tagPressed")
        
        if !tagView.isSelected{

            tagNameField.text = title
            oldTitle = title
            print("Title: \(title) Old Title: \(oldTitle)")
            tagIsSelected = true
            
        }else{
            
            tagNameField.text?.removeAll()
        }
        
        tagView.isSelected = !tagView.isSelected
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{

//        print("Done Key Pressed:")
//        print("New title: \(textField.text)")
//        print("old title: \(oldTitle)")
//        print("tagIsSelected: \(tagIsSelected)")
        let newTitle = textField.text
//
        if (!(oldTitle == newTitle) || !oldTitle.isEmpty || newTitle!.isEmpty)
        && tagIsSelected{
            
                self.tagListView.removeTag(oldTitle)
                        
                self.tagListView.addTag(newTitle!)
            
                tagNameField.text?.removeAll()
                        
                tagNameField.resignFirstResponder()
            
                tagIsSelected = false
            
                updateTagsInDB(newTitle!, oldTitle)
                        
        }else{
            print ("in else statement")
            tagIsSelected = false
            return false
        }

           return true
      }
    
    func updateTagsInDB(_ newTitle: String, _ oldTitle: String){
        
        // Find all instances of oldTitle
        let jokes = realm.objects(Joke.self)
        let newTag: JokeTag = JokeTag()
        newTag.tagName = newTitle
        
        for joke in jokes{
            
            for jokeTag in jokes{
                
                for (index, tag) in jokeTag.tags.enumerated(){
                    
                    if (tag.tagName == oldTitle){
                        
                        try! realm.write{
                            // update all jokes
                            jokeTag.tags.remove(at: index)
                            jokeTag.tags.append(newTag)
                        }
                    }
                }
            }
            
            let tags = realm.objects(JokeTag.self)
            
                for tag in tags{
                
                if (tag.tagName == oldTitle){
                    
                    //try! realm.write{
                        RealmDB.shared.delete(tag)
                        RealmDB.shared.create(newTag)
                    //}
                }
                
            }
        }
    }
    
}

