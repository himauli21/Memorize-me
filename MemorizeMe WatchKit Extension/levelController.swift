//
//  levelController.swift
//  MemorizeMe WatchKit Extension
//
//  Created by Himauli Patel on 2019-03-14.
//  Copyright © 2019 Himauli Patel. All rights reserved.
//

import WatchKit
import Foundation

class levelController: WKInterfaceController {

    @IBOutlet weak var levelLabel: WKInterfaceLabel!
    var storeLevel:String?
    
    @IBOutlet weak var btnEasy: WKInterfaceButton!
    @IBOutlet weak var btnHard: WKInterfaceButton!
    
    @IBOutlet weak var levelSelected: WKInterfaceLabel!
    @IBAction func buttonEasy() {
        
//        var storeLevel = "Easy"
//        let sharedPreferences = UserDefaults.standard
//        sharedPreferences.set(self.storeLevel, forKey:"level")
//        print("Saved \(self.storeLevel) to shared preferences!")
        
        
        
    }
    @IBAction func chooseLevel() {
        
        let suggestedResponses = ["Easy", "Hard"]
        
        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain) {
            (results) in
            
            if (results != nil && results!.count > 0) {
                // 2. write your code to process the person's response
                let userResponse = results?.first as? String
                //                self.nameLabel.setText("Hello \(userResponse!)")
                self.storeLevel = userResponse
                
                // 3. also save the user's choice
                let sharedPreferences = UserDefaults.standard
                sharedPreferences.set(self.storeLevel, forKey:"level")
                self.levelSelected.setText(userResponse)
                print("Saved \(self.storeLevel) to shared preferences!")
            }
        }
    }
    @IBAction func buttonHard() {
        
        var storeLevel = "Hard"
        let sharedPreferences = UserDefaults.standard
        sharedPreferences.set(self.storeLevel, forKey:"level")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let sharedPreferences = UserDefaults.standard
        var name = sharedPreferences.string(forKey: "name")
        
        if (name == nil) {
            // by default, the strating city is Vancouver
            name = "Name"
            print("Enter your name")
        }
        else {
            print("Name: \(name)")
            levelLabel.setText("Hello \(name!)")
        }
    }
}
