//
//  GameBoard.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class GameBoard: SuakeGameClass {
    
    var gameBoardFields: [[SuakeField]]!
    var halfFieldCount:CGFloat!
    
    subscript(x:Int, z:Int) -> SuakeField {
        get {
            return self.gameBoardFields[x][z]
        }
        set {
            self.gameBoardFields[x][z] = newValue
        }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initGameBoard() {
        self.gameBoardFields = self.getInitGameBoard()
        self.halfFieldCount = CGFloat(gameBoardFields.count / 2)
    }
    
    private func getInitGameBoard() -> [[SuakeField]] {
        var matrix: [[SuakeField]] = []
        for i in (0..<Int(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().width)) {
            matrix.append( [] )
            for _ in (0..<Int(self.game.levelManager.currentLevel.levelConfigEnv.levelSize.getNSSize().height)) {
                matrix[i].append(SuakeField())
            }
        }
        return matrix
    }
    
    func setGameBoardField(pos:SCNVector3, suakeField: SuakeFieldType, overrideOrig:Bool = false){
        self.setGameBoardField(x: pos.x, z: pos.z, suakeField: suakeField, overrideOrig: overrideOrig)
    }
    
    func setGameBoardField(x:CGFloat, z:CGFloat, suakeField:SuakeFieldType, overrideOrig:Bool = false){
        let arrPosX:Int = Int(x + self.halfFieldCount)
        let arrPosZ:Int = Int(z + self.halfFieldCount)
        
        self.gameBoardFields[arrPosX][arrPosZ].fieldType = suakeField
    }
    
    func clearGameBoardFieldItem(pos:SCNVector3){
        self.setGameBoardFieldItem(x: pos.x, z: pos.z, suakeFieldItem: nil)
    }
    
    func removeGameBoardFieldItem(pos:SCNVector3, suakeFieldItem: SuakeBaseEntity?){
        self.removeGameBoardFieldItem(x: pos.x, z: pos.z, suakeFieldItem: suakeFieldItem)
    }
    
    func removeGameBoardFieldItem(x:CGFloat, z:CGFloat, suakeFieldItem: SuakeBaseEntity?){
        let arrPosX:Int = Int(x + self.halfFieldCount)
        let arrPosZ:Int = Int(z + self.halfFieldCount)
        
        if(self.gameBoardFields[arrPosX][arrPosZ].fieldItemEntity == suakeFieldItem){
            self.gameBoardFields[arrPosX][arrPosZ].fieldItemEntity = nil
        }
    }
    
    func setGameBoardFieldItem(pos:SCNVector3, suakeFieldItem: SuakeBaseEntity?){
        self.setGameBoardFieldItem(x: pos.x, z: pos.z, suakeFieldItem: suakeFieldItem)
    }
    
    func getGameBoardFieldItem(pos:SCNVector3)->SuakeBaseEntity?{
        return gameBoardFields[Int(pos.x + halfFieldCount)][Int(pos.z + halfFieldCount)].fieldItemEntity
    }
    
    func setGameBoardFieldItem(x:CGFloat, z:CGFloat, suakeFieldItem: SuakeBaseEntity?){
        let arrPosX:Int = Int(x + self.halfFieldCount)
        let arrPosZ:Int = Int(z + self.halfFieldCount)
        
        self.gameBoardFields[arrPosX][arrPosZ].fieldItemEntity = suakeFieldItem
    }
    
    func getGameBoardField(pos:SCNVector3)->SuakeFieldType{
        return gameBoardFields[Int(pos.x + halfFieldCount)][Int(pos.z + halfFieldCount)].fieldType
    }
    
    func printAllGamerBoardFields(){
        for i in 0..<Int(self.halfFieldCount * 2){
            for j in 0..<Int(self.halfFieldCount * 2){
                print("x: \(i.description), z: \(j.description), fieldType: \(gameBoardFields[i][j].fieldType)")
            }
        }
    }
}
