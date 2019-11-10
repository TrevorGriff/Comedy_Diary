//
//  Joke.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/24/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import RealmSwift

class Joke: Object {
    
    override static func primaryKey() -> String?{
        return "jokeID"
    }
    
    @objc dynamic var jokeID = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    var duration = RealmOptional<Int>()
    @objc dynamic var dateCreated: NSDate? = NSDate()
    @objc dynamic var dateEdited: NSDate? = Date() as NSDate
    let tags = List<String>()
    
    let sets = LinkingObjects(fromType: ASet.self, property: "jokes")
    
    convenience  init(title: String, body: String, duration: Int?, dateCreated: NSDate?, dateEdited: Date?){
        self.init()
        self.jokeID = jokeID
        self.title = title
        self.body = body
        self.duration.value = 0
        self.dateCreated = dateCreated
        self.dateEdited = dateCreated
    }
    
    func durationString() -> String? {
        guard let duration = duration.value else { return "0"}
        return String(duration)
            
    }
    
    func dateEditedAsString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        myDF.dateFormat = "MM/dd/yyyy"
       let theDate: NSDate = dateEdited! as NSDate
        return myDF.string(from: (theDate as NSDate) as Date)
    }
    
    func dateCreatedAsString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        myDF.dateFormat = "MM/dd/yy"
        let theDate: NSDate = dateCreated! as NSDate
        return myDF.string(from: (theDate as NSDate) as Date)
    }
    
    func CountOflinksToSetsAsString() -> String{
        
        let count: Int = sets.count
        return String(count)
    }
}

