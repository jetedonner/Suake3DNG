//
//  GameCenterHelperNG.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.03.21.
//

import Foundation
import GameKit

class GameCenterHelperNG: SuakeGameClass, GKLocalPlayerListener{
    
//    static var helper:GameCenterHelperNG!
    
    let achievements:SuakeAchievements
    var viewController: NSViewController?
    
    override init(game: GameController) {
        self.achievements = SuakeAchievements(game: game)
        
        super.init(game: game)
        
        self.viewController = (self.game.scnView as! GameViewMacOS).viewController
        
        if(SuakeVars.useGameCenter){
            self.authenticate()
        }
    }
    
    func authenticate(){
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
          NotificationCenter.default.post(name: Notification.Name.authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)

          if GKLocalPlayer.local.isAuthenticated {
//            print("Authenticated to Game Center!")
            GKLocalPlayer.local.register(self)
            GKAccessPoint.shared.parentWindow = self.viewController?.view.window
            GKAccessPoint.shared.location = .bottomLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = GKLocalPlayer.local.isAuthenticated
          } else if let vc = gcAuthVC {
            self.viewController?.presentAsModalWindow(vc)//(vc, animator: NSViewControllerPresentationAnimator).present(vc, animated: true)
          }
          else {
            print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
          }
        }
    }
    
    func checkAchievement(achievementID:SuakeAchievementTypes)->Bool{
        return self.achievements.checkAchievement(achievementID: achievementID)
    }
}
