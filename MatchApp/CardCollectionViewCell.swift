//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Fernando Borges Paul on 17/12/20.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(card: Card) {
        
        //Keep track of the card this cell represents
        self.card = card
     
        //Set the front image to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        //Reset the state of the cell by checking the flip status of the card and then showing the front or back imageView accordingly
        if card.isMatch == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
       if card.isFlipped == true {
            //Show the front ImageView
        flipUp(speed: 0)
        
        }  else {
            //Show the back ImageView
            flipDown(speed: 0, delay: 0)
            
        }
        
    }
    
    //MARK: - Cards Transition Animations
    
    func flipUp(speed: TimeInterval = 0.3) {
        //Flip Up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        //set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        //Flip Down animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        //set the status of the card
        card?.isFlipped = false
    }
    
    func remove() {
        //Make the image view invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
