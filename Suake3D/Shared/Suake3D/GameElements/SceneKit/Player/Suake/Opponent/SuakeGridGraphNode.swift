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

public class SuakeGridGraphNode:SuakeBaseGridGraphNode {

    var game:GameController!
    var suakeField:SuakeField!
    
//    private enum CodingKeys: String, CodingKey {
//        case gridPosition
////        case msgType
//    }
    
    static func addGameNField(arrGKGridGraphNodes:[GKGridGraphNode], game:GameController, suakeField:SuakeField){
        for i in (0..<arrGKGridGraphNodes.count){
            (arrGKGridGraphNodes[i] as! SuakeGridGraphNode).game = game
            (arrGKGridGraphNodes[i] as! SuakeGridGraphNode).suakeField = suakeField
        }
    }

    init(game:GameController, gridPosition: vector_int2, suakeFieldType:SuakeFieldType = .empty, fieldEntity:SuakeBaseEntity? = nil) {
//        self.gridPosition
        self.game = game
        self.suakeField = SuakeField(fieldType: suakeFieldType, fieldEntity: fieldEntity)
        super.init(gridPosition: gridPosition)
    }
    
    override init(gridPosition: vector_int2) {
        super.init(gridPosition: gridPosition)
    }
//    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let gridPosition = try container.decode(vector_int2.self, forKey: .gridPosition)
        try super.init(from: decoder)
//        super.init(gridPosition: gridPosition)
//        self.position = try container.decode(SCNVector3.self, forKey: .position)
    }

//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.gridPosition, forKey: .gridPosition)
//
////        try super.encode(to: encoder)
//    }
}
