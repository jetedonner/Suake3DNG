//
//  SuakeKeyboardHandler.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameKit
import NetTestFW

class SuakeKeyboardHandler: KeyboardHandler {
    
    let pressAnyKeyHandler:PressAnyKeyHandler
    let multiplayerKeyHandler:MultiplayerKeyHandler
    
    override init(game: GameController) {
        self.pressAnyKeyHandler = PressAnyKeyHandler(game: game)
        self.multiplayerKeyHandler = MultiplayerKeyHandler(game: game)
        super.init(game: game)
    }
    
    override func keyPressedEvent(event: NSEvent) {
        super.keyPressedEvent(event: event)
        
        if let pressedKey = KeyboardDirection(rawValue: event.keyCode) {
            
            if(self.multiplayerKeyHandler.handleKeyPress(pressedKey: pressedKey)){
                return
            }
            
            if(self.pressAnyKeyHandler.handleAnyKeyPress(pressedKey: pressedKey)){
                return
            }
            
            if(
                // UP - LEFT - DOWN - RIGHT
                pressedKey == .KEY_UP ||
                pressedKey == .KEY_DOWN ||
                pressedKey == .KEY_LEFT ||
                pressedKey == .KEY_RIGHT ||

                // W-A-S-D
                pressedKey == .KEY_W ||
                pressedKey == .KEY_A ||
                pressedKey == .KEY_S ||
                pressedKey == .KEY_D ){
                
                    if(self.game.stateMachine.currentState != nil && (self.game.stateMachine.currentState?.isKind(of: SuakeStateReadyToPlay.self))!){
                        self.game.stateMachine.stateHelper.startMatch()
                    }else{
                        self.game.playerEntityManager.ownPlayerEntity.appendTurn(turn: pressedKey)
                    }
            }else if(pressedKey == .KEY_SPACE){
                if(self.game.stateMachine.currentState is SuakeStatePlaying || self.game.stateMachine.currentState is SuakeStateReadyToPlay){
                    self.game.playerEntityManager.ownPlayerEntity.shoot()
                }
            }else if(pressedKey == .KEY_ESC){
                if(self.game.stateMachine.currentState is SuakeStateReadyToPlay ||
                    self.game.stateMachine.currentState is SuakeStatePlaying){
                    self.game.stateMachine.enter(SuakeStateMainMenu.self)
                }else if(self.game.stateMachine.currentState is SuakeStateMainMenu){
                    self.game.stateMachine.returnToOldState(saveOldState: false)
                }
            }else if(pressedKey == .KEY_1){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .mg)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_MACHINEGUN_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .mg)
                }
            }else if(pressedKey == .KEY_2){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .shotgun)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_SHOTGUN_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .shotgun)
                }
            }else if(pressedKey == .KEY_3){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .rpg)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_RPG_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .rpg)
                }
            }else if(pressedKey == .KEY_4){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .railgun)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_RAILGUN_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .railgun)
                }
            }else if(pressedKey == .KEY_5){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .sniperrifle)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_SNIPERRIFLE_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .sniperrifle)
                }
            }else if(pressedKey == .KEY_6){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.weapons.getWeapon(weaponType: .redeemer)?.addAmmo(ammoCount2Add: SuakeVars.INITIAL_REDEEMER_AMMORELOADCOUNT)
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.weapons.setCurrentWeaponType(weaponType: .redeemer)
                }
            }else if(pressedKey == .KEY_B){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.levelManager.currentLevel.skyBoxHelper.setSkybox(type: .RandomSkyBox)
                }else{
//                    self.game.physicsHelper.takeSS = true
                }
            }else if(pressedKey == .KEY_C){
                self.game.overlayManager.hud.overlayScene.crosshairEntity.mgCrosshairComponent.animateCrosshair()
            }else if(pressedKey == .KEY_E){
                self.game.playerEntityManager.oppPlayerEntity.loadGridGraph()
            }else if(pressedKey == .KEY_F){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.cameraHelper.toggleFPVOpp()
//                    SCNTransaction.begin()
//                    SCNTransaction.animationDuration = 0.5
//                    SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                    self.game.cameraHelper.cameraNodeFP.look(at: self.game.playerEntityManager.goodyEntity.position)
//                    self.game.cameraHelper.cameraNode.look(at: self.game.playerEntityManager.goodyEntity.position)
//                    SCNTransaction.commit()
                }else{
                    self.game.cameraHelper.toggleFPV()
                }
            }else if(pressedKey == .KEY_G){
//                self.game.overlayManager.hud.msgOnHudComponent.setAndShowLbl(msg: "+ 200 Points")
            }else if(pressedKey == .KEY_I){
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    let image = self.game.rndrr.snapshot(atTime: self.game.physicsHelper.currentTime, with: self.game.gameWindowSize, antialiasingMode: SCNAntialiasingMode.multisampling4X)
                    
                    let desktopURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
                    let destinationURL = desktopURL.appendingPathComponent("my-image-\(DispatchTime.now()).png")
        //            let nsImage = NSImage(cgImage: cgImage, size: ciImage.extent.size)
                    if image.pngWrite(to: destinationURL, options: .withoutOverwriting) {
                        print("File saved")
                    }
                })
            }else if(pressedKey == .KEY_L){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.overlayManager.hud.dbgLogComponent.showDbgLog = !self.game.overlayManager.hud.dbgLogComponent.showDbgLog
                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
                    self.game.overlayManager.hud.dbgLogComponent.logDbgMsg(msg: "Test log message")
                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
                    self.game.overlayManager.hud.dbgLogComponent.clearDbgLog()
                }else{
                    if(self.game.stateMachine.currentState!.isKind(of: SuakeStatePlaying.self)){
                        self.game.stateMachine.statePaused.showPauseOverlay = false
                        self.game.stateMachine.enter(SuakeStatePaused.self)
                    }
                    MouseHelper.showMouseCursor()
                    let vc2:SetupDeveloperViewController = SetupDeveloperViewController()
                    vc2.game = self.game
                    
                    (self.game.scnView as! GameViewMacOS).viewController!.presentAsSheet(vc2)
                }
//                vc2.view.window?.styleMask = .borderless
//                let vc:SetupDeveloperViewController = SetupDeveloperViewController(
//                )
//                (self.game.scnView as! GameViewMacOS).viewController!.presentAsSheet(vc)// .present(vc, animated: true, completion: nil)
//                let myViewController = MyViewController(nibName: "SetupDeveloper", bundle: nil)
//                (self.game.scnView as! GameViewMacOS).viewController.present(myViewController, animated: true, completion: nil)
//                self.game.locationEntityManager.addLocationToScene(pos: SCNVector3(-5, 0, 5))
            }else if(pressedKey == .KEY_O){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    GameCenterHelper.helper.showAchivementsView()
                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    GameCenterHelper.helper.showAchivementsView()
                    self.game.overlayManager.showOverlay4GameState(type: .gameCenter)
                }else{
                    self.game.levelLoaded = false
                    self.game.serverLoaded = false
                    
                    self.game.gameCenterHelper.presentMatchmaker()
//                    GameCenterHelper.helper.delegate = self.game.overlayManager.mainMenu
//                    GameCenterHelper.helper.presentMatchmaker()
//                    self.game.gameCenterHelper.pre
                }
            }else if(pressedKey == .KEY_P){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.weaponPickups.isHidden = !self.game.weaponPickups.isHidden
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                    self.game.locationEntityManager.rndPortalPos()
//                }else{
                    if(self.game.stateMachine.currentState!.isKind(of: SuakeStatePlaying.self)){
                        self.game.stateMachine.statePaused.showPauseOverlay = true
                        self.game.stateMachine.enter(SuakeStatePaused.self)
                    }else if(self.game.stateMachine.currentState!.isKind(of: SuakeStatePaused.self)){
                        self.game.stateMachine.returnToOldState()
                    }
//                }
            }else if(pressedKey == .KEY_Q){
                self.game.playerEntityManager.ownPlayerEntity.healthComponent.died = true
                self.game.stateMachine.enter(SuakeStateDied.self)
            }else if(pressedKey == .KEY_R){
                self.game.overlayManager.showOverlay4GameState(type: .matchResult)
            }else if(pressedKey == .KEY_T){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.tvMonitorManager.showNoise = !self.game.tvMonitorManager.showNoise
                }else{
                    self.game.overlayManager.hud.showMsg(msg: "TESET MESSAGE FROM UI INPUT")
                }
            }else if(pressedKey == .KEY_U){
                GKNotificationBanner.show(withTitle: "Catch 20 godies", message: "Complete catch 20 goddies achivement", duration: 3.0, completionHandler: {
                    
                })
            }else if(pressedKey == .KEY_V){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    
                }else{
                    self.game.playerEntityManager.oppPlayerEntity.loadGridGraph()
                }
            }else if(pressedKey == .KEY_X){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.playerComponent.startAnimationTMP()
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.playerComponent.stopAnimationTMP()
                }
            }else if(pressedKey == .KEY_Y){
                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
                    self.game.playerEntityManager.ownPlayerEntity.playerComponent.currentSuakeComponent = self.game.playerEntityManager.ownPlayerEntity.playerComponent.allSuakeComponents[0]
                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
                    self.game.playerEntityManager.ownPlayerEntity.playerComponent.currentSuakeComponent = self.game.playerEntityManager.ownPlayerEntity.playerComponent.allSuakeComponents[1]
                }else{
                    self.game.playerEntityManager.ownPlayerEntity.playerComponent.currentSuakeComponent = self.game.playerEntityManager.ownPlayerEntity.playerComponent.allSuakeComponents[2]
                }
            }else if(pressedKey == .KEY_Z){
                (self.game.scnView as! GameViewMacOS).viewController?.restartGameController() //initGameController(reload: true)
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.wormHoleHelper.showWormHole(show: false)
//                }else{
//                    self.game.wormHoleHelper.enterWormHole(portalEntity: self.game.locationEntityManager.portals[0], portalId: 0)
//                }
            }

            
        }
        
////            if(pressedKey == .KEY_EXCLAMATIONMARK && event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                if(self.game.overlayManager.currentOverlay() is GameLoadingSkScene){
////                    let newProgressPercent = self.game.overlayManager.gameLoading.newProgressPercent + 5
////                    self.game.overlayManager.gameLoading.setProgress(curPrecent: newProgressPercent, msg: "Debug progress step: " + newProgressPercent.description + "%")
////                }
////                return
////            }
//
//            if(pressAnyKeyHandler.handleAnyKeyPress(pressedKey: pressedKey)){
//                return
//            }
//
//            if(
//                // UP - LEFT - DOWN - RIGHT
//                pressedKey == .KEY_UP ||
//                pressedKey == .KEY_DOWN ||
//                pressedKey == .KEY_LEFT ||
//                pressedKey == .KEY_RIGHT ||
//
//                // W-A-S-D
//                pressedKey == .KEY_W ||
//                pressedKey == .KEY_A ||
//                pressedKey == .KEY_S ||
//                pressedKey == .KEY_D ){
//
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.command)){
//                    var newDir:SuakeDir = .UP
//                    switch(pressedKey){
//                        case .KEY_UP:
//                            newDir = .UP
//                        case .KEY_DOWN:
//                            newDir = .DOWN
//                        case .KEY_LEFT:
//                            newDir = .LEFT
//                        case .KEY_RIGHT:
//                            newDir = .RIGHT
//                        default:
//                            break
//                    }
//
//                    guard let droidEntity = self.game.playerEntityManager.getPlayerEntity(ofType: DroidEntity.self, id: 0) else {
//                        return
//                    }
//
//                    if(newDir != (droidEntity as! DroidEntity).component(ofType: DroidComponent.self)?.dir){
//                        (droidEntity as! DroidEntity).component(ofType: DroidComponent.self)?.rotateDroid(newDir: newDir)
//                    }else{
//                        (droidEntity as! DroidEntity).nextStep()
//                    }
//                }else{
//
//                    if(pressedKey == .KEY_A && event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                        self.game.stateMachine.statePlaying.dbgDroidAi = true
//                        _ = self.game.stateMachine.enter(SuakeStatePlaying.self)
//                    }else if(pressedKey == .KEY_D && event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                        if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                            if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                                self.game.playerEntityManager.getDroidEntity().droidComponent.stopHeadAnimation()
//                            }else{
//                                self.game.playerEntityManager.getDroidEntity().droidComponent.playHeadAnimation()
//                            }
//                        }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                            self.game.playerEntityManager.getDroidEntity().droidComponent.changeDroidMode(state: .AttackingOpp)
//                        }else{
//                            self.game.playerEntityManager.getDroidEntity().droidComponent.changeDroidMode(state: .Patroling)
//                        }
////                    }else if(pressedKey == .KEY_S && event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                            self.game.playerEntityManager.getOppPlayerEntity()!.autoAimAndShootOpp()
//                    }else{
//                        if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                            if(pressedKey == .KEY_W){
//
//                            }
//                        }else{
//                            guard let ownSuakeEntity = self.game.playerEntityManager.getPlayerEntity(ofType: SuakeOwnPlayerEntity.self, id: 0) else {
//                                return
//                            }
//
//                            if(self.game.stateMachine.currentState != nil && (self.game.stateMachine.currentState?.isKind(of: SuakeStateReadyToPlay.self))!){
//                                _ = self.game.stateMachine.enter(stateClass: SuakeStatePlaying.self)
//                            }else{
//                                (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: pressedKey)
//                            }
//                        }
//                    }
//                }
//            }else if(pressedKey == .KEY_SPACE){
//                if(self.game.stateMachine.currentState is SuakeStatePlaying || self.game.stateMachine.currentState is SuakeStateReadyToPlay){
//                    if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                        self.game.playerEntityManager.oppPlayerEntity.shootAtComponent.autoAimAndShootOppAt(entity: self.game.playerEntityManager.goodyEntity)
//                    }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                        self.game.playerEntityManager.ownPlayerEntity.autoAimAndShootOwnAt(entity: self.game.playerEntityManager.oppPlayerEntity)
//                    }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                        self.game.playerEntityManager.ownPlayerEntity.autoAimAndShootOwnAt(entity: self.game.playerEntityManager.goodyEntity)
//                    }else{
//                        self.game.playerEntityManager.getOwnPlayerEntity().shoot()
//                    }
//                }
//            }else if(pressedKey == .KEY_ESC){
//                if(self.game.stateMachine.currentState is SuakeStateReadyToPlay ||
//                    self.game.stateMachine.currentState is SuakeStatePlaying){
//                    _ = self.game.stateMachine.enter(SuakeStateMainMenu.self)
//                }else if(self.game.stateMachine.currentState is SuakeStateMainMenu){
//                    if(self.game.stateMachine.oldState != SuakeStateDeveloperSetup.self){
//                        _ = self.game.stateMachine.returnToOldState3()
//                    }else{
//                        _ = self.game.stateMachine.enter(SuakeStateReadyToPlay.self)
//                    }
//                }else if(self.game.stateMachine.currentState is SuakeStateDeveloperSetup){
//                    self.game.overlayManager.setupDeveloper.unloadView()
//                    _ = self.game.stateMachine.returnToOldState(saveOldState: false)
//                }else if(self.game.stateMachine.currentState is SuakeStateMainSetup){
//                    self.game.overlayManager.setupMain.unloadView()
//                    self.game.settings.loadSettings()
//                    self.game.levelManager.loadLevel(initialLoad: false)
//                    //_ = self.game.stateMachine.enter(SuakeStateMainMenu.self)
////                    _ = self.game.stateMachine.returnToOldState()
//                    _ = self.game.stateMachine.enter(SuakeStateMainMenu.self)
//                }
//            }else if(pressedKey == .KEY_RETURN){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.oppPlayerEntity.died(killedByPlayerType: .OppSuake)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
////                    self.game.playerEntityManager.oppPlayerEntity.died(killedByPlayerType: .OppSuake)
//                    let fadeHel:FadeViewAfterDeathNG = FadeViewAfterDeathNG(game: self.game)
//                    fadeHel.showDeathFadeOut(playerType: .OwnSuake, completion: {})
//                }else{
//                    self.game.playerEntityManager.ownPlayerEntity.died(killedByPlayerType: .OwnSuake)
//                }
//            }else if(pressedKey == .KEY_DASH){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    if(event.modifierFlags.contains(NSEvent.ModifierFlags.command)){
//                        var subLightIntensity:CGFloat = 250.0
//                        switch self.game.levelManager.lightManager.ambientLightNode.light?.intensity {
//                        case let x where x! > 1000:
//                            subLightIntensity = 250.0
//                        case let x where x! > 250:
//                            subLightIntensity = 150.0
//                        case let x where x! > 100:
//                            subLightIntensity = 50.0
//                        case let x where x! > 0:
//                            subLightIntensity = 25.0
//                        default:
//                            subLightIntensity = 250.0
//                        }
//                        self.game.levelManager.lightManager.ambientLightNode.light?.intensity -= subLightIntensity
//                        self.game.showDbgMsg(dbgMsg: "Ambient light intensity - DOWN: " + subLightIntensity.description + " -> New insensity: " + (self.game.levelManager.lightManager.ambientLightNode.light?.intensity.description)!, dbgLevel: .Info)
//                    }else{
//
//                    }
//                }else{
//
//                }
//            }else if(pressedKey == .KEY_1){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    if(event.modifierFlags.contains(NSEvent.ModifierFlags.command)){
//                        var addLightIntensity:CGFloat = 250.0
//                        switch self.game.levelManager.lightManager.ambientLightNode.light?.intensity {
//                        case let x where x! > 1000:
//                            addLightIntensity = 250.0
//                        case let x where x! > 250:
//                            addLightIntensity = 150.0
//                        case let x where x! > 100:
//                            addLightIntensity = 50.0
//                        case let x where x! > 0:
//                            addLightIntensity = 25.0
//                        default:
//                            addLightIntensity = 250.0
//                        }
//                        self.game.levelManager.lightManager.ambientLightNode.light?.intensity += addLightIntensity
//                        self.game.showDbgMsg(dbgMsg: "Ambient light intensity - UP: " + addLightIntensity.description + " -> New insensity: " + (self.game.levelManager.lightManager.ambientLightNode.light?.intensity.description)!, dbgLevel: .Info)
////                        self.game.showDbgMsg(dbgMsg: "Ambient light intensity - UP: " + String(250), dbgLevel: .Info)
////                        self.game.levelManager.lightManager.ambientLightNode.light?.intensity += 250.0
//                    }else{
//                        self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .mg)!.addAmmo(ammoCount2Add: 10)
//                        self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .mg)
//                    }
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .mg)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .mg)
//                }
//            }else if(pressedKey == .KEY_2){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .shotgun)!.addAmmo(ammoCount2Add: 10)
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .shotgun)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .shotgun)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .shotgun)
//                }
//            }else if(pressedKey == .KEY_3){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .rpg)!.addAmmo(ammoCount2Add: 10)
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .rpg)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .rpg)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .rpg)
//                }
//            }else if(pressedKey == .KEY_4){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .railgun)!.addAmmo(ammoCount2Add: 10)
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .railgun)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .railgun)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .railgun)
//                }
//            }else if(pressedKey == .KEY_5){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .sniperrifle)!.addAmmo(ammoCount2Add: 10)
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .sniperrifle)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .sniperrifle)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .sniperrifle)
//                }
//            }else if(pressedKey == .KEY_6){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.getWeapon(weaponType: .redeemer)!.addAmmo(ammoCount2Add: 10)
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .redeemer)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.getOppPlayerEntity()!.weapons.setCurrentWeaponType(weaponType: .redeemer)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().weapons.setCurrentWeaponType(weaponType: .redeemer)
//                }
//            }else if(pressedKey == .KEY_7){
////                ((self.game.locationEntityManager.getLocationEntity(locationType: .Portal) as! PortalEntity).component(ofType: PortalComponent.self)!).changeColor()
//            }else if(pressedKey == .KEY_8){
////                ((self.game.locationEntityManager.getLocationEntity(locationType: .Portal) as! PortalEntity).component(ofType: PortalComponent.self)!).changeColor(alt: true)
//            }else if(pressedKey == .KEY_B){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    GameCenterHelper.achievements.showBanner(title: "Teset Banner", message: "Some t3s3t message to show a banner", completionHandler: {
//                        print("Banner shown and closed successfully")
//                    })
//                }else{
//                    self.game.audioManager.bgMusicOn = !self.game.audioManager.bgMusicOn
//                }
//            }else if(pressedKey == .KEY_C){
////                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    self.game.overlayManager.hud.hudEntity.crosshairEntity.redeemerCrosshairComponent.animateMorphableBack()
////                }else{
////                    self.game.overlayManager.hud.hudEntity.crosshairEntity.redeemerCrosshairComponent.animateMorphable()
////                }
//            }else if(pressedKey == .KEY_E){
//                self.game.playerEntityManager.getDroidEntity(id: 0).droidDied(killedBy: .OwnSuake)
//            }else if(pressedKey == .KEY_F){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.cameraHelper.toggleFPVOpp()
//                }else{
//                    self.game.cameraHelper.toggleFPV()
//                }
//            }else if(pressedKey == .KEY_G){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    _ = self.game.playerEntityManager.getOwnPlayerEntity().decHealth(decVal: 25.0)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    _ = self.game.playerEntityManager.oppPlayerEntity.decHealth(decVal: 25.0)
//                }else{
//                    _ = self.game.playerEntityManager.getGoodyEntity().goodyHit()
//                }
//                //self.game.overlayManager.hud.drawHealthBar()
//            }else if(pressedKey == .KEY_I){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.playerEntityManager.getOwnPlayerEntity().component(ofType: SuakeLightComponent.self)?.fadeLight(fadeIn: false)
//                }else{
//                    self.game.playerEntityManager.getOwnPlayerEntity().component(ofType: SuakeLightComponent.self)?.fadeLight(fadeIn: true)
//                }
//            }else if(pressedKey == .KEY_K){
//                self.game.cameraHelper.rotateFPCam()
//            }else if(pressedKey == .KEY_L){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.levelManager.loadLevel(levelID: .DBG_dark)
////                    //self.game.overlayManager.hud.hudEntity.updateHealthBarOppPos()
////                    self.game.levelManager.loadRandomLevel()
//                }else{
//                    self.game.overlayManager.hud.hudEntity.dbgLogComponent.showDbgLog = !self.game.overlayManager.hud.hudEntity.dbgLogComponent.showDbgLog
//                }
//            }else if(pressedKey == .KEY_M){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.overlayManager.hud.hudEntity.crosshairEntity.reloadComponent.startReloadBar(duration: 1.5)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    if(self.game.overlayManager.currentOverlay() is NukeViewOverlay){
//                        self.game.overlayManager.showOverlay4GameState(type: .playing)
//                    }else{
//                        self.game.overlayManager.hud.hudEntity.crosshairEntity.redeemerCrosshairComponent.showRocketView()
//                    }
//                }else{
//                    self.game.overlayManager.hud.hudEntity.crosshairEntity.currentCrosshairComponent.animateCrosshair()
//                }
//            }else if(pressedKey == .KEY_N){
//                if(!(self.game.stateMachine.currentState?.isKind(of: SuakeStatePlaying.self))!){
//                    _ = self.game.stateMachine.enter(stateClass: SuakeStatePlaying.self, saveOldState: false)
//                }
//                guard let droidEntity = self.game.playerEntityManager.getPlayerEntity(ofType: DroidEntity.self, id: 0) else {
//                    return
//                }
//                (droidEntity as! DroidEntity).isPaused = false
//                (droidEntity as! DroidEntity).nextMove()
//            }else if(pressedKey == .KEY_O){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.levelManager.loadRandomLevelEnvironment()
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.levelManager.currentLevel.setRandomFloor()
//                }else{
//                    self.game.levelManager.currentLevel.setRandomWallpaper()
//                }
//            }else if(pressedKey == .KEY_P){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.weaponPickups.isHidden = !self.game.weaponPickups.isHidden
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                    self.game.locationEntityManager.rndPortalPos()
//                }else{
//                    if(self.game.stateMachine.currentState!.isKind(of: SuakeStatePlaying.self)){
//                        _ = self.game.stateMachine.enter(SuakeStatePaused.self)
//                    }else if(self.game.stateMachine.currentState!.isKind(of: SuakeStatePaused.self)){
//                        _ = self.game.stateMachine.returnToOldState()
//                    }
//                }
//            }else if(pressedKey == .KEY_Q){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.overlayManager.hud.toggleWindroseOrArrows()
//                }else{
//                    self.game.levelManager.questManager.drawQuestCompleted(quest: DbgQuest(game: self.game))
//                }
//            }else if(pressedKey == .KEY_R){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
//                    self.game.tmpResetGame()
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.overlayManager.hud.map.reposNode(nodeType: .own_suake)
//                }else{
//                    self.game.tmpResetGame()
//                    _ = self.game.stateMachine.enter(stateClass: SuakeStateReadyToPlay.self, saveOldState: false)
//                }
//            }else if(pressedKey == .KEY_T){
//                if(self.game.stateMachine.currentState is SuakeStateTutorial){
//                    _ = self.game.stateMachine.returnToOldState()
//                }else{
//                    _ = self.game.stateMachine.enter(stateClass: SuakeStateTutorial.self, saveOldState: true)
//                }
////            }else if(pressedKey == .KEY_X){
////                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    guard let ownSuakeEntity = self.game.playerEntityManager.getPlayerEntity(ofType: SuakeOwnPlayerEntity.self, id: 0) else {
////                        return
////                    }
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_RIGHT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    (ownSuakeEntity as! SuakePlayerEntity).appendTurn(turn: .KEY_LEFT)
////                    _ = self.game.stateMachine.enter(stateClass: SuakeStatePlaying.self)
////                }else{
////                    _ = self.game.stateMachine.enter(stateClass: SuakeStateCheatSheet.self)
////                }
//            }else if(pressedKey == .KEY_U){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
//                    self.game.levelManager.currentLevel.setNextSkybox()
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    self.game.playerEntityManager.oppPlayerEntity.intelligenceComponent.changeMode(newMode: .SeekMedKit)
////                    self.game.playerEntityManager.oppPlayerEntity.intelligenceComponent.stateMachine.enter(OpponentSeekMedKitState.self)
//                }else{
//                    self.game.levelManager.currentLevel.setNextFloor()
//                }
//            }else if(pressedKey == .KEY_V){
//                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    self.game.showDbgMsg(dbgMsg: "Opponent AI path loaded!", dbgLevel: .Info)
////                    self.game.playerEntityManager.getOppPlayerEntity()?.loadPath2Goody()
//                    /*if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                        self.game.playerEntityManager.getOppPlayerEntity()!.gotoNextMedKit()
//                        self.game.stateMachine.statePlaying.dbgOpponentAi2MedKit = true
//                        _ = self.game.stateMachine.enter(SuakeStatePlaying.self)
//                    }else{*/
////                        self.game.stateMachine.statePlaying.dbgOpponentAi = true
//                        _ = self.game.stateMachine.enter(SuakeStatePlaying.self)
////                    }
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.option)){
//                    let oppPos = self.game.playerEntityManager.getOppPlayerEntity()?.pos
//                    self.game.showDbgMsg(dbgMsg: "Opponent pos x: " + (oppPos?.x.description)! + " y: " + (oppPos?.z.description)!, dbgLevel: .Info)
//                }else if(event.modifierFlags.contains(NSEvent.ModifierFlags.control)){
////                    self.game.playerEntityManager.getOppPlayerEntity()?.update(deltaTime: 1.0, inBetween: true)
//                    self.game.playerEntityManager.getOppPlayerEntity()?.intelligenceComponent.update(deltaTime: 1.0)//.nextOppMove()
//                }else{
//                    self.game.showDbgMsg(dbgMsg: "Opponent AI path loaded!", dbgLevel: .Info)
//                    self.game.playerEntityManager.getOppPlayerEntity()?.initialLoadPathTMP()
////                    self.game.playerEntityManager.getOppPlayerEntity()?.loadPath2Goody(afterGoodyHit: false, doNotRemoveFirst: false, nextPos: nil, removeFrom: SCNVector3(-2, 0, 0), removeTo: SCNVector3(-1, 0, 0))
////
////                    self.game.showDbgMsg(dbgMsg: "Opponent AI Test started!", dbgLevel: .Info)
////                    self.game.playerEntityManager.getOppPlayerEntity()?.startAITest()
//
//                }
//
//                //self.game.playerEntityManager.getOppPlayerEntity()
//            }else if(pressedKey == .KEY_X){ // X: Show Cheatsheet
//                //_ = self.game.stateMachine.enter(stateClass: SuakeStateCheatSheet.self)
//                if(self.game.overlayManager.currentOverlay() == self.game.overlayManager.cheatsheet){
//                    self.game.overlayManager.cheatsheet.closeView()
//                    self.game.overlayManager.showOverlay4GameState(type: .ready2Play)
//                }else{
//                    self.game.overlayManager.showOverlay4GameState(type: .cheatsheet)
//                }
////                if(menuShowing){
////                    return
////                }
////                cheatSheetShowing = !cheatSheetShowing
////                if(cheatSheetShowing){
////                    cameraNode.camera?.wantsDepthOfField = true
////                    (sceneRenderer as? SCNView)!.allowsCameraControl = false
////                    showDbgMsg(dbgMsg: DbgMsgs.gameShowKeyHints)
//////                        skCheatSheet.addScrollView()
////                    self.sceneRenderer?.overlaySKScene = skCheatSheetNG
////                }else{
////                    cameraNode.camera?.wantsDepthOfField = false
////                    (sceneRenderer as? SCNView)!.allowsCameraControl = true
////                    showDbgMsg(dbgMsg: DbgMsgs.gameHideKeyHints)
////                    skCheatSheetNG.unloadView()
////                    skCheatSheetNG.removeFromParent()
////                    self.sceneRenderer?.overlaySKScene = sk
////                    if(skTut.currentStep == .initial){
////                        completedTutorialStep(step: .initial)
////                    }
////                }
//                // DbgMsg call in toggle / set func
//            }else if(pressedKey == .KEY_Y){
//                self.game.playerEntityManager.getOppPlayerEntity()?.followComponent.loadPathNG(toEntity: self.game.playerEntityManager.goodyEntity)
////                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    self.game.locationEntityManager.portals[0].pairComponent.portals[0].changeColor(alt: false)
////                }else{
////                    self.game.locationEntityManager.portals[0].pairComponent.portals[0].changeColor(alt: true)
////                }
//            }else if(pressedKey == .KEY_Z){
//                (self.game.scnView as! GameViewMacOS).viewController?.restartGameController() //initGameController(reload: true)
////                if(event.modifierFlags.contains(NSEvent.ModifierFlags.shift)){
////                    self.game.wormHoleHelper.showWormHole(show: false)
////                }else{
////                    self.game.wormHoleHelper.enterWormHole(portalEntity: self.game.locationEntityManager.portals[0], portalId: 0)
////                }
//            }
//        }
//    }
//
//    override func capsLockChanged(on: Bool) {
//        super.capsLockChanged(on: on)
//
//        let checkState:Bool = (self.game.stateMachine.currentState is SuakeStatePlaying || self.game.stateMachine.currentState is SuakeStateReadyToPlay)
//
//        guard checkState else {
//            return
//        }
//
//        self.game.overlayManager.hud.map.zoomMap(zoomOn: on)
//    }
    }
    
    override func capsLockChanged(on: Bool) {
        super.capsLockChanged(on: on)
        let checkState:Bool = (self.game.stateMachine.currentState is SuakeStatePlaying || self.game.stateMachine.currentState is SuakeStateMultiplayerPlaying || self.game.stateMachine.currentState is SuakeStateReadyToPlay) //self.game.stateMachine.isCurrentState(inStates: [SuakeStatePlaying.Type, SuakeStateMultiplayerPlaying.Type, SuakeStateReadyToPlay.Type]) // (self.game.stateMachine.currentState is SuakeStatePlaying || self.game.stateMachine.currentState is SuakeStateMultiplayerPlaying || self.game.stateMachine.currentState is SuakeStateReadyToPlay)
        
        guard checkState else {
            return
        }
        self.game.overlayManager.hud.overlayScene.map.toggleZoomMap()
    }
}
