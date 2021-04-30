//
//  SuakeBaseEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 21.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

public class SuakeBaseEntity: GKEntity {
    
    let game:GameController
    
    var _id:Int
    var id:Int{
        get{ return self._id }
        set{ self._id = newValue }
    }
    
    init(game:GameController, id:Int = 0) {
        self.game = game
        self._id = id
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
