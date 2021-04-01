//
//  MouseHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 24.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class MouseHelper{
    
    static func showMouseCursor(show:Bool = true){
        if(show){
            CGAssociateMouseAndMouseCursorPosition(boolean_t(UInt32(truncating: true)))
            CGDisplayShowCursor(CGMainDisplayID())
        }else{
            CGAssociateMouseAndMouseCursorPosition(boolean_t(UInt32(truncating: false)))
            _ = CGGetLastMouseDelta()
            CGDisplayHideCursor(CGMainDisplayID())
        }
    }
}
