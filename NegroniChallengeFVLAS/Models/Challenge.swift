//
//  Challenge.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 17/11/24.
//

import SwiftUI
import SwiftData

enum GoalType: String, Codable, CaseIterable {
    case steps 
    case kilometers
}

struct DailyProgress: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

@Model
class Challenge: Identifiable {
    var id: UUID = UUID()
    var goalType: GoalType
    var duration: Int
    var goal: Double
    var startDate: Date
    var endDate: Date?
    var isCompleted: Bool
    var streak: Int
    var reward: Int
    
    init(goalType: GoalType, duration: Int, goal: Double, startDate: Date = Date(), endDate: Date? = nil, isCompleted: Bool = false, streak: Int = 0, reward: Int = 0) {
        self.id = UUID()
        self.goalType = goalType
        self.duration = duration
        self.goal = goal
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = isCompleted
        self.streak = streak
        self.reward = reward
    }
    
    func updateReward(goalType: GoalType, goal: Double) -> Int {
        switch goalType {
        case .steps:
            // Ogni 1500 passi danno 10 coin
            return Int(goal / 1000) * 10
            
        case .kilometers:
            // Ogni 1 km dà 10 coin
            return Int(goal * 10)
        }
    }
    
    func calculateRemainingDays(from startDate: Date, duration: Int) -> Int {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .weekOfYear, value: duration, to: startDate)!
        let daysRemaining = calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        return max(0, daysRemaining)
    }
    
    func completeChallenge() {
        if !isCompleted {
            self.isCompleted = true
            self.endDate = Date()  // Imposta l'endDate con la data corrente
        }
    }
    
}
