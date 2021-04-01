//
//  GameViewMacOS.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

class GameViewMacOS: SCNView {

//    @IBOutlet var sharedUserDefCont:NSUserDefaultsController!
    weak var viewController: GameViewControllerMacOS?
    var eventsDelegate: KeyboardAndMouseEventsDelegate?
    var trackingArea : NSTrackingArea?

    override init(frame: NSRect, options: [String : Any]? = nil) {
        let sceneViewOptions = [SCNView.Option.preferredRenderingAPI.rawValue: NSNumber(value: SCNRenderingAPI.metal.rawValue)]
        super.init(frame: frame, options: sceneViewOptions)
    }
    
    override init(frame frameRect: NSRect) {
        let sceneViewOptions = [SCNView.Option.preferredRenderingAPI.rawValue: NSNumber(value: SCNRenderingAPI.metal.rawValue)]
        super.init(frame: frameRect, options: sceneViewOptions)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.viewController?.initGameController()
        self.window?.acceptsMouseMovedEvents = true
//        let sdud:SuakeDbgUserDefaults = SuakeDbgUserDefaults()
//        sdud.registerDbgDefaults()
//        _ = sdud.getValueBool(key: SuakeDbgUserDefaults.DroidsLoad)
//        _ = sharedUserDefCont.defaults.bool(forKey: SuakeDbgUserDefaults.DroidsLoad)
//        _ = UserDefaults.standard.bool(forKey: SuakeDbgUserDefaults.DroidsLoad)
    }
    
    override func updateTrackingAreas() {
//        for ta in self.trackingAreas {
//            self.removeTrackingArea(ta)
//        }

        if self.trackingArea != nil {
            self.removeTrackingArea(self.trackingArea!)
        }
        let options : NSTrackingArea.Options =
            [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        let rect:CGRect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.trackingArea = NSTrackingArea(rect: rect, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea!)
    }
//
    override func keyDown(with theEvent: NSEvent) {
        if self.viewController?.keyDown(self, event: theEvent) == false {
            super.keyDown(with: theEvent)
        }
    }

    override func keyUp(with theEvent: NSEvent) {
        if self.viewController?.keyUp(self, event: theEvent) == false {
            super.keyUp(with: theEvent)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
//        if(self.viewController?.gameController?.stateMachine.currentState is SuakeStateGameLoading){
//            return
//
//        }
        if(self.viewController?.gameController?.stateMachine.currentState is SuakeStateMainMenu /*||
            self.viewController?.gameController?.stateMachine.currentState is SuakeStateTutorial*/){

            self.viewController?.gameController?.overlayManager.mainMenu.mouseMovedHandler(with: event)
//            self.viewController?.gameController?.overlayManager.tutorialOverlay.mouseMovedHandler(with: event)

        }else if(self.viewController?.gameController?.stateMachine.currentState is SuakeStatePlaying || self.viewController?.gameController?.stateMachine.currentState is SuakeStateReadyToPlay){

            if(!self.viewController!.gameController!.cameraHelper.fpv){
                return
            }
//            if(!(self.viewController?.gameController?.cameraHelper.fpv)! && (!(self.viewController?.gameController?.overlayManager.hud.hudEntity.csComponent.fadedIn)!)){
//                return
//            }

            let delta = CGGetLastMouseDelta()
            if (delta.x == 0 && delta.y == 0){
                return
            }
//            print("DELTA x: \(delta.x), y: \(delta.y)")
            self.viewController!.gameController!.panCameraHelper.panCamera(SIMD2<Float>(x: Float(delta.x), y: Float(delta.y)))
//            chMove.panCamera(SIMD2<Float>(x: Float(delta.x), y: Float(delta.y)))
        }
        //super.mouseMoved(with: event)
    }

    override func mouseDown(with event: NSEvent) {
        guard let eventsDelegate = self.eventsDelegate, eventsDelegate.mouseDown(in: self, with: event) else {
            super.mouseDown(with: event)
            return
        }
//        super.mouseDown(with: event)
//        eventsDelegate.mouseDown(in: self, with: event)
        if(!(self.viewController?.gameController?.stateMachine.currentState is SuakeStateMainMenu /*|| self.viewController?.gameController?.stateMachine.currentState is SuakeStateMainSetup*/)){
            super.mouseDown(with: event)
        }else{
            super.mouseDown(with: event)
        }
    }

    override func mouseUp(with event: NSEvent) {
        guard let eventsDelegate = self.eventsDelegate, eventsDelegate.mouseUp(in: self, with: event) else {
            super.mouseUp(with: event)
            return
        }
//        if(!(self.viewController?.gameController?.stateMachine.currentState is SuakeStateMainMenu || self.viewController?.gameController?.stateMachine.currentState is SuakeStateMainSetup)){
//            super.mouseUp(with: event)
//        }
//        _ = eventsDelegate.mouseUp(in: self, with: event)
        super.mouseUp(with: event)
    }

    override func viewWillStartLiveResize() {
        super.viewWillStartLiveResize()
    }

    override func viewDidEndLiveResize() {
        if let game:GameController = self.viewController?.gameController{
            guard game.stateMachine.currentState is SuakeStatePlaying || game.stateMachine.currentState is SuakeStateReadyToPlay || game.stateMachine.currentState is SuakeStatePaused  else {
                return
            }
            game.gameWindowSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//            game.overlayManager.hud.reposHUDContent()
        }
    }

//    override func magnify(with event: NSEvent) {
//        if let game:GameController = self.viewController?.gameController{
//            if(game.overlayManager.hud.hudEntity.crosshairEntity.currentWeaponType == .sniperrifle){
//                if(!game.overlayManager.hud.hudEntity.crosshairEntity.sniperrifleCrosshairComponent.magnify(magnification: event.magnification)){
//                    return
//                }
//            }
//        }
//        super.magnify(with: event)
//    }
}
