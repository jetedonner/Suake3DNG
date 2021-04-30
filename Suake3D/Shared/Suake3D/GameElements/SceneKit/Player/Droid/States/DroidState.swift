//
//  DroidState.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit

enum DroidState:String {
    case Dead = "Dead"
    case Deactivated = "Deactivated"
    case Patroling = "Patroling"
    case Chasing = "Chasing"
    case Attacking = "Attacking"
//    case ChasingOwn = "Chasing Own"
//    case AttackingOwn = "Attacking Own"
//    case ChasingOpp = "Chasing Opp"
//    case AttackingOpp = "Attacking Opp"
}
