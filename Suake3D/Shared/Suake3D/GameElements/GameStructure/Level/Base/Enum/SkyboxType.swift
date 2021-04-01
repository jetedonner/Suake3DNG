//
//  SkyboxType.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation

enum SkyboxType:String {
    
    case GreenSky = "Green sky"
    case PinkSunrise = "Pink sunrise"
    case RedGalaxy = "Red galaxy"
    case YellowGalaxy = "Yellow galaxy"
    case RandomSkyBox = "A random skybox"
    
    static var allSkyboxes: [SkyboxType] {
        return [.GreenSky, .PinkSunrise, .RedGalaxy, .YellowGalaxy]
    }
    
    static func random() -> SkyboxType {
        let randomIndex = Int(arc4random()) % self.allSkyboxes.count
        return self.allSkyboxes[randomIndex]
    }
    
    static func getSkybox(type:SkyboxType)->[String]{
        if(type == .RedGalaxy){
            return ["SkyRed_left_1024x1024", "SkyRed_right_1024x1024", "SkyRed_top_1024x1024", "SkyRed_bottom_1024x1024", "SkyRed_back_1024x1024", "SkyRed_front_1024x1024"]
        }else if(type == .YellowGalaxy){
            return ["SkyYellow_left_1024x1024", "SkyYellow_right_1024x1024", "SkyYellow_top_1024x1024", "SkyYellow_bottom_1024x1024", "SkyYellow_back_1024x1024", "SkyYellow_front_1024x1024"]
        }else if(type == .PinkSunrise){
            return ["SkyLeft_1024x1024", "SkyRight_1024x1024", "SkyUp_1024x1024", "SkyDown_1024x1024", "SkyBack_1024x1024", "SkyFront_1024x1024"]
        }else{
            return ["Sky2Left_1024x1024", "Sky2Right_1024x1024", "Sky2Top_1024x1024", "Sky2Bottom_1024x1024", "Sky2Back_1024x1024", "Sky2Front_1024x1024"]
        }
    }
}
