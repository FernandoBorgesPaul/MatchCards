//
//  CardModel.swift
//  MatchApp
//
//  Created by Fernando Borges Paul on 17/12/20.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        //Declare an empyt array to store the number of cards that we've generated
        var generatedNumbers = [Int]()
        
        //Declare an empty array
        var generatedCards = [Card]()
        
        //Ramdonly generate the 8 pairs of cards
        while generatedNumbers.count < 8 {
            //Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                //create new card objects
                let cardOne = Card()
                let cardTwo = Card()
                //set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                //add them to the array
                generatedCards += [cardOne, cardTwo]
                
                //add this number to the list of generetaed numbers
                generatedNumbers.append(randomNumber)
                
                print(randomNumber)
            }
  
        }
        
        //Randomize the cards within the array
        generatedCards.shuffle()
        
        //return the array
        return generatedCards
    }
    
}
