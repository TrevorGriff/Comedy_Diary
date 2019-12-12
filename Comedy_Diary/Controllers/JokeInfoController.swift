//
//  JokeInfoController.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 12/9/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//
import Foundation
import UIKit
import TagListView

class JokeInfoController: UIViewController, TagListViewDelegate{
    
    var displayJoke: Joke?
    
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var lastEditedField: UILabel!
    @IBOutlet weak var dateCreatedField: UILabel!
    @IBOutlet weak var durationField: UILabel!
    @IBOutlet weak var setsField: UILabel!
    @IBOutlet weak var wordCountField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jokeLabel.text = displayJoke?.title

        lastEditedField.text = displayJoke?.dateEditedAsString()
        
        dateCreatedField.text = displayJoke?.dateCreatedAsString()
        let duration = displayJoke?.sets.count
        setsField.text = String(duration!)
        
        let durationSecs = Int((displayJoke?.durationString())!)
        let displayString: String = makeMinAndSecStr(convertToMinAndSec(durationSecs!))
        durationField.text = displayString
        
        let jokeString = displayJoke?.body
        let words = jokeString?.components(separatedBy: .whitespacesAndNewlines)
        let filteredWords = words?.filter({ (word) -> Bool in
           word != ""
        })
        wordCountField.text = String(filteredWords!.count)
        
        
      
    }
    


}
