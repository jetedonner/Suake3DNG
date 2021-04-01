//
//  SuakeMapUpdateDelegate.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.03.21.
//

import Foundation
import SceneKit

protocol SuakeMapUpdateDelegate {
    func updateMapPosition(entity:SuakePlayerEntity, pos:SCNVector3)
}
