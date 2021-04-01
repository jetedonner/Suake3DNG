//
//  LevelID.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation

enum LevelID:String {
    case DBG_std = "00.00.00"
    case DBG_dark = "00.00.01"
    case TUT_00 = "00.01.00"
    case TUT_01 = "00.01.01"
    case TUT_02 = "00.01.02"
    case GAME_L00_E00 = "01.00.00"
    case GAME_L00_E01 = "01.01.00"
}

enum LevelGoalShort:String {
    case DBG_std = "00.00.00"
    case DBG_dark = "00.00.01"
    case TUT_00 = "Move around"
    case TUT_01 = "Catch 3 goodies"
    case TUT_02 = "00.01.02"
    case GAME_L00_E00 = "01.00.00"
    case GAME_L00_E01 = "01.01.00"
}

enum LevelGoal:String {
    case DBG_std = "00.00.00"
    case DBG_dark = "00.00.01"
    case TUT_00 = "Move your suake around without touching the walls and try to catch a goody"
    case TUT_01 = "Move around and try to catch 3 goodies"
    case TUT_02 = "00.01.02"
    case GAME_L00_E00 = "01.00.00"
    case GAME_L00_E01 = "01.01.00"
}
