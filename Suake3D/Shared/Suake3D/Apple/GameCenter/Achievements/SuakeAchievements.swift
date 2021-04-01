//
//  SuakeAchievements.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.03.21.
//

import Foundation
import GameKit

class SuakeAchievements: SuakeGameClass, SuakeAchievementCheckerDelegate{
    
    var allAchievements:[SuakeAchievement] = [SuakeAchievement]()
    
    override init(game: GameController) {
        super.init(game: game)
        self.loadAllAchievements()
    }
    
    func loadAllAchievements(){
        self.allAchievements.append(SuakeAchievement(achievementID: SuakeAchievementTypes.tutorial00_01, delegate: self))
    }
    
    func checkAchievement(achievementID:SuakeAchievementTypes)->Bool{
        if let achievement = self.allAchievements.first(where: {$0.achievementID == achievementID} ){
            return achievement.checkAchievementGoal()
        }
        return false
    }
    
    func checkAchievementGoal(achievement: SuakeAchievement) -> Bool {
        var bRet:Bool = false
        if(achievement.achievementID == SuakeAchievementTypes.tutorial00_01){
            if(self.game.levelManager.currentLevel == self.game.levelManager.dbgLevel &&  self.game.stateMachine.currentState is SuakeStateMatchOver){
                bRet = true
            }
        }
        if(bRet){
            self.completeAchivement(identifier: achievement.achievementID.rawValue)
        }
        return bRet
    }
    
    func completeAchivement(identifier:String, percent:Double = 100.0, message:String? = nil){
        if GKLocalPlayer.local.isAuthenticated {
            let achivement:GKAchievement = GKAchievement(identifier: identifier, player: GKLocalPlayer.local)
            achivement.showsCompletionBanner = true
            achivement.percentComplete = percent
            GKAchievement.report([achivement], withCompletionHandler: { error in
                
            })
//            if(message != nil){
//                self.showBanner(title: "Achivement completed", message: message!)
//            }
        }
    }
    
}
