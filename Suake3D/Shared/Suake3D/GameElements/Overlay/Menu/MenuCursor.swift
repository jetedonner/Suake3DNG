//
//  MenuCursor.swift
//  Suake3D-swift
//
//  Created by dave on 25.01.19.
//  Copyright © 2019 ch.kimhauser. All rights reserved.
//

import Foundation
import SceneKit

class MenuCursor:SuakeGameClass {
    
    var menuCursor:NSCursor!
    var csCursor:NSCursor!
    let cursorImg:NSImage = NSImage(named: NSImage.Name.red)!
    let cursorCSImg:NSImage = NSImage(named: NSImage.Name.punkt)!
    
    override init(game:GameController) {
        super.init(game: game)
        self.menuCursor = NSCursor(image: self.cursorImg, hotSpot: NSPoint(x: self.cursorImg.size.width / 2, y: self.cursorImg.size.height / 2))
        self.csCursor = NSCursor(image: self.cursorCSImg, hotSpot: NSPoint(x: self.cursorCSImg.size.width / 2, y: self.cursorCSImg.size.height / 2))
    }
    
    var csCursorShowing:Bool = false
    
    func toggleCSCursor(){
        csCursorShowing = !csCursorShowing
        if(csCursorShowing){
            showCSCursor()
        }else{
            hideCSCursor()
        }
    }
    
    func showCSCursor(){
        DispatchQueue.main.async {
            self.showCursor()
            self.game.scnView.addCursorRect(self.game.scnView.frame, cursor: self.csCursor)
            self.game.scnView.resetCursorRects()
            self.game.showDbgMsg(dbgMsg: "showCSCursor()")
        }
    }
    
    func hideCSCursor(){
        self.game.scnView.removeCursorRect(self.game.scnView.frame, cursor: self.menuCursor)
        self.game.scnView.addCursorRect(self.game.scnView.frame, cursor: NSCursor.arrow)
        self.game.showDbgMsg(dbgMsg: "hideCSCursor()")
    }
    
    func showMenuCursor(){
        DispatchQueue.main.async {
            self.showCursor()
            self.game.scnView.addCursorRect(self.game.scnView.frame, cursor: self.menuCursor)
            self.game.scnView.resetCursorRects()
            self.game.showDbgMsg(dbgMsg: "showMenuCursor()")
        }
    }
    
    func hideMenuCursor(){
        self.game.scnView.removeCursorRect(self.game.scnView.frame, cursor: self.menuCursor)
        self.game.scnView.addCursorRect(self.game.scnView.frame, cursor: NSCursor.arrow)
    }
    
    func showCursor(){
        MenuCursor.showCursor()
    }
    
    static func showCursor(){
        CGAssociateMouseAndMouseCursorPosition(boolean_t(UInt32(truncating: true)))
        CGDisplayShowCursor(CGMainDisplayID())
    }
    
    func hideCursor(){
        MenuCursor.hideCursor()
    }
    
    static func hideCursor(){
        CGAssociateMouseAndMouseCursorPosition(boolean_t(UInt32(truncating: false)))
        _ = CGGetLastMouseDelta()
        CGDisplayHideCursor(CGMainDisplayID())
    }
}
