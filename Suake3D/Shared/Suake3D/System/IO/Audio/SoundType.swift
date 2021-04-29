//
//  SoundType.swift
//  Suake3D
//
//  Created by dave on 23.04.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation

enum SoundType: Int {
    case railgun = 1, shotgunAimed, railgunAimed, railgunUnaimed, redeemerAimed, redeemerUnaimed, shotgun, rifle, rpg, grenade, grenadeExplosion, sinperrifle, wp_change, pick_goody, pick_weapon, teleporter, bottleRocket, machineGun3, machineGun4, noammo, pain_25, pain_50, pain_75, pain_100, explosion1, explosion, hitEnemy, beep, beep2, weaponreload, riochet1, riochet2, riochet3, gunSilencer, bltImpactMetal1, bltImpactMetal2, bltImpactMetal3, die, fire, menu1, menuItemChoosen, menuItemChanged, nukeLaunch, nukeExplosion, first_blood, health, laser, volcano, pickupHealth, none
}

enum SoundTypeQuake: Int {
    case fight = 1, play, prepare, you_win, you_lose, headshot, tied_lead, taken_lead, lost_lead, perfect, new_highscore, youHaveTheFlag, enemyHasTheFlag, none
}
