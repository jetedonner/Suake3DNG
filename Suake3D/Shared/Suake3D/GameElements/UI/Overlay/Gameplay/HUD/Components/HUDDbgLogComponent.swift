//
//  HUDScoreComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.08.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import SceneKit

class HUDDbgLogComponent: BaseHUDComponent {
    
    var logLines:Int = 0
    let maxLogLines:Int = 28
    var lblDbgLog:SKLabelNode = SKLabelNode(fontNamed: "DpQuake")
    
    public var showDbgLog:Bool{
        set{
            lblDbgLog.isHidden = !newValue
        }
        get{ return !lblDbgLog.isHidden }
    }
    
    var isHidden:Bool{
        get{ return lblDbgLog.isHidden }
    }
    
    override init(game:GameController) {
        super.init(game: game)
    }
    
    func setupDbgLog(hud:HUDOverlayScene){
        self.lblDbgLog.fontSize = 12.0
        self.lblDbgLog.text = "---- DEBUG LOG ----"
//        self.lblDbgLog.isHidden = DbgVars.dbgLogHidden
        self.lblDbgLog.position = CGPoint(x: 20, y: self.game.gameWindowSize.height - 90)
        self.lblDbgLog.horizontalAlignmentMode = .left
//        self.lblDbgLog.removeFromParent()
        hud.addChild(self.lblDbgLog)
    }
    
    func logDbgMsg(msg:String){
        self.lblDbgLog.run(SKAction.run {
//            var txtLog:String = self.lblDbgLog.text!
            var txtLog:String = (self.lblDbgLog.attributedText != nil ? self.lblDbgLog.attributedText!.string : "")
//            var oldTxt:String = ""
            if(self.logLines > self.maxLogLines){
//                let lines = txtLog.components(separatedBy: "\n")
//                for i in lines.count-self.maxLogLines..<lines.count{
//                    oldTxt += lines[i]
//                }
                let firstIdx = txtLog.firstIndex(of: "\n")
                if(firstIdx != nil){
                    let fromIdx = txtLog.index(after: firstIdx!)
                    txtLog = txtLog.subString(from: fromIdx)
                }
            }
//            let newTxt:String = oldTxt + self.logLines.description + ": " + msg + "\n"
            let newTxt:String = txtLog + self.logLines.description + ": " + msg + "\n"
            let attributes: [NSAttributedString.Key : Any] =
                [.strokeWidth: -3.0,
                 .strokeColor: NSColor.red, // DbgVars.dbgLogTxtOuterColor,
                 .foregroundColor: NSColor.white, // DbgVars.dbgLogTxtInnerColor,
                 .font: NSFont(name: "Helvetica", size: 20.0)!]

            self.lblDbgLog.attributedText = NSAttributedString(string: newTxt, attributes: attributes)
            
            //self.lblDbgLog.text = txtLog + self.logLines.description + ": " + msg + "\n"
            self.logLines += 1
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
