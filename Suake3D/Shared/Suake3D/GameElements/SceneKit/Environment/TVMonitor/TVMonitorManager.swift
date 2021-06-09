//
//  TVMonitorManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.05.21.
//

import Foundation
import SceneKit
import SpriteKit
import AVFoundation

class TVMonitorManager: EntityManager {
    
    var tvMonEnt:[TVMonitorEntity] = [TVMonitorEntity]()
    var tvMontSphereEnt:TVMonitorSphereEntity!
    
    let videoURL: NSURL = Bundle.main.url(forResource: "art.scnassets/videos/tvnoise", withExtension: "mp4")! as NSURL
    let player:AVPlayer
    
//    let newScnView:SCNView
    let tvScreenMat:SCNMaterial = SCNMaterial()
    let tvScreenSphereMat:SCNMaterial = SCNMaterial()
    
    var _tvViewPlayerType:SuakePlayerType = .OwnSuake
    var tvViewPlayerType:SuakePlayerType{
        get{ return self._tvViewPlayerType }
        set{
            self._tvViewPlayerType = newValue
            if(newValue == .OwnSuake){
                self.renderer?.pointOfView = self.game.cameraHelper.cameraNodeFP
            }else{
                self.renderer?.pointOfView = self.game.cameraHelper.cameraNodeFPOpp
            }
        }
    }
    
    private var _showNoise:Bool = true
    var showNoise:Bool{
        get{ return self._showNoise }
        set{
            self._showNoise = newValue
            self.setTVMonitorImage(tvNoise: newValue)
        }
    }

    let spriteKitScene:SKScene
    let videoSpriteKitNode:SKVideoNode
    
    override init(game: GameController) {
        self.player = AVPlayer(url: videoURL as URL)
//        self.newScnView = game.overlayView
//        self.newScnView.pointOfView = game.cameraHelper.cameraNodeFP
        
        
        self.spriteKitScene = SKScene(size: CGSize(width: 1920, height: 1080))
        spriteKitScene.backgroundColor = .clear
        spriteKitScene.scaleMode = .aspectFit
        
        self.videoSpriteKitNode = SKVideoNode(avPlayer: self.player)
        videoSpriteKitNode.anchorPoint = CGPoint(x: 0, y: 0)
        videoSpriteKitNode.size.width = spriteKitScene.size.width
        videoSpriteKitNode.size.height = spriteKitScene.size.height

        spriteKitScene.addChild(videoSpriteKitNode)

//        planeGeo!.firstMaterial.diffuse.contents = spriteKitScene
//        videoSpriteKitNode.play()
        
        
        self.tvMontSphereEnt = TVMonitorSphereEntity(game: game, id: 0)
        super.init(game: game)
        
        self.tvScreenMat.lightingModel = .constant
        self.tvScreenSphereMat.lightingModel = .constant
        self.renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: nil)
        self.renderer?.scene = self.game.scene
        self.renderer?.autoenablesDefaultLighting = true
        
        self.renderer?.pointOfView = self.game.cameraHelper.cameraNodeFP
//        self.renderer?.pointOfView?.camera?.wantsHDR = false
        self.setupTVNoiseLoop()
    }
    
    func setupTVNoiseLoop(){
        self.player.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: self.player.currentItem)
    }
    
    func initTVMonitors(count:Int = 4) {
        
        let levelSize:CGSize = self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize()
        for i in 0..<count{
            self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: i))
        }
//        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 0))
//        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 1))
//        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 2))
//        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 3))
        
        self.tvMonEnt[0].showTVMonitor(pos: SCNVector3(0, 1, levelSize.height / 2))
        self.tvMonEnt[0].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[1].showTVMonitor(pos: SCNVector3(0, 1, (levelSize.height / -2) - 1))
        self.tvMonEnt[1].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[2].showTVMonitor(pos: SCNVector3(levelSize.width / 2, 1, 0))
        self.tvMonEnt[2].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[3].showTVMonitor(pos: SCNVector3((levelSize.width / -2) - 1, 1, 0))
        self.tvMonEnt[3].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        
        self.tvMontSphereEnt.showTVMonitor(pos: SCNVector3(0, 2, 0))
        self.tvMontSphereEnt.tvMonitorSphereComponent.tvMonitorSphereScreen.geometry?.firstMaterial? = self.tvScreenSphereMat
    }
    
    func setTVMonitorImage(tvNoise:Bool = false){
        if(tvNoise){
            if(!self.player.isPlaying){
                self.player.play()
            }
//            if(!self.videoSpriteKitNode){
//                self.videoSpriteKitNode.play()
//            }
            self.setTVMonitorImage(texture: self.spriteKitScene) // self.player)
        }else{
            self.player.pause()
            self.startTVMonitorUpdate()
        }
    }
    
    func setTVMonitorImage(texture:Any?){
        self.tvScreenMat.diffuse.contents = texture
        self.tvScreenSphereMat.diffuse.contents = texture
    }
    
//    var renderTime = TimeInterval(0)
    var renderer : SCNRenderer?
    
    func startTVMonitorUpdate(){
//        Timer.scheduledTimer(withTimeInterval: 0.016667, repeats: false, block: {_ in
            
//        })
        DispatchQueue.global(qos: .userInteractive).async {
            
//        })
//            DispatchQueue.main.async(execute: {
            
            let image = self.renderer!.snapshot(atTime: self.game.physicsHelper.currentTime, with: self.game.gameWindowSize, antialiasingMode: SCNAntialiasingMode.multisampling4X)
            
            self.tvScreenMat.diffuse.contents = image.imageRotatedByDegreess(degrees: CGFloat(-90))
            self.tvScreenSphereMat.diffuse.contents = image
//            self.tvScreenMat.lightingModel = .constant
//            self.tvScreenMat.shininess = 0.1
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.024, execute: {
                self.setTVMonitorImage(tvNoise: self.showNoise)
    //            })
            })
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}
