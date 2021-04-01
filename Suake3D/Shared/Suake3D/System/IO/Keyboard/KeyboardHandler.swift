//
//  KeyboardHandler.swift
//  Suake3D
//
//  Created by dave on 16.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

class KeyboardHandler:SuakeGameClass{
    
    override init(game:GameController){
        super.init(game:game)
    }
    
    func keyPressedEvent(event: NSEvent) {
       
    }
    
    func keyToSuakeDir(key:KeyboardDirection)->SuakeDir{
        var dirRet:SuakeDir = .UP
        switch key {
            case .KEY_UP:
                dirRet = .UP
            case .KEY_DOWN:
                dirRet = .DOWN
            case .KEY_LEFT:
                dirRet = .LEFT
            case .KEY_RIGHT:
                dirRet = .RIGHT
            default:
                break
        }
        return dirRet
    }
    
    func capsLockChanged(on: Bool) {

    }
}
