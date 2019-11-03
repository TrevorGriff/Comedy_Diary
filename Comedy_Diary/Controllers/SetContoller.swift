//
//  SetContoller.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//


import UIKit
import RealmSwift

class SetController : UIViewController{
    
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var NumOfJokesInSet: UILabel!
    @IBOutlet weak var timingSumField: UILabel!
    @IBOutlet weak var setTitleFrame: UINavigationItem!
    @IBOutlet weak var jokeListTable: UITableView!
    
    private var timingSum: Int = 0
    private var num: Int = 0
    
    var selectedSet: ASet?
    
    private var  activeJoke: Joke?
    
    lazy var  jokeArray = selectedSet?.jokes
    
    let realm = try! Realm()
    
    lazy var jokes = realm.objects(Joke.self)
    
    var displayFromList: Bool = false
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        setTitleFrame.title = selectedSet!.title
        
        jokeListTable?.dataSource = self as? UITableViewDataSource
        
        jokeListTable?.delegate = self as? UITableViewDelegate
        
        //print(realm.configuration.fileURL)
        

    }
    
    @IBAction func SegmentTapped(_ sender: Any) {
        
       let seg = segmentBar.selectedSegmentIndex
        
        switch (seg) {
        case 0:
            print("List All")
            displayFromList = false
            jokeListTable.reloadData()
            
        case 1:
            print("List Set")
            
            displayFromList = true
            
            jokeListTable.reloadData()
            
        case 2:
            print("List time")
            
            displayFromList = false
            
            jokeListTable.reloadData()
            
        case 3:
            print("List searched")
            
            displayFromList = false
            
            jokeListTable.reloadData()
            
        default:
            print ("No selection")
        }
        
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
        print("home")
        dismiss(animated: true, completion: nil)
        
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
        
        print("count \(selectedSet?.jokes.count)" )
        
        num = (selectedSet?.jokes.count)!
        
        NumOfJokesInSet.text = String(num)

        return cell
    }
    
    func  isJokeListedInSet(_ activeJoke: Joke)->Bool{
        
        //print("count : \(jokeArray?.count)")
        
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
        print("Array Count = \(String(describing: jokeArray?.count))")
        
        for joke in jokeArray!{
            
            var duration = joke.duration.value
            
            sum  = (sum + (duration ?? 0))
            
        }
        
        return sum
    }
    
    func appendJokeInSet(_ theJoke: Joke){
        
        //print("add joke")
        
        try! realm.write{
            
            selectedSet?.jokes.append(theJoke)
            timingSumField.text = String (doTimingSum())
        }
        
    }
    
    func removeJokeInSet(_ theJoke: Joke){
        
        print("0 remove joke" )
        
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
    

class JokeListCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}


