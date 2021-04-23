//
//  SuakeBaseSCNNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseSCNNode: SCNNode {
    
    var game:GameController!
    let cloneNode:SCNNode = SCNNode()
    
    override init() {
        super.init()
    }
    
    init(game:GameController, name:String = "") {
        self.game = game
        super.init()
        self.name = name
    }
    
    init(game:GameController, sceneName:String, scale:SCNVector3 = SCNVector3(1.0, 1.0, 1.0), name:String = "") {
        self.game = game
        super.init()
        self.name = name
        if(sceneName != ""){
            self.loadSceneContent(sceneName: sceneName, scale: scale)
        }
    }
    
    func loadSceneContent(sceneName:String, scale:SCNVector3 = SCNVector3(1.0, 1.0, 1.0)){
        
        self.game.showDbgMsg(dbgMsg: "loadSceneContent(" + sceneName + ")", dbgLevel: .Verbose)
        for i in (0..<self.childNodes.count){
            self.childNodes[i].removeFromParentNode()
        }
        
        let scene:SCNScene = SCNScene(named: sceneName)!
        let nodeArray = scene.rootNode.childNodes
        for childNode in nodeArray {
            let childNode1 = (scene.rootNode.childNode(withName: childNode.name!, recursively: true))!
            self.addNode2Clone(node: childNode1)
        }
        self.addChildNode(self.cloneNode)
        self.scale = scale
    }
    
    func addNode2Clone(node:SCNNode){
        self.cloneNode.addChildNode(node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
