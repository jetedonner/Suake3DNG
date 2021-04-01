//
//  GKEntityExtension.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.07.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

extension GKEntity {
    
    func component<P>(conformingTo protocol: P.Type) -> P? {
        for component in components {
            if let p = component as? P {
                return p
            }
        }
        return nil
    }
    
    func components<P>(conformingTo protocol: P.Type) -> [P] {
        var pRet:[P] = []
        for component in components {
            if let p = component as? P {
                pRet.append(p)
            }
        }
        return pRet
    }
}
