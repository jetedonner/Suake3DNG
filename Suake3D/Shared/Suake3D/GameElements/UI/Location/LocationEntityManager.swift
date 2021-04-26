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
    
    var portalPairs:[PortalEntityPair] = [PortalEntityPair]()
    var portals:[PortalEntity] = [PortalEntity]()
    var containers:[ContainerGroupItem] = [ContainerGroupItem]()
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initLocations(medKitPos:[SCNVector3]? = nil){
        let respawnTestEntity:RespawnPointEntity = RespawnPointEntity(game: self.game, id: 0)
        self.add(locationType: .RespawnPoint, entity: respawnTestEntity)
        
        let medKitEntityGroup:MedKitEntityGroup = MedKitEntityGroup(game: self.game, medKitPos: medKitPos)
        
        self.add(locationType: .MedKit, entityGroup: medKitEntityGroup)
        
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadObstacles){
            let container:ContainerGroupItem = ContainerGroupItem(game: self.game, id: 0)
            self.containers.append(container)
        }
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
    
    func addLocationGroupsToScene(initPos:Bool = true){
        for (key, value) in self.entityGroups{
            if(key == .MedKit){
                for ent in value.enumerated(){
                    for medKitEntity in (ent.element as! MedKitEntityGroup).groupItems{
                        (medKitEntity as! MedKitEntity).add2Scene(initPos: initPos)
                    }
                }
            }
        }
        if(self.containers != nil && self.containers.count > 0){
            self.containers[0].containerComponent.addToScene()
        }
    }
    
    func removeLocationGroupsFromScene(){
        for (key, value) in self.entityGroups{
            if(key == .MedKit){
                for ent in value.enumerated(){
                    for medKitEntity in (ent.element as! MedKitEntityGroup).groupItems{
                        (medKitEntity as! MedKitEntity).medKitComponent.node.removeFromParentNode()
                    }
                }
            }
        }
        self.entityGroups.removeValue(forKey: .MedKit)
    }
}
