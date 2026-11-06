//
//  EditActiveChallengeView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 18/11/24.
//

import SwiftUI
import SwiftData

struct EditActiveChallengeView: View {
    
    @Bindable var challenge: Challenge
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert: Bool = false

    
    @State private var tempDuration: Int
    @State private var tempGoalType: GoalType
    @State private var tempGoal: Double
    
    init(challenge: Challenge) {
        self.challenge = challenge
        _tempDuration = State(initialValue: challenge.duration)
        _tempGoalType = State(initialValue: challenge.goalType)
        _tempGoal = State(initialValue: challenge.goal)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Duration").font(.headline)) {
                    Picker("Duration", selection: $tempDuration) {
                        ForEach(1..<5, id: \.self) { week in
                            Text("\(week) week(s)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Goal").font(.headline)) {
                    if tempGoalType == .steps {
                        Stepper(value: Binding(
                            get: { tempGoal },
                            set: { newValue in
                                if newValue >= challenge.goal {
                                    tempGoal = newValue
                                }
                            }),
                                in: challenge.goal...50000,
                                step: 1000
                        ) {
                            Text("Steps Goal: \(tempGoal, specifier: "%.1f")")
                        }
                    } else {
                        Stepper(value: Binding(
                            get: { tempGoal },
                            set: { newValue in
                                if newValue >= challenge.goal {
                                    tempGoal = newValue
                                }
                            }),
                                in: challenge.goal...50,
                                step: 0.5
                        ) {
                            Text("Distance Goal: \(tempGoal, specifier: "%.1f") km")
                        }
                    }
                    
                }
            }
            HStack {
                Spacer()
                Button("Delete Challenge") {
                    showDeleteAlert = true // Show the delete confirmation alert
                }
                .padding()
                Spacer()
            }
            
            .navigationTitle("Edit Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss() // Chiude senza salvare
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges() // Salva e chiude
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Active Challenge?"),
                    message: Text("You will lose all your progress.")
                        .font(.footnote) // Smaller text
                        .foregroundColor(.gray), // Gray color
                    primaryButton: .destructive(Text("Delete")) {
                        deleteChallenge() // Call delete method
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        showDeleteAlert = false // Close alert
                    }
                )
            }
        }
    }
    
    private func deleteChallenge() {
        // Delete the challenge from the modelContext
        modelContext.delete(challenge)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete challenge: \(error.localizedDescription)")
        }
        
        dismiss() // Dismiss the view after deletion
        
    }
    
    private func saveChanges() {
        challenge.duration = tempDuration
        challenge.goalType = tempGoalType
        challenge.goal = tempGoal
        challenge.reward = challenge.updateReward(goalType: tempGoalType, goal: tempGoal)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditActiveChallengeView(challenge: Challenge(goalType: .steps, duration: 30, goal: 10000, startDate: Date(), isCompleted: false))
}
