//
//  SuakeBaseNodeEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class SuakeBaseNodeEntity: SuakeBaseEntity {
    
    var suakeField:SuakeFieldType = .empty
    
    func setFieldType(playerType:SuakePlayerType){
        switch playerType {
        case .Droid:
            self.suakeField = .droid
        case .OwnSuake:
            self.suakeField = .own_suake
        case .OppSuake:
            self.suakeField = .opp_suake
        case .Goody:
            self.suakeField = .goody
        default:
            self.suakeField = .empty
        }
    }
    
    var _isPaused:Bool = true
    var isPaused:Bool{
        get{ return self._isPaused }
        set{
            self._isPaused = newValue
//            let scnNodeComponents:[SuakeBaseSCNNodeComponent] = self.components(conformingTo: SuakeBaseSCNNodeComponent.self)
//            for i in (0..<scnNodeComponents.count){
//                scnNodeComponents[i].node.isPaused = newValue
//            }
        }
    }
    
    var _oldPos:SCNVector3 = SCNVector3(0, 0, 0)
    var oldPos:SCNVector3{
        get{ return self._oldPos }
        set{ self._oldPos = newValue }
    }
            
    var _pos:SCNVector3 = SCNVector3(0, 0, 0)
    var pos:SCNVector3{
        get{ return self._pos }
        set{
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: .empty, overrideOrig: (self.game.stateMachine.currentState is SuakeStateReadyToPlay ? true : false))
            self.oldPos = self.pos
            self._pos = newValue
            self.reposMapNodeInit()
//            self.game.levelManager.gameBoard.setGameBoardField(pos: self.pos, suakeField: self.suakeField)
//            let scnNodeComponents:[SuakeBaseSCNNodeComponent] = self.components(conformingTo: SuakeBaseSCNNodeComponent.self)
//            for i in (0..<scnNodeComponents.count){
//                if( !scnNodeComponents[i].isKind(of: SuakeLightComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: SuakePlayerFollowCameraFPComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: RisingParticlesComponent.self) &&
//                    !scnNodeComponents[i].isKind(of: MedKitRisingParticlesComponent.self)){
//
//                    if(!scnNodeComponents[i].isKind(of: SuakeBaseSuakePlayerComponent.self)){
//                        scnNodeComponents[i].node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
//                    }/*else if(!scnNodeComponents[i].isKind(of: BaseWeaponPickupComponent.self)){
//                        scnNodeComponents[i].node.position = SCNVector3(self._pos.x * SuakeVars.fieldSize, self._pos.y, self._pos.z * SuakeVars.fieldSize)
//                    }*/
//                }
//            }
        }
    }
    
    var _dir:SuakeDir = .UP
    var dir:SuakeDir{
        get{ return self._dir }
        set{
            self._dir = newValue
            self.rotateMapNodeInit()
        }
    }
    
    var _dirOld:SuakeDir = .UP
    var dirOld:SuakeDir{
       get{ return self._dirOld }
       set{
            self._dirOld = newValue
       }
    }
    
    var position:SCNVector3{
        get{ return SCNVector3(self._pos.x * SuakeVars.fieldSize, 0 /*self._pos.y * SuakeVars.fieldSize*/, self._pos.z * SuakeVars.fieldSize) }
    }
    
    var _mapNode:SuakeSpriteNode? = nil
    var mapNode:SuakeSpriteNode?{
        get{ return self._mapNode }
        set{ self._mapNode = newValue }
    }
    
    func reposMapNodeInit(duration:TimeInterval = 0.0, pos:SCNVector3? = nil){
        if(self.mapNode != nil){
            self.game.overlayManager.hud.overlayScene.map!.reposNodeInitNG(mapNode: self.mapNode!, pos: (pos != nil ? pos! : self.pos), duration: duration)
        }
    }
    
    func rotateMapNodeInit(duration:TimeInterval = 0.0, dir:SuakeDir? = nil){
        if(self.mapNode != nil){
            self.game.overlayManager.hud.overlayScene.map!.rotatePlayerNodesNG(mapNode: self.mapNode!, dir: (dir != nil ? dir! : self.dir), delta: duration)
        }
    }
    
    override init(game: GameController, id: Int) {
        super.init(game: game, id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
