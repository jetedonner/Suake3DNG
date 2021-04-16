//
//  SuakeVars.swift
//  Suake3D
//
//  Created by Kim David Hauser on 11.03.21.
//

import Foundation
import SceneKit

class SuakeVars{
    
    static let volume:CGFloat = 0.5
    static let defaultFontName:String = "DpQuake"
    static let progressBarFontSize:CGFloat = 16.0
    
    static let gameStepInterval:TimeInterval = 1.0
    static let cameraDist:CGFloat = 190.0
    static let cameraFPAhead:CGFloat = 50.0
    static let fieldSize:CGFloat = 150.0
    static let wallWidth:CGFloat = 60.0
    static let dbgBarHeight:CGFloat = 20.0
    
    static let showAmbientLight:Bool = true
    static let loadWeaponPickups:Bool = true
    static let loadOpp:Bool = false
    static let loadDroids:Bool = false
    static let droidsCount:Int = 1
    static let droidsChaseDist:CGFloat = 5.0
    static let droidsAttackDist:CGFloat = 2.0
    
    static let droidsAttackOwn:Bool = false
    static let droidsAttackOpp:Bool = false
    static let droidInitRandomAimVar:CGFloat = 80.0
    
    static let droidKillScore:Int = 100
    static let suakePlayerKillScore:Int = 250
    static let goodyKillScore:Int = 500
    
    static let medKitCatchScore:Int = 50
    static let weaponPickupCatchScore:Int = 50
    
    static let testOppAI:Bool = false
    
    static let showCountdown:Bool = false
    
//    static let droidScale:SCNVector3 = SCNVector3(0.34, 0.34, 0.34)
    static let droidModelAnimName:String = "unnamed_animation__1"
    static let droidModelAnimName2:String = "unnamed_animation__1_Head"
    static var dbgDroidFLTurnDuration:TimeInterval = 2.5
    static var initDroidDamage:CGFloat = 5.0
    
//    static let levelSize:CGFloat = 20
    
    static let initialCameraControl:AllowCameraControl = .Allow
    static let switchCameraDuration:TimeInterval = 0.45
    
    static let suakeScale:SCNVector3 = SCNVector3(10, 10, 10)
    static let droidScale:SCNVector3 = SCNVector3(0.34, 0.34, 0.34)
    static let goodyScale:SCNVector3 = SCNVector3(2.0, 2.0, 2.0)
    
    static var useGameCenter:Bool = true
    static var goodyPos:SCNVector3 = SCNVector3(x: -3, y: 0, z: 3)
    static let oppPos:SCNVector3 = SCNVector3(x: -2, y: 0, z: 0)
    static let ownPos:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    static var droidPos:SCNVector3 = SCNVector3(x: 3, y: 0, z: 3)
    
    static let showArrows:Bool = true
    
    static let reloadClipTimeout:TimeInterval = 3.0
    
    static let GRENADE_DAMAGE:CGFloat = 45.0
    static let MACHINEGUN_DAMAGE:CGFloat = 15.0
    static let SHOTGUN_PELLET_DAMAGE:CGFloat = 7.5
    static let RPG_DAMAGE:CGFloat = 55.0
    static let RAILGUN_DAMAGE:CGFloat = 69.0
    static let SNIPERRIFLE_DAMAGE:CGFloat = 69.0
    static let NUKE_DAMAGE:CGFloat = 100.0
    
    static let INITIAL_GRENADE_AMMOCOUNT:Int = 3
    
    
    static let INITIAL_SHOTGUN_AMMOCOUNT:Int = 25
    
    static let INITIAL_RAILGUN_AMMOCOUNT:Int = 30
    static let INITIAL_SNIPERRIFLE_AMMOCOUNT:Int = 20
    static let INITIAL_NUKE_AMMOCOUNT:Int = 3
    
    static let INITIAL_GRENADE_CLIPSIZE:Int = 1
    
    static let INITIAL_SHOTGUN_CLIPSIZE:Int = 5
    
    static let INITIAL_MACHINEGUN_AMMOCOUNT:Int = 30
    static let INITIAL_MACHINEGUN_CLIPSIZE:Int = 30
    static let INITIAL_MACHINEGUN_AMMORELOADCOUNT:Int = 30
    static let INITIAL_MACHINEGUN_CADENCE:TimeInterval = 0.25
    
    static let INITIAL_RPG_AMMOCOUNT:Int = 30
    static let INITIAL_RPG_CLIPSIZE:Int = 3
    static let INITIAL_RPG_AMMORELOADCOUNT:Int = 30
    static let INITIAL_RPG_CADENCE:TimeInterval = 0.75
    
    static let INITIAL_RAILGUN_CLIPSIZE:Int = 6
    static let INITIAL_SNIPERRIFLE_CLIPSIZE:Int = 5
    static let INITIAL_NUKE_CLIPSIZE:Int = 1
    
    static let HEALTHBAR_WIDTH:CGFloat = 200
    static let HEALTHBAR_WIDTH_OPP:CGFloat = 100
    
    static let HEALTHBAR_HEIGHT:CGFloat = 12
    static let HEALTHBAR_HEIGHT_OPP:CGFloat = 6
    
    static let DIR_ART:String = "art.scnassets/"
    static let DIR_NODES:String = SuakeVars.DIR_ART + "nodes/"
    static let DIR_TEXTURES:String = SuakeVars.DIR_ART + "textures/"
    static let DIR_SHADERS:String = SuakeVars.DIR_NODES + "levels/volcano/shader/"
    static let DIR_PARTICLES:String = SuakeVars.DIR_ART + "particles/"
    static let DIR_MONOWAV:String = SuakeVars.DIR_ART + "sound/mono/"
    static let DIR_OVERLAYICO:String = SuakeVars.DIR_ART + "overlays/icons/"
    
    
    static let PARTICLES_RPG_BURST:String = "ShotBurst"
    
    static let PARTICLES_EXPLOSION_BASIC:String = "ExplosionBasic"
    static let PARTICLES_EXPLOSION_RAILGUN:String = "ExplosionRailgun"
    
}
