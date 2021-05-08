//
//  AVPlayer.swift
//  Suake3D
//
//  Created by Kim David Hauser on 07.05.21.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
