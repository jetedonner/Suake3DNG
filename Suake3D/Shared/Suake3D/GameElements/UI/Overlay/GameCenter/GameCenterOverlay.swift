//
//  GameCenterOverlay.swift
//  Suake3D
//
//  Created by Kim David Hauser on 03.04.21.
//

import Foundation
import GameKit

class GameCenterOverlay: SuakeBaseOverlay {
    
    override init(size:CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
