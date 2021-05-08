//
//  TVMonitorManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.05.21.
//

import Foundation
import SceneKit
import AVFoundation

class TVMonitorManager: EntityManager {
    
    var tvMonEnt:[TVMonitorEntity] = [TVMonitorEntity]()
    let videoURL: NSURL = Bundle.main.url(forResource: "art.scnassets/videos/tvnoise", withExtension: "mp4")! as NSURL
    let player:AVPlayer
    
    let newScnView:SCNView
    let tvScreenMat:SCNMaterial = SCNMaterial()
    
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
        self.newScnView = game.overlayView
        self.newScnView.pointOfView = game.cameraHelper.cameraNodeFP
        super.init(game: game)
        
        self.renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: nil)
        self.renderer?.scene = self.game.scene
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
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 0))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 1))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 2))
        self.tvMonEnt.append(TVMonitorEntity(game: self.game, id: 3))
        self.tvMonEnt[0].showTVMonitor(pos: SCNVector3(0, 1, 10))
        self.tvMonEnt[0].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[1].showTVMonitor(pos: SCNVector3(0, 1, -10))
        self.tvMonEnt[1].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[2].showTVMonitor(pos: SCNVector3(10, 1, 0))
        self.tvMonEnt[2].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
        self.tvMonEnt[3].showTVMonitor(pos: SCNVector3(-10, 1, 0))
        self.tvMonEnt[3].tvMonitorComponent.tvMonitorScreen.geometry?.firstMaterial? = self.tvScreenMat
    }
    
    func setTVMonitorImage(tvNoise:Bool = false){
        if(tvNoise){
            if(!self.player.isPlaying){
                self.player.play()
            }
            self.setTVMonitorImage(texture: self.player)
        }else{
            self.player.pause()
            self.startTVMonitorUpdate()
        }
    }
    
    func setTVMonitorImage(texture:Any?){
        self.tvScreenMat.diffuse.contents = texture
    }
    
    var renderTime = TimeInterval(0)
    var renderer : SCNRenderer?
    
    func startTVMonitorUpdate(){
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
            
//        })
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02, execute: {
            
            let image = self.game.rndrr.snapshot(atTime: self.game.physicsHelper.currentTime, with: self.game.gameWindowSize, antialiasingMode: SCNAntialiasingMode.multisampling4X)
            
            self.tvScreenMat.diffuse.contents = image.imageRotatedByDegreess(degrees: CGFloat(-90))
            self.setTVMonitorImage(tvNoise: self.showNoise)
        })
    }
    
//    func saveImg(img:NSImage) {
//        let context = CIContext()
//        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//        guard
//            let filter = CIFilter(name: "CISepiaTone"),
//            let imageURL = Bundle.main.url(forResource: "my-image-\(DispatchTime.now())", withExtension: "png"),
//            let ciImage = CIImage(contentsOf: imageURL)
//        else { return }
//
//        filter.setValue(ciImage, forKey: kCIInputImageKey)
//        filter.setValue(0.5, forKey: kCIInputIntensityKey)
//
//        guard let result = filter.outputImage, let cgImage = context.createCGImage(result, from: result.extent)
//        else { return }
//
//        let destinationURL = desktopURL.appendingPathComponent("my-image-\(DispatchTime.now()).png")
//        let nsImage = NSImage(cgImage: cgImage, size: ciImage.extent.size)
//        if nsImage.pngWrite(to: destinationURL, options: .withoutOverwriting) {
//            print("File saved")
//        }
//    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}
