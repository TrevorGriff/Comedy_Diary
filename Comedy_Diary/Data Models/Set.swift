//
//  Set.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/24/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import RealmSwift

class ASet: Object{
    
       override static func primaryKey() -> String?{return "setID"}
    
    @objc dynamic var setID = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: NSDate?
    @objc dynamic var dateEdited: Date?
    let jokes = List<Joke>()
    
    //let jokes = LinkingObjects(fromType: Joke.self, property: "jokes")
    
    convenience init(title: String, dateCreated: Date?, dateEdited: Date?){
        self.init()
        self.setID = setID
        self.title = title
        self.dateCreated = NSDate()
        self.dateEdited = dateEdited
        
    }
    
    func dateCreatedString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        let theDate: NSDate = dateCreated!
        return myDF.string(from: theDate as Date)
    }
    
    func dateEditedString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        let theDate: NSDate = dateEdited! as NSDate
        return myDF.string(from: theDate as Date)
    }
    
    
}

