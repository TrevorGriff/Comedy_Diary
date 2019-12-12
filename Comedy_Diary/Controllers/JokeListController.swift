//
//  JokeListController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class JokeListController : UIViewController {
    
    @IBOutlet weak var jokeTable: UITableView?
    
    let realm = try! Realm()
     
    lazy var jokes = realm.objects(Joke.self)
    
    var minAndSec: Array<Int> = []
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //  print(realm.configuration.fileURL)
        
        jokeTable?.dataSource = self
        
        jokeTable?.delegate = self
        
        jokeTable?.rowHeight = 40
        
    }
    
    override func viewWillAppear(_ animated: Bool){

        self.jokeTable?.reloadData()
        
    }
    
    
    @IBAction func addNewJokeTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "JokeListToNewJoke", sender: self)
    }
    
}

extension JokeListController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseRow", for: indexPath) as! JokeListRow

        cell.titleFieldView.text = jokes[indexPath.row].title
       
        minAndSec = convertToMinAndSec(jokes[indexPath.row].duration.value!)
        
        cell.durationFieldView.text = makeMinAndSecStr(minAndSec)
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if jokes.count > 0 {
                
                return jokes.count
                
            } else {
                
                let firstJoke = Joke()
                
                firstJoke.title = "Select here to create your first joke"
                firstJoke.body = "Body of Joke"
                
                RealmDB.shared.create(firstJoke)
                
                return jokes.count
            }
        
    }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            performSegue(withIdentifier: "JokeListToJoke", sender: self)

       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            
            print("segue: \( segue.identifier)")
            
//            if segue.identifier == "JokeListToJoke" {
//
//                let destinationVC = segue.destination as! JokeController
//
//                if let indexPath = jokeTable!.indexPathForSelectedRow{
//
//                    let selectedJoke = jokes[indexPath.row]
//
//                    destinationVC.displayJoke = selectedJoke
//                }
//            }
//
//            if segue.identifier == "JokeListToNewJoke" {
//
//                let destinationVC = segue.destination as! JokeController
//                let selectedJoke = Joke()
//                destinationVC.displayJoke = selectedJoke
//            }
//        }
        var selectedJoke: Joke? 
        
        let destinationVC = segue.destination as! JokeController
        
        switch segue.identifier {
            
        case "JokeListToJoke":
            
                 if let indexPath = jokeTable!.indexPathForSelectedRow{
            
                    selectedJoke = jokes[indexPath.row]
               
                }
            
        case "JokeListToNewJoke":
            
             selectedJoke = Joke()
             selectedJoke?.title = "Type the Title of your joke here"
             selectedJoke?.body = "Type the rest of your Joke here"
             RealmDB.shared.create(selectedJoke!)
             
        default:
            
            print(segue.identifier)
            
        }
        
        destinationVC.displayJoke = selectedJoke
    }
        
}

class JokeListRow: UITableViewCell{
    @IBOutlet weak var titleFieldView: UILabel!
    @IBOutlet weak var durationFieldView: UILabel!
}
