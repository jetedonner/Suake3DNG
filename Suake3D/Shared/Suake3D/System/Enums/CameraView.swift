//
//  CameraView.swift
//  Suake3D
//
//  Created by dave on 18.03.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation

enum CameraView: Int {
    case Own3rdPerson
    case Own1stPerson
    case Opp3rdPerson
    case Opp1stPerson
    case FreeCamera
    case Undefined
}

enum CameraViewType: Int {
    case ThirdPerson
    case FirstPerson
    case FreeCamera
    case Undefined
}

enum AllowCameraControl: String {
    case Allow
    case Disallow
    case Undefined
}

enum BlurVision: String {
    case BlurOn
    case BlurOff
    case Undefined
}
