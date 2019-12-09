//
//  SetContoller.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//


import UIKit
import RealmSwift
import TagListView
import SwiftReorder

class SetController : UIViewController {
    
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var NumOfJokesInSet: UILabel!
    @IBOutlet weak var timingSumField: UILabel!
    @IBOutlet weak var jokeListTable: UITableView!
    @IBOutlet weak var masterTagField: TagListView!
    @IBOutlet weak var setTitleField: UITextField!
    
    
    private var timingSum: Int = 0
    
    private var num: Int = 0
    
    var selectedSet: ASet?
    
    private var  activeJoke: Joke?
    
    lazy var  jokeArray = selectedSet?.jokes
    
    let realm = try! Realm()
    
    lazy var jokes = realm.objects(Joke.self)
    
    var displayFromList: Bool = false
    
    var times: Array<Int> = [0,0]
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
       setTitleField.text = selectedSet!.title
        
        jokeListTable?.dataSource = self as? UITableViewDataSource
        
        jokeListTable?.delegate = self as? UITableViewDelegate
        
        setTitleField?.delegate = self as UITextFieldDelegate
        
        jokeListTable.reorder.delegate = self as! TableViewReorderDelegate
        
        //print(realm.configuration.fileURL)

    }
    
    @IBAction func SegmentTapped(_ sender: Any) {
        
       let seg = segmentBar.selectedSegmentIndex
        
        switch (seg) {
            
        case 0:
            
            jokes = realm.objects(Joke.self)
            
            displayFromList = false
            
            jokeListTable.reloadData()
            
        case 1:
            
            displayFromList = true
            
            jokeListTable.reloadData()
            
        case 2:
            
            doSearchOnDuration()
            
            displayFromList = false
            
            jokeListTable.reloadData()
            
        case 3:
            
             doSearchOnTags()
             
            displayFromList = false
            
            jokeListTable.reloadData()
            
        default:
            
            print ("No selection")
            
        }
        
    }
    
    func doSearchOnTags(){
        
        
//        let tagList = ["A","B"]
        
//         jokes = realm.objects(Joke.self)
//
//        let filteredArray = Array(jokes!).filter({Array($0.tags).map({$0.tagName}).sorted().joined().contains(jokes.sorted().joined())})
        
        
    }
    
    
    func doSearchOnDuration(){
        
        let alert = UIAlertController(title: "Enter Duration Range" , message: "", preferredStyle: .alert)
        
        alert.addTextField (configurationHandler: { textField  in
            
            textField.placeholder = "Max"
            
        })
        
        alert.addTextField (configurationHandler: { textField  in
            
            textField.placeholder = "Min"
            
        })

        
        let searchAction = UIAlertAction(title: "Search", style: .default){ action in
            
            self.times[0] = Int (alert.textFields![0].text!)!

            self.times[1] = Int(alert.textFields![1].text!)!
            
            let predicate = NSPredicate ( format: "duration >= %d && duration <= %d " , self.times[0], self.times[1])
                      
            self.jokes = self.realm.objects(Joke.self).filter(predicate)
            
            self.jokeListTable.reloadData()
            
        }
                
        alert.addAction(searchAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){(action) in }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool){

        self.jokeListTable?.reloadData()
        
    }
    
    
}

extension SetController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !displayFromList {
            
            return jokes.count
            
        }else{
            
            return jokeArray!.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell =  tableView.dequeueReusableCell(withIdentifier: "jokeTableRow", for: indexPath) as! JokeListCell
        
        if !displayFromList {
            
            if let spacer = tableView.reorder.spacerCell(for: indexPath) {
                return spacer
            }
                
            activeJoke = jokes[indexPath.row]
            
        }else{
            
            activeJoke = jokeArray![indexPath.row]
            
        }
        
        cell.titleLabel.text = activeJoke!.title
        
        cell.durationLabel.text = activeJoke!.durationString()
        
        if isJokeListedInSet(activeJoke!){
            
            cell.accessoryType = .checkmark
            
        }else{
            
            cell.accessoryType = .none
            
        }
        
       timingSumField.text = String(doTimingSum())
        
        num = (selectedSet?.jokes.count)!
        
        NumOfJokesInSet.text = String(num)

        return cell
    }
    
    func  isJokeListedInSet(_ activeJoke: Joke)->Bool{
        
        for (index, joke ) in (jokeArray?.enumerated())! {

            if activeJoke.jokeID == joke.jokeID{
                
                return true
            }
            
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        let selectedJoke = jokes[indexPath.row]
        
        if cell.accessoryType == .none{
                       
                        cell.accessoryType = .checkmark
            
                        appendJokeInSet(selectedJoke)
        
                    }else{
                
                        cell.accessoryType = .none
            
                        removeJokeInSet(selectedJoke)
        
                    }
    }
    

    
    func doTimingSum() -> Int{
        
         var sum = 0
        
        for joke in jokeArray!{
            
            let duration = joke.duration.value
            
            sum  = (sum + (duration ?? 0))
            
        }
        
        return sum
    }
    
    func appendJokeInSet(_ theJoke: Joke){
        
        try! realm.write{
            
            selectedSet?.jokes.append(theJoke)
            
            timingSumField.text = String (doTimingSum())
            
        }
        
    }
    
    func removeJokeInSet(_ theJoke: Joke){
        
        let jokeArray = selectedSet?.jokes
        
        for (index, joke ) in (jokeArray?.enumerated())! {

            if theJoke.jokeID == joke.jokeID{
                
                try! realm.write{
                    
                    selectedSet?.jokes.remove(at: (index))
                    
                    timingSumField.text = String (doTimingSum())
                    
                }
                break
            }
            
        }
        
    }
    
}

extension SetController: TagListViewDelegate{
        
}

extension SetController: UITextFieldDelegate{
 
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{

        if ((textField.text ?? "").isEmpty){

            displayEmptyStringAlert()

        }else{

            updateDBValues()

            textField.resignFirstResponder()

            return false

        }

        return true
    }

    func displayEmptyStringAlert(){

        let alert = UIAlertController(title: "Text field cannot be empty", message: "Please type some info.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }

    func updateDBValues(){

        let edited = Date()

        let dict: [String: Any?] = ["title": setTitleField.text, "dateEdited": edited]

        RealmDB.shared.update(selectedSet!, with: dict)

    }

}

extension SetController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let  jokeToMove = jokeArray![sourceIndexPath.row]
        
        try! realm.write{
            
            jokeArray?.remove(at: sourceIndexPath.row)
            jokeArray?.insert(jokeToMove, at: destinationIndexPath.row)
        }
        // Update data model
    }
}

class JokeListCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}


