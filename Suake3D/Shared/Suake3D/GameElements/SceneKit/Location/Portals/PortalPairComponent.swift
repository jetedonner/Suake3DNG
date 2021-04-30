//
//  PortalPairComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 25.09.20.
//  Copyright © 2020 Kim David Hauser. All rights reserved.
//

import Foundation
import GameplayKit
import SceneKit

class PortalPairComponent: SuakeBaseComponent {
    
    let locationType:LocationType = .Portal
    var aPortal:BasePortalComponent!
    var bPortal:BasePortalComponent!
    
    var portals:[BasePortalComponent] = [BasePortalComponent]()
    let id:Int
    
    init(game: GameController, id:Int = 0) {
        self.id = id
        super.init(game: game)
        self.aPortal = BasePortalComponent(game: game, id: id)
        self.bPortal = BasePortalComponent(game: game, id: id)
        
        self.aPortal.otherPortal = self.bPortal
        self.bPortal.otherPortal = self.aPortal
        
        self.portals.append(self.aPortal)
        self.portals.append(self.bPortal)
        
    }
    
    func initSetupPos(addToScene:Bool = true){
        for portal in portals{
            portal.initSetupPos()
        }
   }
   
   func addToScene() {
       for portal in portals{
           portal.addToScene()
       }
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
