//
//  UserDefaultsHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class UserDefaultsHelper:SuakeGameClass{
    
    let defaults = UserDefaults.standard
    
    var devMode:Bool = true
    var soundEffects:Bool = true
    var matchDuration:MatchDuration = .Minute_1
    var levelSize:LevelSize = .Small
    var difficulty:LevelDifficulty = .Medium
    var lightIntensity:LightIntensity = .normal
    var showArrows:Bool = true
    var volume:CGFloat = 0.5
    
    var showCountdown:Bool = true
    var loadWeaponPickups:Bool = true
    var loadOpp:Bool = false
    var testOppAI:Bool = false
    
    
    var loadDroids:Bool = false
    var droidCount:Int = 1
    var droidsAttackOwn:Bool = false
    var droidsAttackOpp:Bool = false
    var droidsChaseDist:CGFloat = 5.0
    var droidsAttackDist:CGFloat = 2.0
    
    
    
    
    
    override init(game: GameController) {
        super.init(game: game)
        
        self.setDefaultDefaults()
        self.loadValuesFromUserDefaults()
    }
    
    func setDefaultDefaults(){
        self.defaults.register(defaults: [
            "DevMode": true,
            "SoundEffects": true,
            "MatchDuration": MatchDuration.Minute_1.rawValue,
            "GameboardSize": LevelSize.Small.rawValue,
            "Difficulty": LevelDifficulty.Medium.rawValue,
            "LightIntensity": LightIntensity.normal.rawValue,
            "ShowArrows": SuakeVars.showArrows,
            "Volume": SuakeVars.volume,
            "LoadWeaponPickups": SuakeVars.loadWeaponPickups,
            "LoadOpp": SuakeVars.loadOpp,
            "TestOppAI": SuakeVars.testOppAI,
            
            "LoadDroids": SuakeVars.loadDroids,
            "DroidsCount": SuakeVars.droidsCount,
            "DroidsAttackOwn": SuakeVars.droidsAttackOwn,
            "DroidsAttackOpp": SuakeVars.droidsAttackOpp,
            "DroidsChaseDist": SuakeVars.droidsChaseDist,
            "DroidsAttackDist": SuakeVars.droidsAttackDist,
            "ShowCountdown": SuakeVars.showCountdown
            
        ])
    }
    
    func loadValuesFromUserDefaults(){
        self.devMode = self.defaults.bool(forKey: "DevMode")
        self.soundEffects = self.defaults.bool(forKey: "SoundEffects")
        self.loadWeaponPickups = self.defaults.bool(forKey: "LoadWeaponPickups")
        self.loadOpp = self.defaults.bool(forKey: "LoadOpp")
        self.testOppAI = self.defaults.bool(forKey: "TestOppAI")
        self.loadDroids = self.defaults.bool(forKey: "LoadDroids")
        self.droidCount = self.defaults.integer(forKey: "DroidsCount")
        self.droidsAttackOwn = self.defaults.bool(forKey: "DroidsAttackOwn")
        self.droidsAttackOpp = self.defaults.bool(forKey: "DroidsAttackOpp")
        
        self.droidsChaseDist = CGFloat(self.defaults.float(forKey: "DroidsChaseDist"))
        self.droidsAttackDist = CGFloat(self.defaults.float(forKey: "DroidsAttackDist"))
        self.showCountdown = self.defaults.bool(forKey: "ShowCountdown")
        
        self.matchDuration = MatchDuration.matchDuration(fromString: self.defaults.string(forKey: "MatchDuration")!)
        self.levelSize = LevelSize.levelSize(fromString: self.defaults.string(forKey: "GameboardSize")!)
        self.difficulty = LevelDifficulty.levelDifficulty(fromString: self.defaults.string(forKey: "Difficulty")!)
        self.lightIntensity = LightIntensity.lightIntensity(from: self.defaults.string(forKey: "LightIntensity")!)
        self.showArrows = self.defaults.bool(forKey: "ShowArrows")
        self.volume = CGFloat(self.defaults.float(forKey: "Volume"))
    }

    func resetUserDefaults2Game(){
        self.game.levelManager.currentLevel.levelConfigEnv.duration = self.matchDuration
        self.game.levelManager.currentLevel.levelConfigEnv.levelSize = self.levelSize
        self.game.levelManager.currentLevel.levelConfigEnv.levelDifficulty = self.difficulty
        self.game.levelManager.currentLevel.levelConfig.loadWeaponPickups = self.loadWeaponPickups
        
        self.game.levelManager.currentLevel.levelConfig.loadOppSuake = self.loadOpp
        self.game.levelManager.currentLevel.levelConfig.testOppSuakeAI = self.testOppAI
        self.game.levelManager.currentLevel.levelConfig.loadDroids = self.loadDroids
        self.game.levelManager.currentLevel.levelConfig.droidsAttackOwn = self.droidsAttackOwn
        self.game.levelManager.currentLevel.levelConfig.droidsAttackOpp = self.droidsAttackOpp
        
        self.game.levelManager.currentLevel.levelConfig.showCountdown = self.showCountdown
        
        self.game.levelManager.currentLevel.levelConfigEnv.lightIntensity = self.lightIntensity
        self.game.levelManager.lightManager.setAmbientLight(intensity: self.lightIntensity)
        self.game.soundManager.muteSound = !self.soundEffects
        self.game.overlayManager.hud.overlayScene!.arrows.showArrows = (self.showArrows ? .DIR : .NONE)
        self.game.soundManager.volume = self.volume
        GSAudio.sharedInstance.volume = self.volume
    }
}
