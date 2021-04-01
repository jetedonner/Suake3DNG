//
//  CrosshairEntity.swift
//  Suake3D
//
//  Created by Kim David Hauser on 17.03.21.
//

import Foundation
import SceneKit
import GameplayKit

class CrosshairEntity: SuakeBaseEntity {
    
    let nodeContainer:SKNode = SKNode()
    let mgCrosshairComponent:MachinegunCrosshairComponent
    
    var allCrosshairComponents:[BaseCrosshairComponent]!
    
    let reloadIndicatorComponent:ReloadIndicatorComponent
    
    var _currentCrosshairComponent:BaseCrosshairComponent!
    var currentCrosshairComponent:BaseCrosshairComponent{
        get{ return self._currentCrosshairComponent }
        set{ self._currentCrosshairComponent = newValue }
    }
    
    var _isHidden:Bool = false
    var isHidden:Bool{
        get{ return self._isHidden }
        set{
            self._isHidden = newValue
            self.nodeContainer.isHidden = newValue
//            if((self.currentWeaponType == .redeemer && !newValue) || newValue){
//                self.redeemerCrosshairComponent.isHidden = newValue
//            }
        }
    }
    
    var _currentWeaponType:WeaponType = .none
    var currentWeaponType:WeaponType{
        get {
            // we need a helper variable to store the result.
            // inside a void closure you are not allow to "return"
            var retCurrentWeaponType:WeaponType = .none
//            currentWeaponTypeDataQueue.sync{
                retCurrentWeaponType = _currentWeaponType
//            }
            return retCurrentWeaponType
        }
        set (newValue) {
//            currentWeaponTypeDataQueue.async(flags: .barrier) {
                self._currentWeaponType = newValue
//            }
        }
    }
    
    override init(game: GameController, id: Int = 0) {
        self.mgCrosshairComponent = MachinegunCrosshairComponent(game: game)
        
        self.reloadIndicatorComponent = ReloadIndicatorComponent(game: game)
        super.init(game: game, id: id)
        
        self.allCrosshairComponents = [self.mgCrosshairComponent]
        self.currentCrosshairComponent = self.allCrosshairComponents.first!
    }
    
    func setCurrentWeaponType(weaponType:WeaponType){
        self.currentWeaponType = weaponType
        for weaponComponent in self.allCrosshairComponents{
            weaponComponent.isHidden = weaponComponent.weaponType != weaponType
        }
    }
    
    func addToHUD(hud:HUDOverlayScene){
        for csComponent in self.allCrosshairComponents{
            self.nodeContainer.addChild(csComponent.node)
        }
        self.nodeContainer.addChild(self.reloadIndicatorComponent.node)
        self.nodeContainer.position = CGPoint(x: hud.frame.width / 2, y: hud.frame.height / 2)
        hud.sceneNode.addChild(self.nodeContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
