//
//  GameController.swift
//  MemorizeMe WatchKit Extension
//
//  Created by Himauli Patel on 2019-03-14.
//  Copyright © 2019 Himauli Patel. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class GameController: WKInterfaceController {
    
     let sharedPreferences = UserDefaults.standard

    @IBOutlet weak var level: WKInterfaceLabel!
    
    var audioPlayer = AVAudioPlayer()
    var bombSoundEffect: AVAudioPlayer?
    
    var isWatching = true {
        didSet {
            if isWatching {
                setTitle("Observe Dots •")
            } else {
                setTitle("REPEAT!")
            }
        }
    }
    
    var sequence = [WKInterfaceButton]()
    var sequenceIndex = 0
    
    @IBOutlet weak var catButton: WKInterfaceButton!
    @IBOutlet weak var deerButton: WKInterfaceButton!
    @IBOutlet weak var dogButton: WKInterfaceButton!
    @IBOutlet weak var tigerButton: WKInterfaceButton!
    @IBOutlet weak var lionButton: WKInterfaceButton!
    
    @IBAction func catButtonTapped() {
        tapAnimal(catButton)
    }
    @IBAction func deerButtonTapped() {
        tapAnimal(deerButton)
    }
    @IBAction func dogButtonTapped() {
        tapAnimal(dogButton)
    }
    @IBAction func tigerButtonTapped() {
        tapAnimal(tigerButton)
    }
    @IBAction func lionbuttontapped() {
        tapAnimal(lionButton)
    }
    
    func playNext() {
        // stop flashing if we've finished our sequence
        guard sequenceIndex < sequence.count else {
            isWatching = false
            sequenceIndex = 0
            return
        }
        
        // otherwise move our sequence forward
        let button = sequence[sequenceIndex]
        sequenceIndex += 1
        
        // wait a fraction of a second before flashing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            // mark this button as being active
            button.setTitle("•")
            
            let sound = Bundle.main.path(forResource: "buttonClick", ofType: "mp3")
            do
            {
                self!.bombSoundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                self!.bombSoundEffect?.play()
                
            }
            catch{
                print(error)
            }
            
            // wait again
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // deactivate the button and flash again
                button.setTitle("")
                self?.playNext()
            }
        }
    }
    
    func addToSequence() {
        // add a random button to our sequence
        let animals: [WKInterfaceButton] = [catButton, deerButton, dogButton, lionButton, tigerButton]
    
        var levelSelected = sharedPreferences.string(forKey: "level")
        if (levelSelected == nil) {
            guard isWatching == false else { return }
        }
        if (levelSelected == "Easy")
        {
            // code for easy level
            print("Easy level!!!")
            for _ in 1...2 {
                
                sequence.append(animals.randomElement()!)
            }
            
            // start the flashing at the beginning
            sequenceIndex = 0
            
            // update the player instructions
            isWatching = true
            
            // give the player a little respite, then start flashing
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                self.playNext()
            }
        }
        else
        {
            // code for hard level
            print("Hard level Started")
            for _ in 1...3 {
                
                sequence.append(animals.randomElement()!)
            }
            
            // start the flashing at the beginning
            sequenceIndex = 0
            
            // update the player instructions
            isWatching = true
            
            // give the player a little respite, then start flashing
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                self.playNext()
            }
        }
    }
    
    func startNewGame() {
        sequence.removeAll()
        addToSequence()
    }
    
    func tapAnimal(_ animal: WKInterfaceButton) {
        // don't let the player touch stuff while in watch mode
        
        guard isWatching == false else { return }
        
        if sequence[sequenceIndex] == animal {
            // they were correct! Increment the sequence index.
            let sound = Bundle.main.path(forResource: "buttonClick", ofType: "mp3")
            do
            {
                bombSoundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                bombSoundEffect?.play()
                
            }
            catch{
                print(error)
            }
            sequenceIndex += 1
            
            if sequenceIndex == sequence.count {
                // they made it to the end; add another button to the sequence
                addToSequence()
            }
        } else {
            // they were wrong! End the game.
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.startNewGame()
            }
            
            presentAlert(withTitle: "Game over!", message: "You scored \(sequence.count - 1).", preferredStyle: .alert, actions: [playAgain])
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        startNewGame()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        var levelSelected = sharedPreferences.string(forKey: "level")
        level.setText(levelSelected)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
