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
    var generators:[GeneratorGroupItem] = [GeneratorGroupItem]()
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func initLocations(medKitPos:[SCNVector3]? = nil){
        let respawnTestEntity:RespawnPointEntity = RespawnPointEntity(game: self.game, id: 0)
        self.add(locationType: .RespawnPoint, entity: respawnTestEntity)
        
        let medKitEntityGroup:MedKitEntityGroup = MedKitEntityGroup(game: self.game, medKitPos: medKitPos)
        
        self.add(locationType: .MedKit, entityGroup: medKitEntityGroup)
        
        if(self.game.levelManager.currentLevel.levelConfig.levelSetup.loadObstacles){
            for i in 0..<self.game.levelManager.currentLevel.levelConfig.levelSetup.obstacleCount{
                let container:ContainerGroupItem = ContainerGroupItem(game: self.game, id: i)
                self.containers.append(container)
            }
            
            for i in 0..<self.game.levelManager.currentLevel.levelConfig.levelSetup.obstacleCount{
                let generator:GeneratorGroupItem = GeneratorGroupItem(game: self.game, id: i)
                self.generators.append(generator)
            }
        }
    }
    
    func addPortalEntities(numberOfPortals:Int) {
        for i in (0..<numberOfPortals){
            let newPortalEntityPair:PortalEntityPair = PortalEntityPair(game: self.game, id: i)
            self.portalPairs.append(newPortalEntityPair)
            
            self.addPortalEntity(portalEntity: newPortalEntityPair.portalEntityA)
            self.addPortalEntity(portalEntity: newPortalEntityPair.portalEntityB)
        }
    }
    
    func addPortalEntity(portalEntity:PortalEntity){
        self.portals.append(portalEntity)
        portalEntity.portalComponent.addToScene()
        portalEntity.portalComponent.initSetupPos()
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
            for container in self.containers{
                container.containerComponent.addToScene()
            }
        }
        
        if(self.generators != nil && self.generators.count > 0){
            for generator in self.generators{
                generator.generatorComponent .addToScene()
            }
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
