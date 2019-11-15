//
//  Tags.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 11/12/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import RealmSwift

class JokeTag: Object{
    
    override static func primaryKey() -> String?{return "jokeTagID"}
    
    @objc dynamic var jokeTagID = UUID().uuidString
    @objc dynamic var tagName: String = ""
    
    convenience  init(tagName: String){
        self.init()
        self.tagName = tagName
        self.jokeTagID = jokeTagID
        
    }
    
 
    
}
    
    
//    func getTags() -> [String]{
//
//        return jokeTags!
//
//    }
//
//    func addTag(_ tagName: String){
//
//        jokeTags?.append(tagName)
//
//    }
//
//    func getAllJokeTags() -> [String]{
//
//        return jokeTags!
//
//    }
//
//    func removeJokeTagByName(_ tagName: String){
//
//        for (index, name) in (jokeTags?.enumerated())! {
//
//            if name == tagName{
//
//                jokeTags!.remove(at: index)
//
//            }
//        }
//
//    }
//
//    func removeJokeTagByIndex(_ index: Int){
//
//
//    }
//}

