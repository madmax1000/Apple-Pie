//
//  ViewController.swift
//  Apple Pie
//
//  Created by M.D. Bijkerk on 20-04-18.
//  Copyright © 2018 M.D. Bijkerk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var treeImageView: UIImageView!

    @IBOutlet weak var correctWordLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet var letterButtons: [UIButton]!
    
    // declare the list of words to guess
    var listOfWords = ["tennis", "surfing", "dancing", "running", "biking", "climbing"]
    
    // declare the maximum number of incorrect moves allowed
    let incorrectMovesAllowed = 7
    
    // start a new round if total wins and total losses are set
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }

    // declare currentGame, an instance of Game
    var currentGame: Game!
    
    // define what happens when one of the buttons is pressed
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    // determine if a game is won, lost, or if the player should continue playing
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        }
        else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        }
        else {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newRound()
    }
    
    // declare a function newRound, called on each new round
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        }
        // enable all letters again
        else {
            enableLetterButtons(false)
        }
    }
    
    // update the UI
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
        
        // add spaces
        let wordWithSpacing = letters.joined(separator: " ")
        
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    // enable all letters again after calling in newRound()
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
