//
//  UserDefaultsHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class UserDefaultsHelper:SuakeGameClass{
    
    let defaults = UserDefaults.standard
    
    var devMode:Bool = true
    var showDbgLog:Bool = true
    
    var dbgLogColor:NSColor = .white
    
    // MULTIPLAYER
    
    
    var enableGameCenter:Bool = true
    var dbgMultiplayer:Bool = true
    var multiHumanPlayer2Control:String = "NONE"
    
    var soundEffects:Bool = true
    var matchDuration:MatchDuration = .Minute_1
    var levelSize:LevelSize = .Small
    var difficulty:LevelDifficulty = .Medium
    var lightIntensity:LightIntensity = .normal
    var showArrows:Bool = true
    var showWindrose:Bool = true
    var showTVMonitors:Bool = true
    
    var volume:CGFloat = 0.5
    
    var showCountdown:Bool = true
    var loadWeaponPickups:Bool = true
    var loadObstacles:Bool = true
    var obstacleCount:Int = 5
    
    var loadPortals:Bool = true
    var quakeSkyboxes:Bool = true
    var randomQuakeSkyboxAndFloor:Bool = true
    var showFollowParticles:Bool = false
    
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
            "ShowDbgLog": false,
            "DbgMultiplayer": false,
            "EnableGameCenter": false,
            
            "MultiHumanPlayer2Control": "Player 1",
            
            "MatchDuration": MatchDuration.Minute_1.rawValue,
            "GameboardSize": LevelSize.Small.rawValue,
            "Difficulty": LevelDifficulty.Medium.rawValue,
            "LightIntensity": LightIntensity.normal.rawValue,
            "ShowArrows": SuakeVars.showArrows,
            "ShowWindrose": SuakeVars.showWindrose,
            "ShowTVMonitors": SuakeVars.showTVMonitors,
            "ShowFollowParticles": SuakeVars.showFollowParticles,
            
            "Volume": SuakeVars.volume,
            "LoadWeaponPickups": SuakeVars.loadWeaponPickups,
            "LoadObstacles": SuakeVars.loadObstacles,
            "ObstacleCount": SuakeVars.obstacleCount,
            
            "LoadPortals": SuakeVars.loadPortals,
            "QuakeSkyboxes": SuakeVars.quakeSkyboxes,
            "RandomQuakeSkyboxAndFloor": SuakeVars.randomQuakeSkyboxAndFloor,
            
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
        self.showDbgLog = self.defaults.bool(forKey: "ShowDbgLog")
        self.dbgMultiplayer = self.defaults.bool(forKey: "DbgMultiplayer")
        self.enableGameCenter = self.defaults.bool(forKey: "EnableGameCenter")
        
        self.multiHumanPlayer2Control = self.defaults.string(forKey: "MultiHumanPlayer2Control")!
        
        self.soundEffects = self.defaults.bool(forKey: "SoundEffects")
        self.loadWeaponPickups = self.defaults.bool(forKey: "LoadWeaponPickups")
        self.loadObstacles = self.defaults.bool(forKey: "LoadObstacles")
        self.obstacleCount = self.defaults.integer(forKey: "ObstacleCount")
        self.loadPortals = self.defaults.bool(forKey: "LoadPortals")
        self.quakeSkyboxes = self.defaults.bool(forKey: "QuakeSkyboxes")
        self.randomQuakeSkyboxAndFloor = self.defaults.bool(forKey: "RandomQuakeSkyboxAndFloor")
        
        self.loadOpp = true //self.defaults.bool(forKey: "LoadOpp")
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
        self.showWindrose = self.defaults.bool(forKey: "ShowWindrose")
        self.showTVMonitors = self.defaults.bool(forKey: "ShowTVMonitors")
        self.showFollowParticles = self.defaults.bool(forKey: "ShowFollowParticles")
        
        
        
        
        self.volume = CGFloat(self.defaults.float(forKey: "Volume"))
    }

    func resetUserDefaults2Game(){
        self.game.levelManager.currentLevel.levelConfigEnv.matchDuration = self.matchDuration
        self.game.levelManager.currentLevel.levelConfigEnv.levelSize = self.levelSize
        self.game.levelManager.currentLevel.levelConfigEnv.levelDifficulty = self.difficulty
        self.game.levelManager.currentLevel.levelConfig.levelSetup.loadWeaponPickups = self.loadWeaponPickups
        self.game.levelManager.currentLevel.levelConfig.levelSetup.loadObstacles = self.loadObstacles
        self.game.levelManager.currentLevel.levelConfig.levelSetup.obstacleCount = self.obstacleCount
        self.game.levelManager.currentLevel.levelConfig.levelSetup.loadPortals = self.loadPortals
        self.game.levelManager.currentLevel.levelConfig.levelSetup.quakeSkyboxes = self.quakeSkyboxes
        self.game.levelManager.currentLevel.levelConfig.levelSetup.randomQuakeSkyboxAndFloor = self.randomQuakeSkyboxAndFloor
        
        self.game.levelManager.currentLevel.levelConfig.levelSetup.loadAISuake = self.loadOpp
        self.game.levelManager.currentLevel.levelConfig.levelSetup.loadDroids = self.loadDroids
        self.game.levelManager.currentLevel.levelConfig.levelSetup.droidsAttackOwn = self.droidsAttackOwn
        self.game.levelManager.currentLevel.levelConfig.levelSetup.droidsAttackOpp = self.droidsAttackOpp
        
        self.game.levelManager.currentLevel.levelConfig.levelSetup.showCountdown = self.showCountdown
        
        self.game.levelManager.currentLevel.levelConfigEnv.showTVMonitors = self.showTVMonitors
        self.game.levelManager.currentLevel.levelConfigEnv.showFollowParticles = self.showFollowParticles
        
        self.game.levelManager.currentLevel.levelConfigEnv.lightIntensity = self.lightIntensity
        self.game.levelManager.lightManager.setAmbientLight(intensity: self.lightIntensity)
        self.game.soundManager.muteSound = !self.soundEffects
        self.game.overlayManager.hud.overlayScene!.arrows.showArrows = (self.showArrows ? .DIR : .NONE)
        self.game.overlayManager.hud.overlayScene!.showWindroseOrArrows(showWindrose: self.showWindrose)
        self.game.overlayManager.hud.dbgLogComponent.showDbgLog = self.showDbgLog

        self.game.soundManager.volume = self.volume
        GSAudio.sharedInstance.volume = self.volume
        
        SuakeVars.useGameCenter = self.enableGameCenter
    }
}
