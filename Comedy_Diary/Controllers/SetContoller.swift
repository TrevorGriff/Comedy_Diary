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
    
    var minTime: Int = 0
    var maxTime: Int = 0
    
    var theMax: String = "0"
    var theMin: String = "0"
    

    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        setTitleFrame.title = selectedSet!.title
        
        jokeListTable?.dataSource = self as? UITableViewDataSource
        
        jokeListTable?.delegate = self as? UITableViewDelegate
        
        print(realm.configuration.fileURL)
        

    }
    
    @IBAction func SegmentTapped(_ sender: Any) {
        
       let seg = segmentBar.selectedSegmentIndex
        
        switch (seg) {
        case 0:
            print("List All")
            jokes = realm.objects(Joke.self)
            displayFromList = false
            jokeListTable.reloadData()
            
        case 1:
           // print("List Set")
            
            displayFromList = true
            
            jokeListTable.reloadData()
            
        case 2:
            
            
            let predicate = NSPredicate ( format: "duration >= %d && duration <= %d " , minTime, maxTime)
            
            jokes = realm.objects(Joke.self).filter(predicate)
            
            //print("joke.Count after search: \(jokes.count)")
            
            //print("Search results: \(jokes)")'
            getSearchCriteria()
            
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
    
    func getSearchCriteria(){
        
       // let maxField: UITextField = UITextField()
        //let minField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Enter Duration Range" , message: "", preferredStyle: .alert)
        
        alert.addTextField (configurationHandler: { textField  in
            
            textField.placeholder = "Max"
            
        })
        
        alert.addTextField (configurationHandler: { textField  in
            
            textField.placeholder = "Min"
            
        })

        
        let searchAction = UIAlertAction(title: "Search", style: .default){ action in
            
            self.maxTime = Int (alert.textFields![0].text!)!
            
            self.minTime = Int(alert.textFields![1].text!)!
            
            print("\(self.maxTime)  ...\(self.minTime) ")
            
        }
                
        alert.addAction(searchAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){(action) in }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
        
        print("joke.Count: \(jokes.count)")
        
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


