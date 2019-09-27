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
    dynamic var duration = RealmOptional<Int>()
    @objc dynamic var dateCreated: Date?
    @objc dynamic var dateEdited: Date?
    
    let sets = LinkingObjects(fromType: ASet.self, property: "jokes")
    
    convenience  init(title: String, body: String, duration: Int?, dateCreated: NSDate?, dateEdited: Date?){
        self.init()
        self.jokeID = jokeID
        self.title = title
        self.body = body
        self.duration.value = duration
        self.dateCreated = Date()
        self.dateEdited = dateEdited
    }
    
    func durationString() -> String? {
        guard let duration = duration.value else { return "0"}
        return String(duration)
            
    }
    
//    func dateCreatedString() -> String{
//        let myDF = DateFormatter()
//        myDF.dateStyle = .medium
//        let theDate: NSDate = dateCreated!
//        return myDF.string(from: theDate as Date)
//    }

    func dateEditedAsString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        let theDate: NSDate = dateEdited! as NSDate
        return myDF.string(from: theDate as Date)
    }
    
    func dateCreatedAsString() -> String{
        let myDF = DateFormatter()
        myDF.dateStyle = .medium
        return myDF.string(from: dateEdited! as Date)
    }
    
    
}

