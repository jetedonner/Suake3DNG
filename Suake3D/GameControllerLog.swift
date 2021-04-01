//
//  GameControllerLog.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.03.21.
//

import Foundation

extension GameController{
    func showDbgMsg(dbgMsg:String, dbgLevel:DbgLevel = .Info){
        self.dbgHelper.showDbgMsg(msg: dbgMsg, dbgLevel: dbgLevel)
    }
}
