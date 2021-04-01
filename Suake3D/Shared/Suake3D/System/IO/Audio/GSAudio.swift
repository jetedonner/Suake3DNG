//
//  GSAudio.swift
//  iSuake3DNG
//
//  Created by dave on 24.02.18.
//  Copyright © 2018 dave. All rights reserved.
//

import Foundation
import AVFoundation
import AppKit

class GSAudio: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = GSAudio()
    public var volume:CGFloat = 0.08
    
    private override init() {}
    
    var players = [URL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    func playSound (soundFileName: String){
        self.playSound(soundFileName: soundFileName, volume: self.volume)
    }
    
    func playSound(soundFileName: String, volume: CGFloat){
        
        guard let path = Bundle.main.path(forResource: "art.scnassets/sound/" + soundFileName, ofType: "mp3") else {
            return
        }
        
        let soundFileNameURL = URL(fileURLWithPath: path)
        
        if let player = players[soundFileNameURL] {
            player.volume = Float(volume) //self.volume
            if player.isPlaying == false {
                player.prepareToPlay()
                player.play()
                
            } else {
                
                let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                duplicatePlayer.volume = Float(volume) //self.volume
                
                duplicatePlayer.delegate = self
                duplicatePlayers.append(duplicatePlayer)
                
                duplicatePlayer.prepareToPlay()
                duplicatePlayer.play()
                
            }
        } else {
            do{
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                player.volume = Float(volume) //self.volume
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch {
//                print("Could not play sound file!")
            }
        }
    }
    
    
    func playSounds(soundFileNames: [String]){
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func playSounds(soundFileNames: String...){
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func playSounds(soundFileNames: [String], withDelay: Double) {
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay*Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification), userInfo: ["fileName":soundFileName], repeats: false)
        }
    }
    
    @objc func playSoundNotification(notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        duplicatePlayers.remove(at: duplicatePlayers.firstIndex(of: player)!)
    }
}
