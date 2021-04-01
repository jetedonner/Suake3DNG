//
//  GameViewControllerWindowDelegate.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

//class GameViewControllerWindowDelegate: SuakeGameClass, NSWindowDelegate {
//    
//    override init(game:GameController) {
//        super.init(game: game)
//    }
//    
//    func flagsChanged(with event: NSEvent) {
//        if Int(event.keyCode) == 0x39 {
//            let flags: NSEvent.ModifierFlags = event.modifierFlags
//            if flags.rawValue & NSEvent.ModifierFlags.capsLock.rawValue != 0 {
//               print("capsLock on")
//               self.game.keyboardHandler.capsLockChanged(on: true)
//            } else {
//               print("capsLock off")
//               self.game.keyboardHandler.capsLockChanged(on: false)
//            }
//        }
//    }
//}
