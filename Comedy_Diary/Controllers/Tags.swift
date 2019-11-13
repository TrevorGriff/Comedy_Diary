//
//  Tags.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 11/12/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation

class Tags{
    
    static var shared = Tags()
    
   var jokeTags: [String]?
    
    private init(){
    
    jokeTags = ["PG", "X Rated, Political"]
    
    }
    
    func getTags() -> [String]{
        
        return jokeTags!
    }
    
    func addTag(_ tagName: String){
        
        jokeTags?.append(tagName)
    }
    
    func getAllJokeTags() -> [String]{
        
        return jokeTags!
        
    }
    
    func removeJokeTagByName(_ tagName: String){
        
        for (index, name) in (jokeTags?.enumerated())! {
            
            if name == tagName{
                
                jokeTags!.remove(at: index)
                
            }
        }
        
    }
    
    func removeJokeTagByIndex(_ index: Int){
        
        
    }
    
}
