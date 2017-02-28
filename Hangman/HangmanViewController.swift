//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    var numIncorrect : Int = 0
    var image = UIImage(named: "hangman1")
    var phraseToGuess : String = ""
    var numSlots : Int = 0
    
    @IBOutlet weak var hangmanState: UIImageView!
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    @IBOutlet weak var textGuess: UITextField!
    
    @IBAction func guessLetter(_ sender: UIButton) {
        
        let guess : String? = textGuess.text!.uppercased()
        
        if (checkGuess(guess:guess!) == true) {
            update(guess:guess!, phrase:phraseToGuess)
        }
        
        textGuess.text = ""
    }
    
    
    @IBAction func startOver(_ sender: Any) {
        numIncorrect = 0
        image = UIImage(named: "hangman1")
        viewDidLoad()
    }
    
    @IBOutlet weak var blanks: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        hangmanState.image = image
        incorrectGuesses.text = "Incorrect guesses: "
        
        let hangmanPhrases = HangmanPhrases()
        
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        phraseToGuess = phrase
        numSlots = phrase.characters.count
        
        let defaultBlanks: String = getBlanks(phrase: phrase)
        blanks.text = defaultBlanks
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getBlanks(phrase: String) -> String {
        
        var blanks : String
        blanks = ""
        var total : Int
        total = phrase.characters.count
        
        var counter : Int
        counter = 0
        
        while counter < total {
            
            var curr : String
            curr = phrase.substring(atIndex: counter)
            
            if (curr == " ") {
                blanks += "  "
            } else {
                blanks += "_ "
            }
            
            counter += 1;
        }
        
        return blanks
    }
    
    
    func checkGuess(guess: String) -> Bool {

        if guess.isAlphanumeric && guess.characters.count == 1 {
            return true
        } else {
            let alert = UIAlertController(title: "", message: "Please enter a valid single letter as your guess!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return false
        }
    }
    
    
    func update(guess: String, phrase: String) {
        
        if phrase.range(of: guess) != nil {
            var currText : String? = blanks.text
            let indices = phrase.indicesOf(string: guess)
            var arrText : [Character] = Array(currText!.characters)
            numSlots -= indices.count
            print(numSlots)
            for index in indices {
                arrText[index * 2] = Character(guess)
            }
            
            blanks.text = String(arrText)
            
            if numSlots == 1 {
                let alert = UIAlertController(title: "You Made It!", message: "Let's play a new game", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                numIncorrect = 0
                image = UIImage(named: "hangman1")
                viewDidLoad()
            }
        } else {
            
            var currIncorrectGuesses : String? = incorrectGuesses.text
            currIncorrectGuesses! += guess + " "
            incorrectGuesses.text = currIncorrectGuesses
            numIncorrect += 1
            
            if numIncorrect == 6 {
                let alert = UIAlertController(title: "You lose.", message: "Let's play a new game", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                numIncorrect = 0
                image = UIImage(named: "hangman1")
                viewDidLoad()
            }

            image = UIImage(named: "hangman" + String(numIncorrect + 1))
            hangmanState.image = image
        }
    }
    
}
    
    
