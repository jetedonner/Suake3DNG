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
import AVFoundation

class BaseGameController:NSObject{
    
    let scene:SCNScene
    var scnView:SCNView!
    let floorNode:SCNNode
    
    var gameWindowSize:CGSize = CGSize(width: 1280, height: 800)
    
    let overlayView = SCNView()
    
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
        
//        var playerLayer: AVPlayer?

        
        
        overlayView.scene = self.scene
        overlayView.frame = CGRect(x: 320, y: 240, width: 640, height: 480)
        overlayView.alphaValue = 0.0
//        self.scnView.addSubview(overlayView)
        
//        let videoURL: NSURL = Bundle.main.url(forResource: "art.scnassets/videos/MediaExample", withExtension: "mp4")! as NSURL
//        let player = AVPlayer(url: videoURL as URL)
////        player.isMuted = true
//          
//        
////        let tvPlane:SCNPlane = SCNPlane(width: 640, height: 480)
//        self.tvNode = SCNNode(geometry: tvPlane)
//        tvNode.geometry?.firstMaterial?.isDoubleSided = true
////        tvNode.geometry?.firstMaterial?.diffuse.contents = player// NSColor.red
//        tvNode.eulerAngles.x = CGFloat.pi
//        tvNode.position = SCNVector3(320, 100 + 240, 100)
//        self.scene.rootNode.addChildNode(tvNode)
//        player.play()
        self.floorNode = (self.scene.rootNode.childNode(withName: "floor", recursively: true))!
        
        self.floorNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.floorNode.geometry!, options: nil))
        self.floorNode.physicsBody?.allowsResting = true
        self.floorNode.physicsBody?.categoryBitMask = CollisionCategory.floor.rawValue
//        self.floorNode.physicsBody?.categoryBitMask = CollisionCategory.floor.rawValue
        self.floorNode.physicsBody?.collisionBitMask = CollisionCategory.container.rawValue | CollisionCategory.generator.rawValue
//        self.floorNode.physicsBody?.con
        super.init()
        
        scnView.scene = self.scene

        scnView.scene?.physicsWorld.gravity = SCNVector3(0, -9.8, 0)
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
