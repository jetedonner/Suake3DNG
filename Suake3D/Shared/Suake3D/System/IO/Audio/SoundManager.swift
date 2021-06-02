//
//  SoundManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 13.03.21.
//

import Foundation
import SceneKit
import GameplayKit
import NetTestFW

class SoundManager: SuakeGameClass {
    
    var muteSound:Bool = false
    var volume:CGFloat = 0.5
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func playBulletHitSound(weaponType:WeaponType, node:SCNNode){
        guard self.muteSound == false else{
            return
        }
        if(weaponType == .mg){
            let sndIdx:Int = Int.random(range: 0..<3)
            if(sndIdx == 0){
                self.playSound(soundType: .riochet1)
//                self.playSoundPositional(soundType: .riochet1, node: node)
            }else if(sndIdx == 1){
                self.playSound(soundType: .riochet2)
//                self.playSoundPositional(soundType: .riochet2, node: node)
            }else{
                self.playSound(soundType: .riochet3)
//                self.playSoundPositional(soundType: .riochet3, node: node)
            }
        }
    }
    
    func playSound(soundType: SoundType, volume:CGFloat? = nil) {
        
        if(!self.muteSound){
            var fileName = ""
            
            switch soundType {
            
            
            case SoundType.pickupHealth:
                fileName = "pickupHealth"
            case SoundType.weaponreload:
                fileName = "weapons/gunreload-9"
            case SoundType.riochet1:
                fileName = "weapons/ricochet_1_2"
            case SoundType.riochet2:
                fileName = "weapons/ricochet_2_2"
            case SoundType.riochet3:
                fileName = "weapons/ricochet_3_2"
            case SoundType.beep:
                fileName = "beep-07"
            case SoundType.beep2:
                fileName = "beep-08b"
            case SoundType.rifle:
                fileName = "weapons/rifle"
            case SoundType.grenade:
                fileName = "weapons/grenade-throw"
            case SoundType.sinperrifle:
                fileName = "weapons/sniperFireReload"
            case SoundType.shotgun:
                fileName = "weapons/sshotf1b"
            case SoundType.railgun:
                fileName = "weapons/railgf1a"
            case SoundType.shotgunAimed:
                fileName = "weapons/shotgunReloadSpas"
            case SoundType.railgunAimed:
                fileName = "weapons/railgunAimedx2"
            case SoundType.railgunUnaimed:
                fileName = "weapons/railgunUnaimedx2"
            case SoundType.redeemerAimed:
                fileName = "weapons/redeemerAimed"
            case SoundType.redeemerUnaimed:
                fileName = "weapons/redeemerUnaimed"
            case SoundType.wp_change:
                fileName = "weapons/change"
            case SoundType.pick_goody:
                fileName = "land1"
            case SoundType.pick_weapon:
                fileName = "weapons/w_pkup"
            case SoundType.teleporter:
                fileName = "telein"
            case SoundType.bottleRocket:
                fileName = "weapons/bottleRocket"
            case SoundType.rpg:
                fileName = "weapons/bottleRocket"
            case SoundType.pain_25:
                fileName = "pain25_1"
            case SoundType.pain_50:
                fileName = "pain50_1"
            case SoundType.pain_75:
                fileName = "pain75_1"
            case SoundType.pain_100:
                fileName = "pain100_1"
            case SoundType.machineGun3:
                fileName = "weapons/machineGun3"
            case SoundType.machineGun4:
                fileName = "weapons/machineGun4"
            case SoundType.explosion1:
                fileName = "weapons/Explosion1"
            case SoundType.explosion:
                fileName = "weapons/Explosion2"
            case SoundType.hitEnemy:
                fileName = "hitEnemy"
            case SoundType.noammo:
                fileName = "weapons/noammo"
            case SoundType.gunSilencer:
                fileName = "weapons/gunSilencer"
            case SoundType.bltImpactMetal1:
                fileName = "weapons/bulletimpact-metal1"
            case SoundType.bltImpactMetal2:
                fileName = "weapons/bulletimpact-metal2"
            case SoundType.bltImpactMetal3:
                fileName = "weapons/bulletimpact-metal3"
            case SoundType.die:
                fileName = "die"
            case SoundType.fire:
                fileName = "fire"
            case SoundType.menu1:
                fileName = "Menu1"
            case SoundType.menuItemChoosen:
                fileName = "Menu2"
            case SoundType.menuItemChanged:
                fileName = "Menu3"
            case SoundType.nukeExplosion:
                fileName = "weapons/nuc_explosion"
            case SoundType.first_blood:
                fileName = "first-blood-echo"
            case SoundType.health:
                fileName = "health1"
            case SoundType.laser:
                fileName = "weapons/laser"
            case SoundType.zoomIn:
                fileName = "zoomIn"
            case SoundType.zoomOut:
                fileName = "zoomOut"
            case SoundType.fpvIn:
                fileName = "fpvIn"
            case SoundType.fpvOut:
                fileName = "fpvOut"
            default:
                fileName = "land1"
                break
            }
            
            if(fileName != ""){
                //nameQueue.async(flags: .barrier) {
//                    GSAudio.sharedInstance.volume = self.tmpVolume //10.0 //Float(truncating: volume as NSNumber)
                GSAudio.sharedInstance.playSound(soundFileName: fileName, volume: (volume != nil ? volume! : self.volume)) // 10.0) // Float(truncating: volume as NSNumber))
                //}
            }
        }
    }
    
    func playSoundQuake(soundType: SoundTypeQuake, volume:CGFloat? = nil) {
        if(!self.muteSound){
            var fileName = ""
            
            switch soundType {
            case SoundTypeQuake.play:
                fileName = "play"
                break
            case SoundTypeQuake.prepare:
                fileName = "prepare"
                break
            case SoundTypeQuake.you_win:
                fileName = "you_win"
                break
            case SoundTypeQuake.you_lose:
                fileName = "you_lose"
                break
            case SoundTypeQuake.fight:
                fileName = "fight"
                break
            case SoundTypeQuake.headshot:
                fileName = "headshot"
                break
            case SoundTypeQuake.tied_lead:
                fileName = "tied_lead"
                break
            case SoundTypeQuake.taken_lead:
                fileName = "taken_lead"
                break
            case SoundTypeQuake.lost_lead:
                fileName = "lostlead"
                break
            case SoundTypeQuake.perfect:
                fileName = "perfect"
                break
            case SoundTypeQuake.new_highscore:
                fileName = "new_high_score"
                break
            case SoundTypeQuake.youHaveTheFlag:
                fileName = "team_1flag"
                break
            case SoundTypeQuake.enemyHasTheFlag:
                fileName = "enemy_1flag"
                break
            default:
                fileName = ""
                break
            }
            if(fileName != ""){
//                nameQueue.async(flags: .barrier) {
//                    GSAudio.sharedInstance.volume = Float(truncating: volume as NSNumber)
//                    GSAudio.sharedInstance.playSound(soundFileName: "quake3/" + fileName, volume: Float(truncating: volume as NSNumber))
//                print("Playing Quake-Sound: " + fileName)
//                GSAudio.sharedInstance.volume = self.tmpVolume //10.0 //Float(truncating: volume as NSNumber)
                GSAudio.sharedInstance.playSound(soundFileName: "quake3/" + fileName, volume: (volume != nil ? volume! : self.volume)) //self.tmpVolume
//                }
            }
        }
    }
}
