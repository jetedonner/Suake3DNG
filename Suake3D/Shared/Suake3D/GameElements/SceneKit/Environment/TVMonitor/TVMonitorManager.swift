//
//  TVMonitorManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.05.21.
//

import Foundation
import SceneKit
import NetTestFW
import AVFoundation

class TVMonitorManager: EntityManager {
    
    var tvMonEnt:[TVMonitorEntity] = [TVMonitorEntity]()
//    var tvNoise:NSImage = NSImage(named: NSImage.Name.greenPlasma)
    let videoURL: NSURL = Bundle.main.url(forResource: "art.scnassets/videos/tvnoise", withExtension: "mp4")! as NSURL
    let player:AVPlayer
    
    private var _showNoise:Bool = true
    var showNoise:Bool{
        get{ return self._showNoise }
        set{
            self._showNoise = newValue
            self.setTVMonitorImage(tvNoise: newValue)
        }
    }
    
    override init(game: GameController) {
        self.player = AVPlayer(url: videoURL as URL)
        super.init(game: game)
        
        self.player.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: self.player.currentItem)
//        self.player.
    }
    
    func initTVMonitors(count:Int = 4) {
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 0))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 1))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 2))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 3))
        self.tvMonEnt[0].showTVMonitor(pos: SCNVector3(0, 1, 10))
        self.tvMonEnt[1].showTVMonitor(pos: SCNVector3(0, 1, -10))
        self.tvMonEnt[2].showTVMonitor(pos: SCNVector3(10, 1, 0))
        self.tvMonEnt[3].showTVMonitor(pos: SCNVector3(-10, 1, 0))
    }
    
    func setTVMonitorImage(tvNoise:Bool = false){
        if(tvNoise){
            self.player.play()
            self.setTVMonitorImage(texture: self.player)
        }else{
//            self.setTVMonitorImage(texture: self.player)
            self.startTVMonitorUpdate()
        }
    }
    
    func setTVMonitorImage(texture:Any?){
        self.tvMonEnt[0].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = texture
        self.tvMonEnt[1].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = texture
        self.tvMonEnt[2].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = texture
        self.tvMonEnt[3].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = texture
    }
    
    
    func startTVMonitorUpdate(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (1.0 * 0.024), execute: {
            let newScnView = self.game.overlayView
            newScnView.pointOfView = self.game.cameraHelper.cameraNodeFP
            let screenshot:NSImage = newScnView.snapshot().imageRotatedByDegreess(degrees: CGFloat(-90))
//                print("TV-UpdateTime: \(time)")
            self.tvMonEnt[0].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
            self.tvMonEnt[1].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
            self.tvMonEnt[2].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
            self.tvMonEnt[3].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial?.diffuse.contents = screenshot
            self.setTVMonitorImage(tvNoise: self.showNoise)
        })
//        if(self.deltaTime.truncatingRemainder(dividingBy: 0.25) == 0){
//            DispatchQueue.main.async {
//
//            }
//        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}
