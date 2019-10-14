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
    
    var setTitle = ""
    
    let realm = try! Realm()
        
    lazy var jokes = realm.objects(Joke.self)
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        jokeListTable?.dataSource = self as? UITableViewDataSource
        
        jokeListTable?.delegate = self as? UITableViewDelegate
        
        //print(realm.configuration.fileURL)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell =  tableView.dequeueReusableCell(withIdentifier: "jokeTableRow", for: indexPath) as! JokeListCell
        
        cell.titleLabel.text = jokes[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jokes.count
        
    }
}
                
            

class JokeListCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}

