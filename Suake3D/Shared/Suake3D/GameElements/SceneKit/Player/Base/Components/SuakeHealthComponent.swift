//
//  HealthComponent.swift
//  Suake3D
//
//  Created by Kim David Hauser on 14.06.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

protocol SuakeHealthComponentDelegate {
    func playerDied()
}

class SuakeHealthComponent:SuakeBaseComponent{
    
    var delegate:SuakeHealthComponentDelegate!
    
    let maxHealth:CGFloat = 300.0
    let initHealth:CGFloat = 100.0
    
    var _health:CGFloat = 100.0
    var health:CGFloat{
        get{ return _health }
        set{ self._health = newValue }
    }
    
    var _died:Bool = false
    var died:Bool{
        get{ return self._died /*self.health <= 0.0*/ }
        set{ self._died = newValue }
    }
    
    override init(game: GameController) {
        super.init(game: game)
    }
    
    func resetHealth(){
        self.health = self.initHealth
    }
    
    @discardableResult
    func addHealth(addVal:CGFloat)->Bool{
        if(self.health + addVal <= self.maxHealth){
            self.health = self.health + addVal
            return true
        }else{
            self.health = self.maxHealth
            return false
        }
    }
    
    @discardableResult
    func decHealth(decVal:CGFloat)->Bool{
        self.health = self.health - decVal
        if(self.health <= 0.0){
            self.health = 0.0
            self.died = true
            if(self.delegate != nil){
                self.delegate.playerDied()
            }
        }
        return self.died
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
