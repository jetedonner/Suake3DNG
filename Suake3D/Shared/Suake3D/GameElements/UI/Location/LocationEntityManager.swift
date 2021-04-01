//
//  LocationEntityManager.swift
//  Suake3D
//
//  Created by Kim David Hauser on 15.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class LocationEntityManager: EntityManager {
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initLocations(){
        let respawnTestEntity:RespawnPointEntity = RespawnPointEntity(game: self.game, id: 0)
        self.add(locationType: .RespawnPoint, entity: respawnTestEntity)
        
        let medKitEntityGroup:MedKitEntityGroup = MedKitEntityGroup(game: self.game)
        
        self.add(locationType: .MedKit, entityGroup: medKitEntityGroup)
    }
    
    func addLocationToScene(pos:SCNVector3){
        for (key, value) in self.entities{
            if(key == .RespawnPoint){
                for ent in value.enumerated(){
                    (ent.element as! RespawnPointEntity).showRespawnPoint(pos: pos)
                }
            }
        }
    }
    
    func addLocationGroupsToScene(){
        for (key, value) in self.entityGroups{
            if(key == .MedKit){
                for ent in value.enumerated(){
                    for medKitEntity in (ent.element as! MedKitEntityGroup).groupItems{
                        (medKitEntity as! MedKitEntity).add2Scene()
                    }
                }
            }
        }
    }
}
