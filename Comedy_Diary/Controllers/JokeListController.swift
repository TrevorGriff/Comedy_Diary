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
        
        //  print(realm.configuration.fileURL)
        
        jokeTable?.dataSource = self
        
        jokeTable?.delegate = self
        
        jokeTable?.rowHeight = 40
        
       // print(realm.configuration.fileURL)
        
    }
    
    override func viewWillAppear(_ animated: Bool){

        self.jokeTable?.reloadData()
        
    }
    
    
}

extension JokeListController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseRow", for: indexPath) as! JokeListRow

        cell.titleFieldView.text = jokes[indexPath.row].title
        
        cell.durationFieldView.text = jokes[indexPath.row].durationString()
        
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

class JokeListRow: UITableViewCell{

    @IBOutlet weak var titleFieldView: UILabel!
    @IBOutlet weak var durationFieldView: UILabel!
}
