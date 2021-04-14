//
//  EnemyNames.swift
//  Suake3D
//
//  Created by Kim David Hauser on 28.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation

enum EnemyNames: String{
    case DeathKnight    = "Death Knight"
    case Enforcer       = "Enforcer"
    case Fiend          = "Fiend"
    case Grunt          = "Grunt"
    case Knight         = "Knight"
    case Ogre           = "Ogre"
    case OgreMarksman   = "Ogre Marksman"
    case Rotfish        = "Rotfish"
    case Rottweiler     = "Rottweiler"
    case Scrag          = "Scrag"
    case Shambler       = "Shambler"
    case Spawn          = "Spawn"
    case Vore           = "Vore"
    case Zombie         = "Zombie"
}

extension EnemyNames {
    static func random() -> EnemyNames {
        let allEnemyNames: [EnemyNames] = [
            .DeathKnight,
            .Enforcer,
            .Fiend,
            .Grunt,
            .Knight,
            .Ogre,
            .OgreMarksman,
            .Rotfish,
            .Rottweiler,
            .Scrag,
            .Shambler,
            .Spawn,
            .Vore,
            .Zombie
        ]
        let randomIndex = Int(arc4random()) % allEnemyNames.count
        return allEnemyNames[randomIndex]
    }
}
