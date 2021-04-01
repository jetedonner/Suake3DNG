//
//  SuakeAchivement.swift
//  Suake3D
//
//  Created by Kim David Hauser on 29.03.21.
//

import Foundation
import SceneKit
import GameKit

protocol SuakeAchievementCheckerDelegate {
    func checkAchievementGoal(achievement:SuakeAchievement)->Bool
}

class SuakeAchievement {
    
    private let delegate:SuakeAchievementCheckerDelegate
    public let achievementID:SuakeAchievementTypes
    
    private var _achievementGoalCount:Int = 0
    public var achievementGoalCount:Int{
        get{ return self._achievementGoalCount }
        set{ self._achievementGoalCount = newValue }
    }
    
    private var _achievementCount:Int = 0
    public var achievementCount:Int{
        get{ return self._achievementCount }
        set{ self._achievementCount = newValue }
    }
    
    init(achievementID:SuakeAchievementTypes, delegate:SuakeAchievementCheckerDelegate, achievementGoalCount:Int = 1) {
        self.achievementID = achievementID
        self.delegate = delegate
        self.achievementGoalCount = achievementGoalCount
    }
    
    func checkAchievementGoal()->Bool{
        return self.delegate.checkAchievementGoal(achievement: self)
    }
}
