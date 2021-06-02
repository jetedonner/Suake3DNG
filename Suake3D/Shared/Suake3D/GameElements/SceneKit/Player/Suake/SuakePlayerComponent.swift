//
//  SuakePlayerComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 12.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW


struct NewSuakePartComponentStruct {
    var nextSuakePart:SuakePart = .straightToStraight
    var newSuakeComponent:SuakePlayerNodeComponent!
}

class SuakePlayerComponent: SuakeBaseSCNNodeComponent {
    
    let playerType:SuakePlayerType
    
    var allSuakeComponents:[SuakePlayerNodeComponent]!
    var suakeStraight2StraightComponent:SuakePlayerNodeComponent!
    var suakeStraight2LeftComponent:SuakePlayerNodeComponent!
    var suakeStraight2RightComponent:SuakePlayerNodeComponent!
    var suakeLeft2StraightComponent:SuakePlayerNodeComponent!
    var suakeLeft2LeftComponent:SuakePlayerNodeComponent!
    var suakeLeft2RightComponent:SuakePlayerNodeComponent!
    var suakeRight2StraightComponent:SuakePlayerNodeComponent!
    var suakeRight2LeftComponent:SuakePlayerNodeComponent!
    var suakeRight2RightComponent:SuakePlayerNodeComponent!
    
    var _currentSuakeComponent:SuakePlayerNodeComponent!
    var currentSuakeComponent:SuakePlayerNodeComponent{
        get{ return self._currentSuakeComponent }
        set{
            for suakeComponent in self.allSuakeComponents{
                suakeComponent.node.isStopped = (suakeComponent != newValue)
                suakeComponent.node.isHidden = (suakeComponent != newValue)
            }
            self._currentSuakeComponent = newValue
        }
    }
    
    func getSuakePlayerNodeComponent(suakePart:SuakePart)->SuakePlayerNodeComponent{
        if let component = self.allSuakeComponents.first(where: { $0.suakePart == suakePart }) {
            return component
//            return self.allSuakeComponents[index]
        }else{
            return self.allSuakeComponents[0]
        }
    }
    
    public static func getNewSuakeParts(suakeEntity:SuakeOppPlayerEntity, newTurnDir:TurnDir, currentSuakePart:SuakePart)->NewSuakePartComponentStruct{
        
        var componentRet:NewSuakePartComponentStruct = NewSuakePartComponentStruct()
        
        if(currentSuakePart == .straightToRight && newTurnDir == .Right ||
            currentSuakePart == .rightToRight && newTurnDir == .Right ||
            currentSuakePart == .leftToRight && newTurnDir == .Right){
            componentRet.nextSuakePart = .rightToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2RightComponent// .component(ofType: SuakePlayerComponentRightToRight.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Left ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Left ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Left){
            componentRet.nextSuakePart = .leftToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2LeftComponent//.component(ofType: SuakePlayerComponentLeftToLeft.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Left ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Left ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Left){
            componentRet.nextSuakePart = .straightToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2LeftComponent//.component(ofType: SuakePlayerComponentStraightToLeft.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Right ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Right ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Right ){
            componentRet.nextSuakePart = .straightToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2RightComponent//.component(ofType: SuakePlayerComponentStraightToRight.self)!
        }else if(currentSuakePart == .straightToRight && newTurnDir == .Left ||
                    currentSuakePart == .leftToRight && newTurnDir == .Left ||
                    currentSuakePart == .rightToRight && newTurnDir == .Left){
            componentRet.nextSuakePart = .rightToLeft
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2LeftComponent//.component(ofType: SuakePlayerComponentRightToLeft.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Right ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Right ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Right){
            componentRet.nextSuakePart = .leftToRight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2RightComponent//.component(ofType: SuakePlayerComponentLeftToRight.self)!
        }else if(currentSuakePart == .rightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Straight){
            componentRet.nextSuakePart = .leftToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2StraightComponent//.component(ofType: SuakePlayerComponentLeftToStraight.self)!
        }else if(currentSuakePart == .leftToRight && newTurnDir == .Straight ||
                    currentSuakePart == .rightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .straightToRight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .rightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2StraightComponent//.component(ofType: SuakePlayerComponentRightToStraight.self)!
        }else if(currentSuakePart == .straightToStraight && newTurnDir == .Straight ||
                    currentSuakePart == .rightToStraight && newTurnDir == .Straight ||
                    currentSuakePart == .leftToStraight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .straightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeStraight2StraightComponent//.component(ofType: SuakePlayerComponentStraight.self)!
        }else if(currentSuakePart == .rightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .straightToRight && newTurnDir == .Straight ||
                    currentSuakePart == .leftToRight && newTurnDir == .Straight){
            componentRet.nextSuakePart = .rightToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeRight2StraightComponent//.component(ofType: SuakePlayerComponentRightToStraight.self)!
        }else if(currentSuakePart == .straightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .rightToLeft && newTurnDir == .Straight ||
                    currentSuakePart == .leftToLeft && newTurnDir == .Straight){
            componentRet.nextSuakePart = .leftToStraight
            componentRet.newSuakeComponent = suakeEntity.playerComponent.suakeLeft2StraightComponent//.component(ofType: SuakePlayerComponentLeftToStraight.self)!
        }
        return componentRet
    }
    
    func getNextSuakePlayerNodeComponent(turnDir:TurnDir)->SuakePlayerNodeComponent{
        let currentSuakePart = self.currentSuakeComponent.suakePart
        if(currentSuakePart == .straightToStraight && turnDir == .Left){
            return self.getSuakePlayerNodeComponent(suakePart: .straightToLeft)
        }/*else if(currentSuakePart == .rightToStraight && turnDir == .Right){
            return self.getSuakePlayerNodeComponent(suakePart: .straightToRight)
        }*/else if((currentSuakePart == .straightToLeft && turnDir == .Straight) ||
                 (currentSuakePart == .leftToLeft && turnDir == .Straight) ||
                    (currentSuakePart == .rightToLeft && turnDir == .Straight)){
            return self.getSuakePlayerNodeComponent(suakePart: .leftToStraight)
        }else if(currentSuakePart == .straightToLeft && turnDir == .Left ||
                    currentSuakePart == .leftToStraight && turnDir == .Left){
            return self.getSuakePlayerNodeComponent(suakePart: .leftToLeft)
        }else if(currentSuakePart == .leftToStraight && turnDir == .Straight ||
                currentSuakePart == .rightToStraight && turnDir == .Straight){
            return self.getSuakePlayerNodeComponent(suakePart: .straightToStraight)
        }else if(currentSuakePart == .straightToStraight && turnDir == .Right){
            return self.getSuakePlayerNodeComponent(suakePart: .straightToRight)
        }else if((currentSuakePart == .straightToRight && turnDir == .Straight) ||
                 (currentSuakePart == .rightToRight && turnDir == .Straight) ||
                    (currentSuakePart == .leftToRight && turnDir == .Straight)){
            return self.getSuakePlayerNodeComponent(suakePart: .rightToStraight)
        }else if(currentSuakePart == .straightToRight && turnDir == .Right ||
                currentSuakePart == .rightToStraight && turnDir == .Right){
            return self.getSuakePlayerNodeComponent(suakePart: .rightToRight)
        }else if(currentSuakePart == .straightToLeft && turnDir == .Right ||
                    currentSuakePart == .leftToStraight && turnDir == .Right){
            return self.getSuakePlayerNodeComponent(suakePart: .leftToRight)
        }else if(currentSuakePart == .straightToRight && turnDir == .Left ||
                currentSuakePart == .rightToStraight && turnDir == .Left){
            return self.getSuakePlayerNodeComponent(suakePart: .rightToLeft)
        }
        return self.getSuakePlayerNodeComponent(suakePart: .straightToStraight)
    }
    
    let mainNode:SuakeBaseSCNNode
    
    init(game: GameController, playerType:SuakePlayerType = .OwnSuake) {
        self.playerType = playerType
        let oppOwn:String = self.playerType == .OwnSuake ? "Own" : "Opp"
        self.mainNode = SuakeBaseSCNNode(game: game, name: "Suake \(oppOwn) MainNode")
        
        super.init(game: game, node: self.mainNode)
        
        self.suakeStraight2StraightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeStraightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Straight2Straight"), suakePart: .straightToStraight)
        
//        self.suakeStraight2StraightComponent.createBB()
        
        self.suakeStraight2LeftComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeStraightToLeftModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Straight2Left"), suakePart: .straightToLeft)
        
        self.suakeStraight2RightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeStraightToRightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Straight2Right"), suakePart: .straightToRight)
        
        self.suakeLeft2StraightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeLeftToStraightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Left2Straight"), suakePart: .leftToStraight)
        self.suakeLeft2StraightComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / -2)
        self.suakeLeft2StraightComponent.node.position.x = 150
        
        self.suakeLeft2LeftComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeLeftToLeftModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Left2Left"), suakePart: .leftToLeft)
        self.suakeLeft2LeftComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / -2)
        self.suakeLeft2LeftComponent.node.position.x = 150
        
        self.suakeLeft2RightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeLeftToRightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Left2Right"), suakePart: .leftToRight)
        self.suakeLeft2RightComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / -2)
        self.suakeLeft2RightComponent.node.position.x = 150
        
        self.suakeRight2StraightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeRightToStraightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Right2Straight"), suakePart: .rightToStraight)
        self.suakeRight2StraightComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / 2)
        self.suakeRight2StraightComponent.node.position.x = -150
        
        self.suakeRight2LeftComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeRightToLeftModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Right2Left"), suakePart: .rightToLeft)
        self.suakeRight2LeftComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / 2)
        self.suakeRight2LeftComponent.node.position.x = -150
        
        self.suakeRight2RightComponent = SuakePlayerNodeComponent(game: game, node: SuakeBaseAnimatedSCNNode(game: game, sceneName: ResVars.suakeRightToRightModelResFile, scale: SuakeVars.suakeScale, name: "Suake \(oppOwn) Right2Right"), suakePart: .rightToRight)
        self.suakeRight2RightComponent.node.rotation = SCNVector4Make(0, 1, 0, CGFloat.pi / 2)
        self.suakeRight2RightComponent.node.position.x = -150
        
        self.allSuakeComponents = [self.suakeStraight2StraightComponent, self.suakeStraight2LeftComponent, self.suakeStraight2RightComponent, self.suakeLeft2StraightComponent, self.suakeLeft2LeftComponent, self.suakeLeft2RightComponent, self.suakeRight2StraightComponent, self.suakeRight2LeftComponent, self.suakeRight2RightComponent]
        
        self.currentSuakeComponent = self.allSuakeComponents[0]
        self.currentSuakeComponent.isStopped = true
    }
    
//    override func update(deltaTime seconds: TimeInterval) {
////        self.moveComponent.update(deltaTime: seconds)
//    }
    
    func add2Scene(){
        self.game.physicsHelper.qeueNode2Add2Scene(node: self.mainNode)
    }
    
    func stopAnimationTMP(){
        self.currentSuakeComponent.isStopped = true
    }
    
    func startAnimationTMP(){
        self.currentSuakeComponent.isStopped = false
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        for suakeComponent in self.allSuakeComponents{
            self.mainNode.addChildNode(suakeComponent.node)
            self.entity?.addComponent(suakeComponent)
            suakeComponent.createBB()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
