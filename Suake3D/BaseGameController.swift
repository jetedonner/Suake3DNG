//
//  GameViewController.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import SceneKit
//import QuartzCore
import GameplayKit

class BaseGameController:NSObject{
    
    let scene:SCNScene
    var scnView:SCNView!
    let floorNode:SCNNode
    
    var gameWindowSize:CGSize = CGSize(width: 1280, height: 800)
    
    init(scnView: SCNView) {
        self.scnView = scnView
        
        var frame = self.scnView.window?.frame
        
//        if(DbgVars.devMode){
//            frame!.size = DbgVars.initialWindowSize
//        }else{
            frame!.size = NSSize(width: 1280, height: 800)
//        }
        self.scnView.window?.setFrame(frame!, display: true)
        self.scnView.window?.center()
        self.gameWindowSize = CGSize(width: frame!.size.width, height: frame!.size.height)
        
        self.scene = SCNScene(named: "art.scnassets/scenes/gamescene.scn")! //Landscape.scn")! //gamescene.scn")!
        self.floorNode = (self.scene.rootNode.childNode(withName: "floor", recursively: true))!
        
        self.floorNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.floorNode.geometry!, options: nil))
        self.floorNode.physicsBody?.allowsResting = true
        self.floorNode.physicsBody?.categoryBitMask = CollisionCategory.floor.rawValue
//        self.floorNode.physicsBody?.categoryBitMask = CollisionCategory.floor.rawValue
        self.floorNode.physicsBody?.collisionBitMask = CollisionCategory.container.rawValue
//        self.floorNode.physicsBody?.con
        super.init()
        
        scnView.scene = scene

        scnView.audioEnvironmentNode.distanceAttenuationParameters.maximumDistance = 2
        scnView.audioEnvironmentNode.distanceAttenuationParameters.referenceDistance = 0.1
        scnView.audioEnvironmentNode.renderingAlgorithm = .sphericalHead
        scnView.audioEnvironmentNode.reverbBlend = 0.5
        
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
    }
    
    func quitSuake3D(){
        self.scene.isPaused = true
        self.scnView.isPlaying = false
        NSApplication.shared.terminate(self)
//        let appDelegate = NSApplication.shared.delegate as! AppDelegate
//        appDelegate.terminate()
    }
}
