//
//  SuakeGameCenterViewController.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.05.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import GameKit

class SuakeGameCenterViewController: GKGameCenterViewController {
    
    var game:GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.delegate = self
    }

    // Press ESC
    override func cancelOperation(_ sender: Any?) {
        do {
            try save()
            dismiss(sender)
        } catch {
            presentError(error)
        }
    }

    private func save() throws {
        // Validate and throw errors
        if(game != nil){
//            if(game.cameraHelper.fpv){
//                MenuCursor.hideCursor()
//            }
        }
    }
}

extension SuakeGameCenterViewController: NSWindowDelegate {

    // Click window close button
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        do {
            try save()
            return true
        } catch {
            presentError(error)
            return false
        }
    }

}
