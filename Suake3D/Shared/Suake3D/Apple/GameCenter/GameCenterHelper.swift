/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import GameKit

class GameCenterHelper: NSObject {
    typealias CompletionBlock = (Error?) -> Void
    
    private let leaderboardID = "grp.ch.kimhauser.swift.suake3d"
    
    private var scores: [(playerName: String, score: Int)]?
    
    private var leaderboard: GKLeaderboard?
    
    var gameModel:GameModel = GameModel()
    var match: GKMatch?
//    private var achivements10HeadshotsID = "grp.ch.kimhauser.swift.suake3d.achievements.10headshots"
//    private var achivements10Headshots:GKAchievement?
//    private var achivements20GoodiesID = "grp.ch.kimhauser.swift.suake3d.achievements.20goodies"
//    private var achivements20Goodies:GKAchievement?
//
//    public var headShots:Int = 0
//    public let headShots10AchievementCount:Int = 10
    
    static let helper = GameCenterHelper()
    static let achievements:Suake3DAchievements = Suake3DAchievements()
  
    static var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }

    var viewController: NSViewController?
    var currentMatchmakerVC: GKTurnBasedMatchmakerViewController?
    var currentMatchmakerVC2: GKMatchmakerViewController?
    enum GameCenterHelperError: Error {
        case matchNotFound
    }

    var currentMatch: GKTurnBasedMatch?
    
    weak var delegate: GameCenterHelperDelegate?
    
    let minPlayers:Int = 2
    let maxPlayers:Int = 2
    let inviteMessage:String = "Hey there join me for a Suake3D fight!"
    var currentVC: GKMatchmakerViewController?
    
    
    func resetAllCompletedAchivements(){
        GameCenterHelper.achievements.resetAllCompletedAchivements()
    }
        
    func getAllCompletedAchivements(){
        GameCenterHelper.achievements.getAllCompletedAchivements()
//        if GKLocalPlayer.localPlayer().isAuthenticated {
//            GKAchievement.loadAchievements(completionHandler: { achievements, error in
//                if error != nil {
//                    if let error = error {
//                        print("Error in loading achievements: \(error)")
//                    }
//                }
//                if achievements != nil {
//                    for achievement in achievements! {
//                        if(achievement.isCompleted){
//                            print("Achievements: ID: " + achievement.identifier! + ", " + achievement.percentComplete.description + "% complete")
//                            if(achievement.identifier == GameCenterHelper.achievements.achivements10HeadshotsID){
//
//                            }
////                            if(achievement.identifier == self.achivements10HeadshotsID){
////                                self.headShots = self.headShots10AchievementCount
////                            }
//                        }
//                    }
//                }
//            })
//        }
    }
    
    func loadAchievements() {
        
    }
    
    
    
//    func showLeaderboard() {
//        let gcViewController = GKGameCenterViewController()
//        gcViewController.gameCenterDelegate = self
//        gcViewController.viewState = .leaderboards
//        gcViewController.leaderboardIdentifier = self.leaderboardID
//        gcViewController.title = "Suake3D - Game Center"
//        self.viewController?.presentAsModalWindow(gcViewController)
//    }

    var canTakeTurnForCurrentMatch: Bool {
        guard let match = currentMatch else {
          return true
        }
        return match.isLocalPlayersTurn
    }
    
    func loadScores(finished: @escaping ([(playerName: String, score: Int)]?)->()) {
        // fetch leaderboard from Game Center
        fetchLeaderboard { [weak self] in
            if let localLeaderboard = self?.leaderboard {
                // set player scope as .global (it's set by default) for loading all players results
                localLeaderboard.playerScope = .global
                // load scores and then call method in closure
                localLeaderboard.loadScores { [weak self] (scores, error) in
                    // check for errors
                    if error != nil {
                        print(error!)
                    } else if scores != nil {
                        // assemble leaderboard info
                        var leaderBoardInfo: [(playerName: String, score: Int)] = []
                        for score in scores! {
                            let name = score.player.alias
                            let userScore = Int(score.value)
                            leaderBoardInfo.append((playerName: name, score: userScore))
                        }
                        self?.scores = leaderBoardInfo
                        // call finished method
                        finished(self?.scores)
                    }
                }
            }
        }
    }
    
    // update local player score
    
    func updateScore(with value: Int) {
//        let board = GKLeaderboard()
//        board.baseLeaderboardID = leaderboardID
        GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID] , completionHandler: { _ in
            
        })
        // take score
//        let score = GKScore(leaderboardIdentifier: leaderboardID)
//        // set value for score
//        score.value = Int64(value)
//        // push score to Game Center
//        GKScore.report([score]) { (error) in
//            // check for errors
//            if error != nil {
//                print("Score updating -- \(error!)")
//            }
//        }
    }
    
    // fetching leaderboard method
    
    private func fetchLeaderboard(finished: @escaping () -> ()) {
        // check if local player authentificated or not
        if GKLocalPlayer.local.isAuthenticated {
            // load leaderboard from Game Center
            GKLeaderboard.loadLeaderboards(IDs: [leaderboardID], completionHandler: { leaderboards, error in
                
            //}) { [weak self] (leaderboards, error) in
                // check for errors
                if error != nil {
//                    print("Fetching leaderboard -- \(error!)")
                } else {
                    // if leaderboard exists
                    if leaderboards != nil {
                        for leaderboard in leaderboards! {
                            // find leaderboard with given ID (if there are multiple leaderboards)
                            if leaderboard.identifier == self.leaderboardID {
                                self.leaderboard = leaderboard
                                finished()
                            }
                        }
                    }
                }
            })
        }
    }
  
    override init() {
        super.init()
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
  
  func presentMatchmaker() {
    guard GKLocalPlayer.local.isAuthenticated else {
      return
    }
    
    let request = GKMatchRequest()
    
    request.minPlayers = 2
    request.maxPlayers = 2
    request.defaultNumberOfPlayers = 2
    request.inviteMessage = "Would you like to play Suake3D?"
    let vc = GKMatchmakerViewController(matchRequest: request)
    vc?.matchmakerDelegate = self
    //let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
    //vc.turnBasedMatchmakerDelegate = self
    
    currentMatchmakerVC2 = vc
    //viewController?.present(vc, animated: true)
    self.viewController?.presentAsSheet(vc!)
  }
    
    func showAchivementsView(){
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController(achievementID: Suake3DAchievements().achivements3GoodiesID)
            gcViewController.gameCenterDelegate = self

    //            gcViewController.viewState = GKGameCenterViewControllerState.achievements
        self.viewController?.presentAsSheet(gcViewController)
}
  
  func endTurn(/*_ model: GameModel,*/ completion: @escaping CompletionBlock) {
//    guard let match = currentMatch else {
//      completion(GameCenterHelperError.matchNotFound)
//      return
//    }

//    do {
//      match.message = model.messageToDisplay
//
//      match.endTurn(
//        withNextParticipants: match.others,
//        turnTimeout: GKExchangeTimeoutDefault,
//        match: try JSONEncoder().encode(model),
//        completionHandler: completion
//      )
//    } catch {
//      completion(error)
//    }
  }

  func win(completion: @escaping CompletionBlock) {
    guard let match = currentMatch else {
      completion(GameCenterHelperError.matchNotFound)
      return
    }
    
    match.currentParticipant?.matchOutcome = .won
    match.others.forEach { other in
      other.matchOutcome = .lost
    }
    
    match.endMatchInTurn(
      withMatch: match.matchData ?? Data(),
      completionHandler: completion
    )
  }
}

extension GameCenterHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(true)
    }
}

//    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
//        viewController.dismiss(true)
//        //viewController.
////        print("Matchmaker vc was cancelled.")
//    }
//    
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
////        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
//    }
//}
//
//extension GameCenterHelper: GKTurnBasedMatchmakerViewControllerDelegate {
//  func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
//    viewController.dismiss(true)
//  }
//
//  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
////    print("Matchmaker vc did fail with error: \(error.localizedDescription).")
//  }
//}

extension GameCenterHelper: GKLocalPlayerListener {
  func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
    let activeOthers = match.others.filter { other in
      return other.status == .active
    }

    match.currentParticipant?.matchOutcome = .lost
    activeOthers.forEach { participant in
      participant.matchOutcome = .won
    }

    match.endMatchInTurn(
      withMatch: match.matchData ?? Data()
    )
  }
    

  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
    if let vc = currentMatchmakerVC {
      currentMatchmakerVC = nil
        vc.dismiss(true)
    }

    guard didBecomeActive else {
      return
    }

    NotificationCenter.default.post(name: Notification.Name.presentGame, object: match)
  }
}

extension Notification.Name {
  static let presentGame = Notification.Name(rawValue: "presentGame")
  static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}

extension GKTurnBasedMatch {
    var isLocalPlayersTurn: Bool {
        return currentParticipant?.player == GKLocalPlayer.local
    }
    
    var others: [GKTurnBasedParticipant] {
        return participants.filter {
            return $0.player != GKLocalPlayer.local
        }
    }
}
