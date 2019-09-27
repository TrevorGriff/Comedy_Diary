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

class JokeListController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //tableView.delgate = self
    
    let realm = try! Realm()
        
    @IBOutlet var jokeList: UITableView!
    
    lazy var jokes = realm.objects(Joke.self)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier")!
        
        let text = jokes[indexPath.row].title
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(jokes[indexPath.row])
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        performSegue(withIdentifier: "goToItems", sender: self)
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//
//        let destinationVC = segue.destination as! JokeController
//
//        if let indexPath = tableView.indexPathForSelectedRow{
//
//            destinationVC.selectedCategory = jokes?[indexPath.row]
//
//        }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        jokeList.dataSource = self
        jokeList.delegate = self
        
        //print(realm.configuration.fileURL)
        
        loadJokes()
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
        
    }
    
    
    func loadJokes(){
        
        let results = realm.objects(Joke.self)
        
        //reloadJokes()
        
    }
    
}
