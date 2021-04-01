//
//  SuakeBaseAnimatedSCNNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseMultiAnimatedSCNNode: SuakeBaseSCNNode {
    
    var animRunning:[Bool] = [Bool]()
    var animNames:[String] = []
    var animNodes:[SCNNode] = [SCNNode]()
    var animNodesOrig:[SCNNode] = [SCNNode]()
    var animOrigs:[SCNAnimation] = [SCNAnimation]()

    init(game: GameController, sceneName: String, scale: SCNVector3 = SCNVector3(1, 1, 1), animNames: [String] = [], name:String) {
        self.animNames = animNames
        
        super.init(game: game, sceneName: sceneName, scale: scale, name: name)
        
        for anim in self.animNames{
            _ = self.setAnimPlayer(nodeToSet: self, nodeToCheck: self, name: name, animName: anim, topNode: self)
        }
        self.stopAnimAndReset()
    }
    
//    override init(game: GameController, sceneName: String, scale: SCNVector3 = SCNVector3(1, 1, 1), animName: String = "", nodeName:String) {
////        self.animName = animName
////        self.animPlayer = animName
////
////        self.animNameNG = "unnamed_animation__1_Head"
////        self.animPlayerNG = "unnamed_animation__1_Head"
//
//        super.init(game: game, sceneName: sceneName, scale: scale, animName: animName, nodeName: nodeName)
//
//        _ = self.setAnimPlayer(nodeToSet: self, nodeToCheck: self, nodeName: nodeName, animName: animName, topNode: self)
//        self.stopAnimAndReset()
//    }
    
    func setAnimPlayer(nodeToSet:SCNNode, nodeToCheck:SCNNode, name:String, animName:String, topNode:SCNNode)->Bool{
        var idx:Int = 0
        for i in (0..<nodeToCheck.animationKeys.count) {
            let key:String = nodeToCheck.animationKeys[i]
            let keyNew:String = key
            if(idx == 0){
                idx += 1
                self.animRunning.append(false)
                self.animNodes.append(nodeToCheck)
                self.animNodesOrig.append(nodeToCheck)
                let tmpPlayer:SCNAnimation = nodeToCheck.animationPlayer(forKey: key)?.animation.copy(with: nil) as! SCNAnimation
                nodeToCheck.removeAllAnimations()
                nodeToSet.removeAllAnimations()
                nodeToSet.removeAnimation(forKey: key)
                self.animOrigs.append(tmpPlayer.copy() as! SCNAnimation)
                nodeToCheck.addAnimation(tmpPlayer, forKey: keyNew)
                nodeToSet.addAnimation(tmpPlayer, forKey: keyNew)
            }
        }
        
        for i in (0..<nodeToCheck.childNodes.count) {
            if(setAnimPlayer(nodeToSet:nodeToSet.childNodes[i], nodeToCheck: nodeToCheck.childNodes[i], name: name, animName: animName, topNode: topNode)){
                return true
            }
        }
        return false
    }
    
    func animation()->SCNAnimation{
        return animationPlayer().animation
    }
    
    func animationPlayer(id:Int = 0)->SCNAnimationPlayer{
        return animNodes[id].animationPlayer(forKey: animNames[id])!
    }
    
    func playAnim(){
        self.isPaused = false
        animationPlayer().play()
    }
    
    func stopAnim(){
        animationPlayer().stop()
    }
    
    func stopAnimAndReset(){
        self.removeAnimEvts()
        self.animationPlayer().stop()
        self.animation().timeOffset = 0.0
    }
    
    func stopAnimation(){
        animationPlayer().stop()
    }
    
    func toggleAnimation(newAnimState:Bool, id:Int = 0){
        self.animRunning[id] = newAnimState
        if(getAnimPlayer() != nil){
            if(newAnimState){
                getAnimPlayer()!.play()
            }else{
                getAnimPlayer()!.stop()
            }
        }
    }
    
    func getAnimPlayer(id:Int = 0)->SCNAnimationPlayer?{
        if(self.animNames[id] != ""){
            if((self.childNode(withName: self.animNodes[id].name!, recursively: true)?.animationKeys.contains(self.animNames[id]))!){
                return (self.childNode(withName: self.animNodes[id].name!, recursively: true)?.animationPlayer(forKey: self.animNames[id]))!
            }
        }
        return nil
    }
    
    func setAnimEvts(completitionHandler block: (() -> Void)? = nil){
        let animationEvt: SCNAnimationEventBlock = { animation, animatedObject, playingBackwards in
            self.removeAnimEvts()
            self.getAnimPlayer()?.stop()
            if(block != nil){
                block!()
            }
        }
        self.getAnimPlayer()?.animation.animationEvents = [SCNAnimationEvent(keyTime: 0.99, block: animationEvt)]
    }
    
    func setAnimDidStop(completitionHandler block: (() -> Void)? = nil){
        let animationDidStop: SCNAnimationDidStopBlock = {animation, animatable, finished in
              if(block != nil){
                  block!()
              }
        }
        self.getAnimPlayer()?.animation.animationDidStop = animationDidStop
    }
    
    func resetAllAnims(id:Int = 0){
        self.animNodes[id].removeAllAnimations()
        self.animNodes[id].addAnimation((self.animOrigs[id].copy() as? SCNAnimation)!, forKey: self.animNames[id])
        self.stopAnimation()
    }
    
    func removeAnimEvts(){
        self.getAnimPlayer()?.animation.animationEvents?.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
