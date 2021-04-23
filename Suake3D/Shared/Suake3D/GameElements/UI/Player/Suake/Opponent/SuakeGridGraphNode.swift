//
//  SuakeGridGraphNode.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SuakeGridGraphNode:GKGridGraphNode {

    var game:GameController!
    var suakeField:SuakeField!
    
    static func addGameNField(arrGKGridGraphNodes:[GKGridGraphNode], game:GameController, suakeField:SuakeField){
        for i in (0..<arrGKGridGraphNodes.count){
            (arrGKGridGraphNodes[i] as! SuakeGridGraphNode).game = game
            (arrGKGridGraphNodes[i] as! SuakeGridGraphNode).suakeField = suakeField
        }
    }

    init(game:GameController, gridPosition: vector_int2, suakeFieldType:SuakeFieldType = .empty, fieldEntity:SuakeBaseEntity? = nil) {
        self.game = game
        self.suakeField = SuakeField(fieldType: suakeFieldType, fieldEntity: fieldEntity)
        super.init(gridPosition: gridPosition)
    }
    
    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
