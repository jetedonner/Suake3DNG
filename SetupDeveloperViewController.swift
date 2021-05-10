//
//  TestViewController.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Cocoa

@objcMembers class Option: NSObject {
  dynamic var name: String
  dynamic var identifier: String

  init(name: String, identifier: String) {
    self.name = name
    self.identifier = identifier
  }
}

class SetupDeveloperViewController: NSViewController {
    
    var game:GameController!
    
    @objc dynamic var optionsForLightIntensity = [Option(name: "NoLight", identifier: "id-1"),
                                           Option(name: "Low", identifier: "id-2"),
                                           Option(name: "Medium", identifier: "id-3"),
                                           Option(name: "Normal", identifier: "id-4"),
                                           Option(name: "High", identifier: "id-5"),
                                           Option(name: "VeryHigh", identifier: "id-6")]
    
    @objc dynamic var optionsForDifficulty = [Option(name: "Tutorial", identifier: "id-1"),
                                           Option(name: "Easy", identifier: "id-2"),
                                           Option(name: "Medium", identifier: "id-3"),
                                           Option(name: "Hard", identifier: "id-4"),
                                           Option(name: "Nightmare", identifier: "id-5"),
                                           Option(name: "Unreal", identifier: "id-6")]
    
    @objc dynamic var optionsForGameboardSize = [Option(name: "10x10", identifier: "id-1"),
                                           Option(name: "20x20", identifier: "id-2"),
                                           Option(name: "30x30", identifier: "id-3"),
                                           Option(name: "40x40", identifier: "id-4"),
                                           Option(name: "50x50", identifier: "id-5"),
                                           Option(name: "70x70", identifier: "id-6")]
    
    @objc dynamic var optionsForMatchDurration = [Option(name: "Infinite ∞", identifier: "id-1"),
                                            Option(name: "10 Seconds", identifier: "id-2"),
                                            Option(name: "20 Seconds", identifier: "id-3"),
                                           Option(name: "30 Seconds", identifier: "id-4"),
                                           Option(name: "1 Minute", identifier: "id-5"),
                                           Option(name: "2 Minutes", identifier: "id-6"),
                                           Option(name: "5 Minutes", identifier: "id-7"),
                                           Option(name: "10 Minutes", identifier: "id-8"),
                                           Option(name: "15 Minutes", identifier: "id-9")]
    
    @objc dynamic var optionsForHUDOrientationHelper = [Option(name: "Arrows", identifier: "id-1"),
                                           Option(name: "Windrose", identifier: "id-2"),
                                           Option(name: "None", identifier: "id-3")]
    
    
    @IBAction func closeSaveAndReload(_ sender: Any) {
        self.game.usrDefHlpr.loadValuesFromUserDefaults()
        self.game.usrDefHlpr.resetUserDefaults2Game()
        self.game.levelManager.loadLevel(initialLoad: true)
        self.game.overlayManager.hud.setGameTimer(time: self.game.levelManager.currentLevel.levelConfigEnv.matchDuration.rawValue)
        self.game.overlayManager.hud.overlayScene!.map.updateMap(byPassCheck: true)
        self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
//        self.dismiss(true)
        self.closeViewAndReturn2OldState()
    }
    
    @IBAction func closeAndSave(_ sender: Any) {
        self.game.usrDefHlpr.loadValuesFromUserDefaults()
        self.game.usrDefHlpr.resetUserDefaults2Game()
        self.game.overlayManager.hud.setGameTimer(time: self.game.levelManager.currentLevel.levelConfigEnv.matchDuration.rawValue)
//        self.dismiss(true)
        self.closeViewAndReturn2OldState()
        self.game.stateMachine.returnToOldState()
    }
    
    @IBAction func closeDevView(_ sender: Any) {
//        self.dismiss(true)
        self.closeViewAndReturn2OldState()
    }
    
    func closeViewAndReturn2OldState(){
        self.dismiss(true)
        if(self.game.cameraHelper.fpv || self.game.cameraHelper.fpvOpp){
            MouseHelper.showMouseCursor(show: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
