//
//  SetListController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SetListRow: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var numberOfJokesLabel: UILabel!
    @IBOutlet weak var dateEditedLabel: UILabel!
    
}

class SetListController:  UIViewController {

    @IBOutlet weak var setTable: UITableView!
    
    let realm = try! Realm()
    
    lazy var sets = realm.objects(ASet.self)
    
    var setIndex: Int = 0
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
//        print(realm.configuration.fileURL)
        
        setTable?.delegate = self
        
        setTable?.dataSource = self
        
        setTable.rowHeight = 50
        
        loadSets()
        
    }
    
    func loadSets(){
        
        sets = realm.objects(ASet.self)
        
        setTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        self.setTable?.reloadData()
        
    }
    
    @IBAction func addSetButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
       let alert = UIAlertController(title: "Add New Set" , message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type name of new Set"
            textField = alertTextField
        }
        
        let action1 = UIAlertAction(title: "Add" , style: .default){ (action) in
           
            if !textField.text!.isEmpty {
                
                let newSet = ASet()
                RealmDB.shared.create(newSet)
                
                let dict: [String: Any?] = ["title": textField.text]
                RealmDB.shared.update(newSet, with: dict)
                
                self.setTable.reloadData()
            }
            
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "Cancel", style: .default){(action) in }
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}


extension SetListController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return sets.count
        
    }
    
//MARK       Specify reuse cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseRow", for: indexPath) as! SetListRow
        
        let setIndex: Int = indexPath.row
        
        cell.titleLabel.text = sets[indexPath.row].title
        //cell.durationLabel.text  = "0"
        cell.dateEditedLabel.text = sets[indexPath.row].dateEditedString()
        cell.numberOfJokesLabel.text = String(sets[indexPath.row].jokes.count)
        cell.durationLabel.text = String(doTimingSum(setIndex: setIndex))
        
        return cell
    }
    
    func doTimingSum(setIndex: Int) -> Int{
        
        let jokeArray: List = sets[setIndex].jokes
        
         var sum = 0
        
       // print("Array Count = \(String(describing: jokeArray?.count))")
        
        for joke in jokeArray{
            
            var duration = joke.duration.value
            
            sum  = (sum + (duration ?? 0))
            
        }
        
        return sum
    }
    
//MARK          Delete on Swipe
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            RealmDB.shared.delete(sets[indexPath.row])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
          
          let destinationVC = segue.destination as! SetController

          if let indexPath = setTable!.indexPathForSelectedRow{
              
              let selectedSet = sets[indexPath.row]
              
            destinationVC.selectedSet = selectedSet

          }
    }
    
}
