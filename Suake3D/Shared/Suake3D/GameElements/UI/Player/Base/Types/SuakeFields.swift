//
//  SuakeFields.swift
//  Suake3D
//
//  Created by dave on 04.09.18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import NetTestFW

public class SuakeField {
    var fieldType:SuakeFieldType = .empty
    var fieldTypeOrig:SuakeFieldType = .empty
    var fieldEntity:SuakeBaseEntity!
    var fieldItemEntity:SuakeBaseEntity? = nil
    
    init(fieldType:SuakeFieldType = .empty, fieldEntity:SuakeBaseEntity? = nil, fieldItemEntity:SuakeBaseEntity? = nil) {
        self.fieldType = fieldType
        self.fieldTypeOrig = fieldType
        if(fieldEntity != nil){
            self.fieldEntity = fieldEntity
        }
        if(fieldItemEntity != nil){
            self.fieldItemEntity = fieldItemEntity
        }
    }
}

//public enum SuakeFieldType:String {
//    case empty, wall, goody, volcano, lavapit, own_suake, opp_suake, droid,
//    weapon, machinegun, grenade, shotgun, nuke, rocketlauncher,
//    railgun, sniperrifle, portal, portalIn, portalOut, fire, medKit, captureFlag, rock
//}
