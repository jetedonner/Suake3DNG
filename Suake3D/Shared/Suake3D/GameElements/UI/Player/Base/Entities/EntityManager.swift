import Foundation
import SceneKit
import GameplayKit

class EntityManager:SuakeGameClass {

    var entities:[LocationType:Set<SuakeBaseNodeEntity>] = [:]
    var entityGroups:[LocationType:Set<SuakeNodeGroupBase>] = [:]

    override init(game:GameController) {
        super.init(game: game)
    }

    func add(locationType:LocationType, entity: SuakeBaseNodeEntity) {
        if(self.entities[locationType] == nil){
            self.entities[locationType] = Set<SuakeBaseNodeEntity>()
        }
        self.entities[locationType]?.insert(entity)
    }

    func remove(locationType:LocationType, entity: SuakeBaseNodeEntity) {
        if(self.entities[locationType] != nil && self.entities[locationType]!.count > 0){
            self.entities[locationType]?.remove(entity)
        }
    }
    
    func add(locationType:LocationType, entityGroup: SuakeNodeGroupBase) {
        if(self.entityGroups[locationType] == nil){
            self.entityGroups[locationType] = Set<SuakeNodeGroupBase>()
        }
        self.entityGroups[locationType]?.insert(entityGroup)
    }

    func remove(locationType:LocationType, entityGroup: SuakeNodeGroupBase) {
        if(self.entityGroups[locationType] != nil && self.entityGroups[locationType]!.count > 0){
            self.entityGroups[locationType]?.remove(entityGroup)
        }
    }
}
