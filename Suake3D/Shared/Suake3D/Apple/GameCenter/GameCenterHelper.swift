//
//  GameCenterHelper.swift
//  Suake3D
//
//  Created by Kim David Hauser on 06.04.21.
//

import Foundation
import GameKit

protocol GameCenterHelperDelegate: class {
    
//    func didChangeAuthStatus(isAuthenticated: Bool)
    func startMatch(match: GKMatch)
//    func presentGameCenterAuth(viewController: NSViewController?)
//    func presentMatchmaking(viewController: NSViewController?)
//    func presentGame(match: GKMatch)
    
    // func startGame
    // - func initLevel
    // - func initMatch
    
    // func turnDirChanged
    
    // func endGame
}

class GameCenterHelper: SuakeGameClass {
    
//    static let helper = GameCenterHelper()
    
    let inviteMessage:String = "Hey there join me for a Suake3D fight!"
    var currentVC: GKMatchmakerViewController?
    
    var viewController: NSViewController?
    var delegate:GameCenterHelperDelegate?
    
    var matchMakerHelper:MatchMakerHelper?
    
    override init(game:GameController) {
        super.init(game: game)
        
        self.viewController = (self.game.scnView as! GameViewMacOS).viewController
        self.delegate = game
        self.matchMakerHelper = MatchMakerHelper(game: game)
        
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
//            print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
          }
        }
    }
}

extension Notification.Name {
  static let presentGame = Notification.Name(rawValue: "presentGame")
  static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
