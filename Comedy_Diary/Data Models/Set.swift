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
    @objc dynamic var dateCreated: NSDate? =  NSDate()
    @objc dynamic var dateEdited: NSDate? = Date() as NSDate
    let jokes = List<Joke>()
    
    //let jokes = LinkingObjects(fromType: Joke.self, property: "jokes")
    
    convenience init(title: String, dateCreated: NSDate?, dateEdited: Date?){
        self.init()
        self.setID = setID
        self.title = title
        self.dateCreated  = dateCreated
        self.dateEdited = dateCreated
        
    }
    
    func dateCreatedString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        myDF.dateFormat = "MM/dd/yyyy"
        let theDate: NSDate = dateCreated! as NSDate
        return myDF.string(from: (theDate as NSDate) as Date)
    }
    
    func dateEditedString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        myDF.dateFormat = "MM/dd/yyyy"
        let theDate: NSDate = dateEdited! as NSDate
        return myDF.string(from: (theDate as NSDate) as Date)
    }
    
    
}

