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
    

    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        jokeTable?.dataSource = self
        
        jokeTable?.delegate = self
        
        print(realm.configuration.fileURL)
        
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
        
    }
    
}

extension JokeListController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)

        let text = jokes[indexPath.row].title
        
        //cell.t = text
        cell.textLabel!.text = text
            
        return cell
        
        
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

           return jokes.count
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

           //print(jokes[indexPath.row])

          // tableView.reloadData()

           //tableView.deselectRow(at: indexPath, animated: true)

            performSegue(withIdentifier: "jokeListToJoke", sender: self)

       }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            
            let destinationVC = segue.destination as! JokeController

            if let indexPath = jokeTable!.indexPathForSelectedRow{
                
               // print(destinationVC.selectedJoke as Any)
                
                let selectedJoke = jokes[indexPath.row]
                
                destinationVC.displayJoke = selectedJoke

            }
      }
    
}
