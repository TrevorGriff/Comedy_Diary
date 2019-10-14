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
    
    
    @IBOutlet weak var jokeListTable: UITableView!
    
    
    let realm = try! Realm()
        
    lazy var jokes = realm.objects(Joke.self)
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        jokeListTable?.dataSource //= self as! UITableViewDataSource
        
        jokeListTable?.delegate //= self as! UITableViewDelegate
        
        //print(realm.configuration.fileURL)
        
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        
        print("home")
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool){

        self.jokeListTable?.reloadData()
        
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseRow1", for: indexPath)

//        cell.titleL  = jokes[indexPath.row].title
//            
//        cell.durationLabel.text = jokes[indexPath.row].durationString()
//            
            return cell
            
            
    }
        
        
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

               return jokes.count
           }

//           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//                performSegue(withIdentifier: "jokeListToJoke", sender: self)
//
//           }
//        
//            override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//                
//                let destinationVC = segue.destination as! JokeController
//
//                if let indexPath = jokeTable!.indexPathForSelectedRow{
//                    
//                   // print(destinationVC.selectedJoke as Any)
//                    
//                    let selectedJoke = jokes[indexPath.row]
//                    
//                    destinationVC.displayJoke = selectedJoke
//
//                }
//          }
//
//    }
    
    
}

