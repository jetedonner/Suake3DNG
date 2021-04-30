//
//  SuakeBaseAnimatedSCNNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseAnimatedSCNNode: SuakeBaseSCNNode {
    
    var animationKey:String?
    var animationNode:SCNNode?
    var animation:SCNAnimationPlayer?
    var animationCopy:SCNAnimationPlayer?
    
    var _isStopped:Bool = false
    var isStopped:Bool{
        get{
            return self._isStopped
        }
        set{
            self._isStopped = newValue
            if(self.isStopped){
                self.removeAnimationFromNode()
            }else{
                self.addAnimation2Node()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    override init(game: GameController, sceneName: String, scale: SCNVector3 = SCNVector3(1.0, 1.0, 1.0), name:String = "") {
        super.init(game: game, sceneName: sceneName, scale: scale, name: name)
        self.name = name
    }
    
    override func addNode2Clone(node: SCNNode) {
        super.addNode2Clone(node: node)
        if self.animation == nil && node.animationKeys.count > 0 {
            let animKey = node.animationKeys[0]
            self.animationKey = animKey
            self.animationNode = node
            self.animation = node.animationPlayer(forKey: animKey)
            self.animationCopy = self.animation?.copy() as? SCNAnimationPlayer
//            self.animation?.animation.isRemovedOnCompletion = true
            self.animation?.animation.isAppliedOnCompletion = true
            
//            let animationDidStop: SCNAnimationDidStopBlock = {animation, animatable, finished in
////                self.removeAnimationFromNode()
////                if(!self.isStopped){
////                    self.addAnimation2Node()
////                }
//            }
            self.animation?.animation.repeatCount = 1
//            self.animation?.animation.animationDidStop = animationDidStop
        }
    }
    
    func addAnimation2Node(){
        self.animationNode?.addAnimationPlayer(self.animationCopy!, forKey: self.animationKey)
    }
    
    func removeAnimationFromNode(){
        self.animationNode?.removeAllAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
