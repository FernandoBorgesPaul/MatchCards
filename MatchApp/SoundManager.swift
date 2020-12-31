//
//  SoundManager.swift
//  MatchApp
//
//  Created by Fernando Borges Paul on 28/12/20.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        var soundFileName = ""
        
        switch effect {
        
            case .flip:
                soundFileName = "cardflip"
            case .match:
                soundFileName = "dingcorrect"
            case .nomatch:
                soundFileName = "dingwrong"
            case .shuffle:
                soundFileName = "shuffle"
//          default:
//              soundFileName = ""
        
        }
        //Get the path for the resource
       let bundlePath =  Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        //check if it is not nil
        guard bundlePath != nil else {
            //Couldn't find the file path
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            //create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            //Play the audio effect
            audioPlayer?.play()
            
        }
        catch {
            print("Could't create the audio player")
        }
        
    }
    
}
