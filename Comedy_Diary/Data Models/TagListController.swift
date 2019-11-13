//
//  TagListController.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 11/10/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import TagListView

class TagListController: UIViewController , TagListViewDelegate{
    
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        
        tagListView.delegate = self

       tagListView.textFont = UIFont.systemFont(ofSize: 14)

        tagListView.alignment = .center

        tagListView.addTag("On tap will be removed").onTap = { [weak self] tagView in
            self?.tagListView.removeTagView(tagView)
        }
       
        tagListView.addTags(["Welcome", "to", "TargetListView"])

        tagListView.insertTag("This should be the second tag", at: 1)
        
    }
        
    @IBAction func addTagButton(_ sender: Any) {
        
        var tagName: String = ""
        
              let alert = UIAlertController(title: "Add New Tag" , message: "", preferredStyle: .alert)
               
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Type name of new Tag"
                tagName = String(alertTextField.text!)
               }
               
               let addAction = UIAlertAction(title: "Add" , style: .default){ (action) in
                  
                if !tagName.isEmpty {
                       
                    print("Tag: \(tagName)")
                    
                    Tags.shared.addTag(tagName)
                       
                   }
                   
               }
               alert.addAction(addAction)
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .default){(action) in }
               alert.addAction(cancelAction)
               
               present(alert, animated: true, completion: nil)
               
           }
        
}

