//
//  SuakeMoveComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeMoveComponent: SuakeBaseComponent {
    
    //EXT TMP
    var idxTmp:Int = 0
    var tmpCnt:Int = 0
    var oppGoodyHit:Bool = false
    
    var playerEntity:SuakePlayerEntity{
        get{ return super.entity as! SuakePlayerEntity }
    }
    
    var currentTurnDir:TurnDir = .Straight
    
    var _inBetweenMove:Bool = false
    var inBetweenMove:Bool{
        get{ return self._inBetweenMove }
        set{ self._inBetweenMove = newValue }
    }
    
    
    var _turnQueue:[TurnDir] = []
    var turnQueue:[TurnDir]{
        get{ return self._turnQueue }
        set{ self._turnQueue = newValue }
    }
    
    var posAfterNetSend:SCNVector3? = nil //SCNVector3(0, 0, 0)
    var overNextPos:SCNVector3!
    var nextPos:SCNVector3!
    
    func appendTurn(turnDir:TurnDir){
        self.turnQueue.append(turnDir)
    }
    
    func appendTurn(turn:KeyboardDirection){
        switch turn {
        case .KEY_W:
            self.appendTurn(turnDir: .Straight)
//            self.turnQueue.append(.Straight)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_A:
            self.appendTurn(turnDir: .Left)
//            self.turnQueue.append(.Left)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_S:
            self.appendTurn(turnDir: .Stop)
//            self.turnQueue.append(.Stop)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_D:
            self.appendTurn(turnDir: .Right)
//            self.turnQueue.append(.Right)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_LEFT:
            self.appendTurn(turnDir: .Left)
//            self.turnQueue.append(.Left)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_RIGHT:
            self.appendTurn(turnDir: .Right)
//            self.turnQueue.append(.Right)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_UP:
            self.appendTurn(turnDir: .Straight)
//            self.turnQueue.append(.Straight)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        case .KEY_DOWN:
            self.appendTurn(turnDir: .Stop)
//            self.turnQueue.append(.Stop)
//            print("Appended \(String(describing: self.turnQueue.last?.rawValue)) turn")
            break
        default:
            break
        }
//        if(self.playerEntity.isPaused){
            self.playerEntity.isPaused = false
            self.game.scene.isPaused = false
            self.game.scnView.isPlaying = true
//        }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if(self.playerEntity.playerType == .OppSuake){
            self.playerEntity.moveComponent.nextMoveOpp(deltaTime: seconds)
        }else{
            self.nextMove(deltaTime: seconds)
        }
    }
    
    func resetMoveComponent(){
        self.turnQueue.removeAll()
        self.currentTurnDir = .Straight
        self.inBetweenMove = false
        SuakeDirTurnDirHelper.initNodeRotation(node: self.playerEntity.playerComponent.mainNode, dir: self.playerEntity.dir)
    }
    
    func nextMove(deltaTime seconds: TimeInterval = 1.0){
        let inBetween:Bool = (seconds <= 0.64)
        
        if(self.turnQueue.count > 0 && inBetween){
            self.inBetweenMove = true
            let nextTurn:TurnDir = self.turnQueue.remove(at: 0)
            guard nextTurn != .Straight else {
                self.game.showDbgMsg(dbgMsg: "nextTurn == .Straight")
                return
            }
            
            self.currentTurnDir = nextTurn
            if(nextTurn == .Stop){
                self.playerEntity.isPaused = true
                return
            }
            self.nextMove(newTurnDir: nextTurn, deltaTime: seconds)
        }else{
            if(self.turnQueue.count > 0 && self.currentTurnDir == .Stop){
                let nextTurn:TurnDir = self.turnQueue.remove(at: 0)
                guard nextTurn == .Straight else {
                    self.game.showDbgMsg(dbgMsg: "newTurnDir != .Straight")
                    return
                }
                self.currentTurnDir = nextTurn
                self.playerEntity.isPaused = false
            }
            if(self.currentTurnDir != .Stop){
                self.nextMove(newTurnDir: .Straight, deltaTime: seconds)
            }
        }
    }
    
    func setAndShowSuakePlayerNodeComponent(newSuakePlayerNodeComponent:SuakePlayerNodeComponent){
        self.playerEntity.playerComponent.currentSuakeComponent.isHidden = true
        self.playerEntity.playerComponent.currentSuakeComponent.isStopped = true
        self.playerEntity.playerComponent.currentSuakeComponent = newSuakePlayerNodeComponent
        newSuakePlayerNodeComponent.isHidden = false
        newSuakePlayerNodeComponent.isStopped = false
    }
    
    func getOverNextPos(daDir:SuakeDir, suakePart:SuakePart, daPos:SCNVector3)->SCNVector3{
        return PosHelper.getNextPos4DirNG(daDir: daDir, suakePart: suakePart, daPos: daPos)
    }
    
    func nextMove(newTurnDir:TurnDir = .Straight, deltaTime seconds: TimeInterval = 1.0){
        var newPos:SCNVector3 = self.playerEntity.pos
        
        
        var daNextTurnDir:TurnDir = newTurnDir
        if(self.playerEntity.playerType == .OppSuake){
            daNextTurnDir = (self.playerEntity as! SuakeOppPlayerEntity).turnQueue[0]
        }
        
        let nextSuakePlayerNodeComponent:SuakePlayerNodeComponent = self.playerEntity.playerComponent.getNextSuakePlayerNodeComponent(turnDir: daNextTurnDir) //newTurnDir)
        let nextDir:SuakeDir = SuakeDirTurnDirHelper.getSuakeDirFromTurnDir(oldSuakeDir: self.playerEntity.dir, turnDir: daNextTurnDir)
        
        if(seconds >= 1.0 || self.playerEntity.playerType == .OppSuake){
            newPos = self.nextPos(dir: nextDir, suakePart: nextSuakePlayerNodeComponent.suakePart)
        }
        self.nextPos = newPos
        self.overNextPos = self.getOverNextPos(daDir: self.playerEntity.dir, suakePart: nextSuakePlayerNodeComponent.suakePart, daPos: newPos)
        
        
        
//        print("Turn - Dir: \(self.playerEntity.dir), Old-Pos: \(self.playerEntity.pos), New-Pos: \(newPos), suakePart: \(nextSuakePlayerNodeComponent.suakePart.rawValue)")
        let nextMoveResult:NextMoveResult = self.checkNextMoveNG(pos: newPos)
        if(nextMoveResult.contains(.moveNotOk)){
            if(nextMoveResult.contains(.wall)){
                self.game.showDbgMsg(dbgMsg: "WALL HIT!!!")
                self.playerEntity.playerDied()
//                if(!self.playerEntity.healthComponent.died){
//                    self.playerEntity.healthComponent.died = true
//                    self.game.stateMachine.enter(SuakeStateDied.self)
////                    print("\(newPos): NOT OK - WALL HIT")
//                }
            }else if(nextMoveResult.contains(.suakeOpp)){
                self.game.showDbgMsg(dbgMsg: "OPPONENT HIT!!!")
                self.playerEntity.playerDied()
//                if(!self.playerEntity.healthComponent.died){
//                    self.playerEntity.healthComponent.died = true
//                    self.game.stateMachine.enter(SuakeStateDied.self)
////                    print("\(newPos): NOT OK - WALL HIT")
//                }
            }
        }else{
            if(nextMoveResult.contains(.goody)){
                self.game.showDbgMsg(dbgMsg: "GOODY HIT by OWN")
//                GameCenterHelper.achievements.add2GoodiesAchivement()
                self.game.playerEntityManager.goodyEntity.goodyHit(playerEntity: self.playerEntity)
            }else if(nextMoveResult.contains(.mgPickup)){
                self.game.showDbgMsg(dbgMsg: "MGPICKUP HIT by OWN")
            }else if(nextMoveResult.contains(.medkit)){
                self.game.showDbgMsg(dbgMsg: "MEDKIT HIT by OWN")
            }else if(nextMoveResult.contains(.portal)){
                self.game.showDbgMsg(dbgMsg: "PORTAL HIT by OWN")
                (nextMoveResult.fieldEntity as! PortalEntity).beamSuakeNode(suakeEntity: self.playerEntity, portal: 0)
            }
            self.setAndShowSuakePlayerNodeComponent(newSuakePlayerNodeComponent: nextSuakePlayerNodeComponent)
            if(!(seconds == 0 && self.playerEntity.playerType == .OppSuake)){
                self.moveNode(newPos: newPos, seconds: seconds)
            }
            if(self.playerEntity.dir != nextDir){
                self.game.overlayManager.hud.overlayScene.arrows.rotateArrows(duration: 1.0, turnDir: (newTurnDir == .Left ? .Right : .Left))
            }
            
            self.playerEntity.playerComponent.currentSuakeComponent.movePlayerNodeComponent(newTurnDir: daNextTurnDir, newDir: nextDir, deltaTime: seconds)
            
            self.playerEntity.dir = nextDir
            print("Own next pos: \(newPos)")
        }
    }

    func checkSuakePos(pos:SCNVector3)->Bool{
        let levelSize = self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize()
        if(pos.x >= (levelSize.width / 2) ||
            pos.x < (levelSize.width / -2) ||
            pos.z >= (levelSize.height / 2) ||
            pos.z < (levelSize.height / -2)){
            return false
        }
        return true
    }
    
    func checkNextMoveNG(pos:SCNVector3) -> NextMoveResult {
        var nextMoveResult:NextMoveResult = NextMoveResult(moveResult: .moveOk, pos: pos)
        let resNextMove = self.checkSuakePos(pos: pos)
        if(!resNextMove){
            nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .wall])
        }else{
            let nextSuakeFieldType = self.game.levelManager.gameBoard.getGameBoardField(pos: pos)
            
            let nextSuakeFielditem = self.game.levelManager.gameBoard.getGameBoardFieldItem(pos: pos)
            
            if(nextSuakeFielditem != nil && (nextSuakeFielditem!.isKind(of: MachinegunPickupEntity.self))){
                (nextSuakeFielditem as! MachinegunPickupEntity).pickupWeapon(player: self.playerEntity)
            }else if(nextSuakeFielditem != nil && (nextSuakeFielditem!.isKind(of: MedKitEntity.self))){
                (nextSuakeFielditem as! MedKitEntity).medKitCollected(playerEntity: self.playerEntity)
            }
            switch nextSuakeFieldType {
            case .goody:
                nextMoveResult.addMoveResult(moveResult: .goody)
                break
//            case .machinegun:
//                nextMoveResult.addMoveResult(moveResult: .mgPickup)
//                break
//            case .own_suake:
//                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .suakeOwn], pos: pos)
            case .opp_suake:
                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .suakeOpp], pos: pos)
//            case .droid:
//                nextMoveResult = NextMoveResult(moveResults: [.moveNotOk, .droid], pos: pos)
//            case .medKit:
//                nextMoveResult.addMoveResult(moveResult: .medkit)
            case .portal,
                 .portalIn,
                 .portalOut:
                nextMoveResult.fieldEntity = nextSuakeFielditem
                nextMoveResult.addMoveResult(moveResult: .portal)
            default:
                break
            }
        }
        return nextMoveResult
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
