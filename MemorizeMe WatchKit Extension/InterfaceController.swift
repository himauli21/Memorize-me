//
//  InterfaceController.swift
//  MemorizeMe WatchKit Extension
//
//  Created by Himauli Patel on 2019-03-14.
//  Copyright © 2019 Himauli Patel. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    var storeName:String?
    
    @IBAction func buttonEnterName() {
        
//        nameLabel.setText(name)
        let suggestedResponses = ["Himauli", "Foram", "Jenelle"]
        
        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain) {
            (results) in
            
            if (results != nil && results!.count > 0) {
                // 2. write your code to process the person's response
                let userResponse = results?.first as? String
                self.nameLabel.setText("Hello \(userResponse!)")
                self.storeName = userResponse
               
                // 3. also save the user's choice
                let sharedPreferences = UserDefaults.standard
                sharedPreferences.set(self.storeName, forKey:"name")
                print("Saved \(self.storeName) to shared preferences!")
            }
        }
        
    }
    
    @IBAction func buttonStartGame() {
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
            nameLabel.setText("Hello \(name!)")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
