//
//  SoundManagerExt.swift
//  Suake3D
//
//  Created by Kim David Hauser on 23.04.21.
//

import Foundation
import SceneKit

class SoundManagerPositional : SoundManager{
    
    var mgBulletHit1AudioSource:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/weapons/ricochet_1_2.wav")!
    var mgBulletHit2AudioSource:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/weapons/ricochet_2_2.wav")!
    var mgBulletHit3AudioSource:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/weapons/ricochet_3_2.wav")!
    
    var laserShot:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/weapons/laser.wav")!
    var mgShot:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/rifle.wav")!
    var shotgunShot:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/sshotf1b.wav")!
    var rpgShotAudioSource:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/bottleRocket.wav")!
    var railgunShot:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/railgf1a.wav")!
    var sniperFireReload:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/sniperFireReload.wav")!
    var nukeLaunch:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/nukelaunch.wav")!
    
    var weaponReload:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/gunreload-9.wav")!
    var weaponPickup:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/w_pkup.wav")!
    
    var enemyHit:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/hitEnemy.wav")!
    var goodyHit:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/land1.wav")!
    var teleporter:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/telein.wav")!
    
    var explosion:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/explosion2.wav")!
    var nukeExplosion:SCNAudioSource = SCNAudioSource(fileNamed: "art.scnassets/sound/mono/nuc_explosion.wav")!
    
    override init(game: GameController) {
        super.init(game: game)
        
        self.setupPositionalAudioSources(sources: [
            self.mgBulletHit1AudioSource,
            self.mgBulletHit2AudioSource,
            self.mgBulletHit3AudioSource,
            self.laserShot,
            self.mgShot,
            self.shotgunShot,
            self.rpgShotAudioSource,
            self.railgunShot,
            self.sniperFireReload,
            self.nukeLaunch,
            self.weaponReload,
            self.weaponPickup,
            self.enemyHit,
            self.goodyHit,
            self.explosion,
            self.nukeExplosion,
            self.teleporter]
        )
    }
    
    private func setupPositionalAudioSources(sources:[SCNAudioSource], loops:Bool = false){
        for source in sources{
            self.setupPositionalAudioSource(source: source)
        }
    }
    
    private func setupPositionalAudioSource(source:SCNAudioSource, loops:Bool = false){
        source.volume = 10.0
        source.rate = 1.0
        source.loops = loops
        source.isPositional = true
        source.shouldStream = false
        source.load()
        //return SCNAudioPlayer(source: source)
    }
    
    func playSoundPositional(soundType: SoundType, node:SCNNode, completionHandler block: (() -> Void)? = nil) {
        var audioSource:SCNAudioSource = laserShot
        
        switch soundType {
            case SoundType.riochet1:
                audioSource = mgBulletHit1AudioSource
                break
            case SoundType.riochet2:
                audioSource = mgBulletHit2AudioSource
                break
            case SoundType.riochet3:
                audioSource = mgBulletHit3AudioSource
                break
            case SoundType.laser:
                audioSource = laserShot
                break
            case SoundType.rifle:
                audioSource = mgShot
                break
            case SoundType.shotgun:
                audioSource = shotgunShot
                break
            case SoundType.rpg:
                audioSource = rpgShotAudioSource
            case SoundType.railgun:
                audioSource = railgunShot
                break
            case SoundType.sinperrifle:
                audioSource = sniperFireReload
                break
            case SoundType.nukeLaunch:
                audioSource = nukeLaunch
                break
            case SoundType.weaponreload:
                audioSource = weaponReload
                break
            case SoundType.pick_weapon:
                audioSource = weaponPickup
                break
            case SoundType.hitEnemy:
                audioSource = enemyHit
                break
            case SoundType.pick_goody:
                audioSource = goodyHit
                break
            case SoundType.explosion:
                audioSource = explosion
                break
            case SoundType.nukeExplosion:
                audioSource = nukeExplosion
                break
            case SoundType.teleporter:
                audioSource = teleporter
                break
            default:
                audioSource = laserShot
                break
        }
//        node.isPaused = false
//        self.game.scene.isPaused = false
//        self.game.scnView.isPlaying = true
        
//        self.nameQueue.async(flags: .barrier) {
            if(block != nil){
                node.runAction(SCNAction.playAudio(audioSource, waitForCompletion: true), completionHandler: block)
            }else{
                node.runAction(SCNAction.playAudio(audioSource, waitForCompletion: true))
            }
//        }
    }
}
