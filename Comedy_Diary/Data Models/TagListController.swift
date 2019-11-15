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

class TagListController: UIViewController , TagListViewDelegate{
    
    let realm = try! Realm()
    
    lazy var  tagList = realm.objects(JokeTag.self)
    
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        for tag in tagList{

            tagListView.addTag(tag.tagName)

        }
        
        
        tagListView.delegate = self

       tagListView.textFont = UIFont.systemFont(ofSize: 14)

        tagListView.alignment = .center

        //tagListView.addTag("On tap will be removed").onTap = { [weak self] tagView in
        //   self?.tagListView.removeTagView(tagView)
        //}
       
        //tagListView.addTags(["Welcome", "to", "TargetListView"])

       // tagListView.insertTag("This should be the second tag", at: 1)
        
    }
        
    @IBAction func addTagButton(_ sender: Any) {
        
        var tagName = UITextField()
        
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
    
    
        
}

