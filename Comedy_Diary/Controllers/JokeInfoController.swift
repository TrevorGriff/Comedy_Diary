//
//  JokeInfoController.swift
//  Comedy_Diary
//
//  Created by Trevor Griffiths on 12/9/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import UIKit

class JokeInfoController: UIViewController{
    
    var displayJoke: Joke?
    
    @IBOutlet weak var jokeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jokeLabel.text = displayJoke?.title
        print(displayJoke)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
