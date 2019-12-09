//
//  JokeUtilities.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 12/8/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
 
// Takes a number of integer seconds and converts  to \\
//  an integer array of minutes [1] and seconds [0]   \\
//                                                    \\
// Used by the JokeController and JokeListController  \\
//

    func convertToMinAndSec(_ durationInSecs: Int) -> Array<Int>{
        var minutes = 0
        var seconds = 0
        var minAndSec: [Int] = []
        let minsIndex = 1
        let secsIndex = 0
        
       if durationInSecs >= 60 {
            
            minutes = durationInSecs/60
           
            seconds = durationInSecs % (minutes*60)
           
        
       }else{
        
            minutes = 0
        
            seconds = durationInSecs
        
        }
        
        minAndSec.insert(seconds, at: secsIndex)
        
        minAndSec.insert(minutes, at: minsIndex)
        
        return minAndSec
        
}
       
//  Returns a string out of an integer array of minutes[1] and seconds [0]
//      String is "MM mins SS sec"
//      Used by the jokeController and JokeList Controler
//
func makeMinAndSecStr(_  minAndSec: Array<Int>) -> String{
    let minsIndex = 1
    let secsIndex = 0
    var displayString = ""
    
    displayString = ("\(String(format: "%02d", minAndSec[minsIndex])) min \(String(format: "%02d", minAndSec[secsIndex] )) sec")

    return displayString
        
}

