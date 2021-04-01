//
//  MouseProtocol.swift
//  Suake3D
//
//  Created by dave on 18.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

protocol KeyboardAndMouseEventsDelegate {
    func mouseDown(in view: NSView, with event: NSEvent) -> Bool
    func mouseUp(in view: NSView, with event: NSEvent) -> Bool
    //func mouseDragged(in view: NSView, with event: NSEvent) -> Bool
    //func keyDown(in view: NSView, with event: NSEvent) -> Bool
    //func keyUp(in view: NSView, with event: NSEvent) -> Bool
    //func scrollWheel(with event: NSEvent)
}

protocol MoveCrosshairDelegate {
    func panCamera(_ direction: SIMD2<Float>)
    func resetCamRotation()
    func abortResetCamRotation()
}
