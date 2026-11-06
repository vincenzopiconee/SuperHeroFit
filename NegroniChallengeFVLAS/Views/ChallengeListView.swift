//
//  ChallengeListView.swift
//  NegroniChallengeFVLAS
//
//  Created by Lorenzo Pizzuto on 11/11/24.
//

import SwiftUI

struct ChallengeListView: View {
    // Mock data model for challenges
    struct Challenge: Identifiable {
        let id = UUID()
        let title: String
        let startDate: String
        let endDate: String
        let stepsGoal: Int
        let status: String // "Completed" or "In Progress"
    }
    
    // Sample data
    let challenges: [Challenge] = [
        Challenge(title: "Challange #1", startDate: "01 Nov 2024", endDate: "07 Nov 2024", stepsGoal: 50000, status: "Completed"),
        Challenge(title: "Challange #2", startDate: "15 Oct 2024", endDate: "21 Oct 2024", stepsGoal: 70000, status: "Completed"),
        Challenge(title: "Challange #3", startDate: "11 Nov 2024", endDate: "13 Nov 2024", stepsGoal: 20000, status: "In Progress")
    ]
    
    var body: some View {
        NavigationView {
            List(challenges) { challenge in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(challenge.title)
                            .font(.headline)
                        Text("From: \(challenge.startDate) to \(challenge.endDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Goal: \(challenge.stepsGoal) steps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(challenge.status)
                        .font(.footnote)
                        .foregroundColor(challenge.status == "Completed" ? .green : .orange)
                        .padding(5)
                        .background(challenge.status == "Completed" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .cornerRadius(5)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Old Challenges")
        }
    }
}


#Preview {
    ChallengeListView()
}
