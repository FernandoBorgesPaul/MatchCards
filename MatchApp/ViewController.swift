//
//  ViewController.swift
//  MatchApp
//
//  Created by Fernando Borges Paul on 17/12/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer: Timer?
    var milliseconds:Int = 60 * 1000
    
    var firstFlippedCardIndex: IndexPath?
    
    var soundPlayer = SoundManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsArray = model.getCards()
        
        //Setting the viewController as the delegate and data source of the collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        //The timer stops when scrolling, RunLoop helps to avoid this
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Play suffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    @objc func timerFired() {
        //Decrement counter
        milliseconds -= 1
        
        //Update label
        let seconds: Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        //Stop the timer and change the colour of the text to red
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //Check if the user has cleared all the pairs
            checkForGameEnd()
            
        }
             
    }
    
    
    //MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the cards from the cardArray
        let card = cardsArray[indexPath.row]
        
        //Finish configurin the cell
        cell.configureCell(card: card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Chyeck if there is any time remaining. Don't let the user interact if time is 0
        if milliseconds <= 0 {
            return
        }
        
        //get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatch == false {
            //Flip the card up
            cell?.flipUp()
            //Play sound
            soundPlayer.playSound(effect: .flip)
            
            //Check if this is the first card was flipped or the second one
            if firstFlippedCardIndex == nil {
                
                //This is the first card flipped over
                firstFlippedCardIndex = indexPath
                
            } else {
                //This is the second card
                //Second card was flipped
                
                //Run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)  {
        //Configure the state of the cell based on the properties of the card that is presented.
        let cardCell = cell as? CardCollectionViewCell
        //Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        //finish configuring the cell
        cardCell?.configureCell(card: card)
        
        
    }
    
    //MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        //get the 2 card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //get the 2 collections view cells that represents card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            //it is a match
            //Play match sound
            soundPlayer.playSound(effect: .match)
            
            //set the status and remove the item
            cardOne.isMatch = true
            cardTwo.isMatch = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
             
            
        } else {
            //It is not a match
            //Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            //flip the cards back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
            //Was the last pair?
            checkForGameEnd()
            
        }
        
        //Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        //Check if thre is any card unmatched
        //Assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatch == false {
               //We've found a card taht is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            
            //user has won, show alert
            showAlert(title: "Congratulations", message: "You've won the game!!")
            
        } else {
            //user hasn't won yet, check if there is time left
            if milliseconds <= 0 {
                showAlert(title: "Time's up!", message: "Sorry, better luck next time!")
            }
        }

    }
    
    func showAlert(title: String, message: String) {
        //Creates the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //Add a button for the user to dismiss it
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        //show the alert
        present(alert, animated: true, completion: nil)
        
    }
    
}

