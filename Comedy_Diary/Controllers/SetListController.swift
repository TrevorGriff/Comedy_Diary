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
    
    
    
}

class SetListController : UIViewController {

    @IBOutlet weak var setTable: UITableView!
    
    let realm = try! Realm()
    
    lazy var sets = realm.objects(ASet.self)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setTable?.delegate = self as! UITableViewDelegate
        
        setTable?.dataSource = self as! UITableViewDataSource
        
        loadSets()
        
    }
    
    func loadSets(){
        
        sets = realm.objects(ASet.self)
        
        setTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        self.setTable?.reloadData()
        
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}


extension SetListController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return sets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseRow", for: indexPath) as! SetListRow
        
        
        
        return cell
    }
    
    
}
