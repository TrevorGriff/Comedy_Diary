//
//  JokeController.swift
//  ComedyOrganizer
//
//  Created by Trevor Griffiths on 9/6/19.
//  Copyright © 2019 Trevor Griffiths. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import TagListView

class JokeController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIToolbarDelegate{
   
    @IBOutlet weak var jokeToolBar: UINavigationItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var addJokeButton: UIBarButtonItem!
    @IBOutlet weak var deleteJokeButton: UIBarButtonItem!
    
    @IBOutlet weak var jokeTags: TagListView!
    @IBOutlet weak var masterListOfTags: TagListView!
    
    let realm = try! Realm()
    var tagMasterList: Results<JokeTag>? = nil
    var displayJoke: Joke?
    var tagArray: [JokeTag] = []
    
    var deleteTappedFlg = false
    
    var durationPicker = UIPickerView()
    
    let durationData: [String] = ["00", "01","02","03","04","05","06","07","08","09","10",
        "11","12","13","14","15","16","17","18","19","20",
        "21","22","23","24","25","26","27","28","29","30",
        "31","32","33","34","35","36","37","38","39","40",
        "41","42","43","44","45","46","47","48","49","50",
        "51","52","53","54","55","56","57","58","59","60"]
    
    let durationSecData: [String] = ["00","10","20","30","40","50"]
    
    var minIndex = 1
    var secIndex = 0
    
    @IBAction func upDateDuration(_ sender: Any) {
        
        durationField.inputView = durationPicker
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontSize:CGFloat = 24
        
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        
        let jokeButtonStyle = [NSAttributedString.Key.font: font]
        
        addJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
            
        deleteJokeButton.setTitleTextAttributes(jokeButtonStyle, for: UIControl.State.normal)
        
        self.titleField.delegate = self
        
        self.durationField.delegate = self
        
        masterListOfTags.delegate = self
        
        jokeTags.delegate = self
        
        durationField.inputView = durationPicker
        durationField.delegate = self
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        setDoneButtonOnKeyboards()
        
        doTagFormatting()
        
        bodyView.delegate = self as? UITextViewDelegate
         
        tagArray = RealmDB.shared.getJokeTagsArray(displayJoke!)
        
        //selecttagArray = displayJoke!.tags
        
        updateJokeDisplay()
    }
    func setDoneButtonOnKeyboards(){
        
        let keyboardToolBar = UIToolbar()
            keyboardToolBar.sizeToFit()
        
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
                UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
            let doneButton = UIBarButtonItem(barButtonSystemItem:
                UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked) )
             
            keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        
            durationField.inputAccessoryView = keyboardToolBar
            titleField.inputAccessoryView = keyboardToolBar
            bodyView.inputAccessoryView = keyboardToolBar
        }
    
    @objc func doneClicked() {
        
        view.endEditing(true)
        updateDB()
    }
        
    @IBAction func infoTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "JokeToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: (Any)?){
        
        if segue?.identifier == "JokeToInfo"{
            
            let vc = segue?.destination as! JokeInfoController
            
            vc.displayJoke = displayJoke
        }
        
    }
    
    
    
    @IBAction func editTagsTappped(_ sender: Any) {
        
        performSegue(withIdentifier: "JokeToTags", sender: self)
    }
    
    func updateJokeDisplay(){
        
        titleField.text = displayJoke?.title
        
        bodyView.text = displayJoke?.body
     
        let durationSecs = Int((displayJoke?.durationString())!)
        
        let time: Array = convertToMinAndSec(durationSecs!)

       //let minutes = String(format: "%02d", time[minIndex] )
        
        //let seconds = String(format: "%02d", time[secIndex] )
        
        let displayString: String = makeMinAndSecStr(convertToMinAndSec(durationSecs!))
    
        //print("display \(displayString)")
        
        self.durationPicker.selectRow(time[secIndex],inComponent: 1, animated: false)
        self.durationPicker.selectRow(time[minIndex],inComponent: 0, animated: false)
        
        durationField.text = displayString
        
        reloadInputViews()
        
    }
    
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        
        RealmDB.shared.delete(displayJoke!)
        
        deleteTappedFlg = true
        
         self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        displayJoke = Joke()
        displayJoke?.title = "Type the Title of your joke here"
        displayJoke?.body = "Type the rest of your Joke here"
       
        //print(displayJoke)
        RealmDB.shared.create(displayJoke!)
        
        updateJokeDisplay()
        
    }
     
    
    func updateDB(){
        
        //print("updateDB \(durationField.text)")
        
        let durationInteger = ConvertToInteger(durationField.text!)
        
        let edited = Date()
            
        let dict: [String: Any?] = ["title": titleField.text, "body": bodyView.text, "duration": durationInteger, "dateEdited": edited]
        
        RealmDB.shared.update(displayJoke!, with: dict)
        
    }
    
    func  ConvertToInteger(_ displayStr: String) -> Int{
        
        let index = displayStr.index(displayStr.startIndex, offsetBy: 2)
        
        let mins = String(displayStr[..<index])
       // print(displayStr)
       // print("\(mins) mins")
        let start = displayStr.index(displayStr.startIndex, offsetBy: 7)
        
        let end =   displayStr.index(displayStr.endIndex, offsetBy: -4)
        
        let range = start..<end
        
        let secs = String(displayStr[range])
        
        //print("\(secs) secs")
        return (Int(mins)! * 60) + Int(secs)!
    }
    
    func displayEmptyStringAlert () {
            
            let alert = UIAlertController(title: "The text field cannot be empty", message: "Please type some info.", preferredStyle: .alert)
           
            alert.addAction(UIAlertAction(title: "OK",style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        print("view will dissapear")

        if !deleteTappedFlg {
            
            updateDB()
            
        }else{
            
            deleteTappedFlg = false
        }
        
    }
    
}

extension JokeController: TagListViewDelegate{
    
    func doTagFormatting(){
        
        jokeTags.cornerRadius = 10
        
        masterListOfTags.cornerRadius = 10
        
    }
    
    
    func getThisJokesTags(){
        
        for tag in tagArray{
            
            jokeTags.addTag(tag.tagName)
                        
        }
    }
        
    func getMasterListOfJokes(){
    
        tagMasterList = realm.objects(JokeTag.self)
            
        for tag in tagMasterList!{
            
                masterListOfTags.addTag(tag.tagName)
            
            }
            
        }
        
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {

        //print("tag pressed: \(sender)  == \(masterListOfTags)")
        
        var doNotAdd: Bool = false
        
        if sender == masterListOfTags {
            
            for tag in tagArray{
            
                if (tag.tagName == title) {
                    
                   doNotAdd = true
                
                }
                
            }
            if !doNotAdd {
                          
                // Same object from master list
                
                for tag in tagMasterList! {
                    
                    if (tag.tagName == title) {
                        
                        try! realm.write{
                            
                            jokeTags.addTag(title)
                            
                            displayJoke!.tags.append(tag)
                            
                            doNotAdd = false
                            
                        }

                    }
                    
                }
                
            }
            
        }

    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("remove tag pressed: \(sender)  == \(jokeTags)")
        
        if sender == jokeTags{
            
            for (index, tag) in (displayJoke?.tags.enumerated())! {
            
                if (tag.tagName == title) {
                
                    try! realm.write{
                    
                        displayJoke!.tags.remove(at: index)
                        
                        sender.removeTagView(tagView)

                    }

                }
            
            }
            
        }
    }

    override func viewWillAppear(_ animated: Bool){
        
        masterListOfTags.removeAllTags()
        
        jokeTags.removeAllTags()
        
        getMasterListOfJokes()
        
        getThisJokesTags()
    }
    
    
}
extension JokeController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return durationData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var secs = durationPicker.selectedRow(inComponent: 1).description
        var mins = durationPicker.selectedRow(inComponent: 0).description
        
        print("secs: \(secs) index \(secIndex)  mins: \(mins) index \(minIndex)")
        
        mins = String(format: "%02d",(Int(mins)!))
        secs = String(format: "%02d",(Int(secs)!))
        
        durationField.text = "\(mins) min \(secs) sec"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
}

