//
//  GameViewControllerMacOS.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import SceneKit
import SpriteKit
//import QuartzCore
import Cocoa
//import GameKit
//import Network

//extension GameViewControllerMacOS {
//  func setUpPath() {
//    openPath.move(to: CGPoint(x: 30, y: 196))
//
//    openPath.curve(
//      to: CGPoint(x: 112.0, y: 12.5),
//      controlPoint1: CGPoint(x: 110.56, y: 13.79),
//      controlPoint2: CGPoint(x: 112.07, y: 13.01))
//
//    openPath.curve(
//      to: CGPoint(x: 194, y: 196),
//      controlPoint1: CGPoint(x: 111.9, y: 11.81),
//      controlPoint2: CGPoint(x: 194, y: 196))
//
//    openPath.line(to: CGPoint(x: 30.0, y: 85.68))
//    openPath.line(to: CGPoint(x: 194.0, y: 48.91))
//    openPath.line(to: CGPoint(x: 30, y: 196))
//  }
//
//  func setUpShapeLayer() {
//    // 1
//    shapeLayer.path = openPath.cgPath
//
//    // 2
//    shapeLayer.lineCap = .butt
//    shapeLayer.lineJoin = .miter
//    shapeLayer.miterLimit = 4.0
//
//    // 3
//    shapeLayer.lineWidth = 2.0 //CGFloat(lineWidthSlider.value)
//    shapeLayer.strokeColor = NSColor.orange.cgColor
//    shapeLayer.fillColor = NSColor.white.cgColor
//
//    // 4
//    shapeLayer.lineDashPattern = nil
//    shapeLayer.lineDashPhase = 0.0
//
//    viewForShapeLayer.layer!.addSublayer(shapeLayer)
//  }
//}

//@available(OSX 10.14, *)
class GameViewControllerMacOS: NSViewController, KeyboardAndMouseEventsDelegate, NSWindowDelegate {
    
    @IBOutlet weak var viewForShapeLayer: NSView!

//    enum LineCap: Int {
//      case butt, round, square, cap
//    }
//    enum LineJoin: Int {
//      case miter, round, bevel
//    }

//    var fadeView:FadeViewAfterDeath!

    let shapeLayer = CAShapeLayer()
    var color = NSColor.orange
    let openPath = NSBezierPath()
    let closedPath = NSBezierPath()
    
    var gameController: GameController?
//    var windowDelegate: GameViewControllerWindowDelegate!
    
    var gameView: GameViewMacOS? {
        guard let gameView = view as? GameViewMacOS else {
            fatalError("Expected \(GameViewMacOS.self) from Main.storyboard.")
        }
        //gameView.window!.acceptsMouseMovedEvents = false
        gameView.viewController = self
        gameView.eventsDelegate = self
        return gameView
    }

    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.wantsLayer = true
//        self.gameController?.overlayManager.hud.hudEntity.crosshairEntity.redeemerCrosshairComponent.redeemerCrosshairView.generate(daView: self.view)
    }
    
    override func viewWillDisappear() {
        gameView?.stop(nil)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window!.delegate = self
        self.view.window!.acceptsMouseMovedEvents = false
        // You need to add this following code while authenticating or in desired scenario...
//        GKAccessPoint.shared.location = .topLeading     // Sets the position of the icon
//        GKAccessPoint.shared.showHighlights = true      // Shows the notifications
//        GKAccessPoint.shared.isActive = true            // Enables the icon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView!.viewController = self
//        self.gameController?.playerEntityManager.getOwnPlayerEntity().wormHoleHelper.newScene = SCNScene(named: "WormHoleScene")!
//        self.gameController?.playerEntityManager.getOppPlayerEntity()!.wormHoleHelper.newScene = SCNScene(named: "WormHoleScene")!
//
//        fadeView = FadeViewAfterDeath(gameView: gameView!)
    }
    
    func registerGameCenterHelper(){
        GameCenterHelper.helper.viewController = self
    }
//
    func restartGameController(){
        if(self.gameController != nil){
//            _ = self.gameController?.stateMachine.enter(stateClass: SuakeStateGameLoading.self, saveOldState: false)
            self.gameController?.scnView.overlaySKScene = nil
            self.gameController?.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }

            self.gameView!.antialiasingMode = .none
            var strongScnView:GameViewMacOS! = self.gameView!
            self.gameController?.scnView = nil
//            wself.gameController = nil
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                strongScnView.scene = nil
                strongScnView.stop(nil)
                strongScnView = nil
                self.initGameController(reload: true)
            })
        }
    }
    
    func initGameController(reload:Bool = false){
        
        var frame = self.view.window?.frame
//        if(DbgVars.devMode){
//            frame!.size = DbgVars.initialWindowSize
//        }else{
            frame!.size = NSSize(width: 1280, height: 800)
//        }
        
        self.view.window?.setFrame(frame!, display: true)
        self.view.window?.center()
        //CORRECT AFTER TEST
        
        self.gameController = GameController(scnView: self.gameView!)
        self.gameController!.gameWindowSize = CGSize(width: frame!.size.width, height: frame!.size.height)
        
        self.gameView!.backgroundColor = NSColor.black
    }
    
    func keyDown(_ view: NSView, event theEvent: NSEvent) -> Bool {
        if(!(theEvent.keyCode == KeyboardDirection.KEY_Q.rawValue && theEvent.modifierFlags.contains(.command))){
            self.gameController!.keyboardHandler.keyPressedEvent(event: theEvent)
        }
        return true
    }

    func keyUp(_ view: NSView, event theEvent: NSEvent) -> Bool {
        return false
    }

    func mouseUp(in view: NSView, with event: NSEvent) -> Bool {
//        return true
        if((self.gameController!.stateMachine.currentState is SuakeStatePlaying ||
            self.gameController!.stateMachine.currentState is SuakeStateReadyToPlay) &&
            self.gameController!.playerEntityManager.ownPlayerEntity.isShooting){
            self.gameController!.playerEntityManager.ownPlayerEntity.finishShooting()
        }/*else{
            return (self.gameController?.overlayManager.mouseUpHandler(in: view, with: event))!
        }*/
        return true
    }

    func mouseDown(in view: NSView, with event: NSEvent) -> Bool {
        if(event.locationInWindow.y > SuakeVars.dbgBarHeight){
            if(self.gameController!.keyboardHandler.pressAnyKeyHandler.handleAnyKeyPress(pressedKey: KeyboardDirection.KEY_NONE)){
                return true
            }
            if(self.gameController!.stateMachine.currentState is SuakeStatePlaying ||
                self.gameController!.stateMachine.currentState is SuakeStateReadyToPlay){
                self.gameController!.playerEntityManager.ownPlayerEntity.startShooting()
            }else{
                
    //        if(DbgVars.clickShotEnabled && event.locationInWindow.y > DbgVars.dbgBarHeight){
                return (self.gameController?.overlayManager.mouseDownHandler(in: view, with: event))!
            }
        }else{
            super.mouseDown(with: event)
            return true
        }
        return true
    }

    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
        if event.keyCode == KeyboardDirection.KEY_CAPS_LOCK.rawValue {
            if event.modifierFlags.rawValue & NSEvent.ModifierFlags.capsLock.rawValue != 0 {
                gameController?.keyboardHandler.capsLockChanged(on: true)
            } else {
                gameController?.keyboardHandler.capsLockChanged(on: false)
            }
        }else if event.keyCode == KeyboardDirection.KEY_SHIFT.rawValue {
//            return
//            if event.modifierFlags.rawValue & NSEvent.ModifierFlags.shift.rawValue != 0 {
//                print("SHIFT pressed")
//                self.gameController?.playerEntityManager.ownPlayerEntity.autoAimAndShootOwnAt(entity: (self.gameController?.playerEntityManager.droidEntities[0])!, aimDur: 0.5)
//            }else{
//                print("SHIFT released")
//            }
        }
    }
    
//    #==================================================================#
//    | NOT NEEDED IN macOS -> Maybe later on when getting ready for iOS
//    |
//    | override func touchesBegan(with event: NSEvent) {
//    |    self.gameController?.showDbgMsg(dbgMsg: "TOUCH BEGAN")
//    |    super.touchesBegan(with: event)
//    | }
//    |
//    | override func touchesEnded(with event: NSEvent) {
//    |    self.gameController?.showDbgMsg(dbgMsg: "TOUCH ENDED")
//    |    super.touchesEnded(with: event)
//    | }
//    #==================================================================#
    
}
