//
//  RealmSwift.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/24/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//


import Foundation
import UIKit
import RealmSwift

class RealmDB{
    
    private init(){}
    
    static let shared = RealmDB()
    
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T){
        
    print(object)
        do{
            try realm.write{
                realm.add(object)
            }
        }catch{
            post(error)
        }
    }
    

    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        
        print(object)
        do{
            try realm.write {
                for (key, value) in dictionary{
                    object.setValue(value, forKey: key)
                }
            }
        }catch{
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.delete(object)
            }
        }catch{
            post(error)
        }
    }
    
    func post(_ error: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping(Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) {(notification) in completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}


