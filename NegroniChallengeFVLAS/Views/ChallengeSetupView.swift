//
//  ChallengeSetupView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 17/11/24.
//
import SwiftUI
import SwiftData
import HealthKit

struct ChallengeSetupView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext  // Contesto per SwiftData
    
    @State private var selectedDuration: Int = 1  // Durata della challenge in settimane
    @State private var selectedGoalType: String = "Steps"  // Tipo di obiettivo (passi o chilometri)
    
    @State private var stepsGoal: Int = 10000  // Obiettivo di passi
    @State private var distanceGoal: Double = 6.5  // Obiettivo di distanza in chilometri
    
    @State private var reward: Int = 100  // Variabile per tenere traccia del reward calcolato
    
    @StateObject private var healthKitManager = HealthKitManager()  // Manager per interagire con HealthKit
    //@State private var challengeStarted = false  // Flag per sapere se la challenge è iniziata
    @State private var showAlert = false
    
    @State private var healthKitAccessDenied = false  // Mostra un avviso se l'accesso a HealthKit è negato


    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 50) {
                
                HStack() {
                    Text("Duration")
                        .font(.headline)
                    Spacer()
                    
                    Picker("Duration", selection: $selectedDuration) {
                        ForEach(1..<5, id: \.self) { week in
                            Text("\(week) week(s)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .padding(.top)
                .padding(.horizontal)
                
                // Selezione dell'obiettivo (Passi o Distanza)
                HStack() {
                    Text("Choose Your Goal")
                        .font(.headline)
                    Spacer()
                    Picker("Goal Type", selection: $selectedGoalType) {
                        Text("Steps").tag("Steps")
                        Text("Kilometers").tag("Kilometers")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedGoalType) {
                        // Calcolare il reward ogni volta che cambia il goal type
                        updateReward()
                    }
                }
                .padding(.horizontal)
                
                // Selezione del goal specifico (Passi o Distanza)
                VStack(alignment: .leading) {
                    if selectedGoalType == "Steps" {
                        // Se è selezionato "Passi"
                        Text("Steps Goal")
                            .font(.headline)
                        
                        Stepper("Steps Goal: \(stepsGoal)", value: $stepsGoal, in: 1000...50000, step: 1000)
                            .onChange(of: stepsGoal) {
                                // Calcolare il reward ogni volta che cambia il valore del goal
                                updateReward()
                            }
                    } else {
                        // Se è selezionato "Distanza"
                        Text("Distance Goal (km)")
                            .font(.headline)
                        
                        Stepper("Distance Goal: \(distanceGoal, specifier: "%.1f") km", value: $distanceGoal, in: 1...50, step: 0.5)
                            .onChange(of: distanceGoal) {
                                // Calcolare il reward ogni volta che cambia il valore del goal
                                updateReward()
                            }
                    }
                    
                    // Mostra il reward calcolato sotto lo stepper
                    HStack (spacing: 2){
                        Spacer()
                        Text("Reward: \(reward)")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                        Image("superherobyfede")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Spacer()
                    }
                    .padding(.top)
                    
                }
                .padding(.horizontal)
            }
            Spacer()
            Button(action: {showAlert = true}) {
                Text("Start Challenge")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: 250)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(17)
            }
            .padding()
            Spacer()
            .onAppear {
                // Richiedere permessi a HealthKit quando la vista appare
                healthKitManager.requestAuthorization { success in
                    if success {
                        print("HealthKit authorization successful.")
                    } else {
                        // Gestisci l'errore
                        print("HealthKit authorization failed.")
                    }
                }
            }
            .navigationTitle("Challenge Setup")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()  // Chiudi il foglio quando si preme "Cancel"
                        print("Dismiss called")
                    }
                }
                
            }
            .alert("Confirm Challenge", isPresented: $showAlert) {
                Button("Confirm") {
                    startChallenge()  // Procedi con il salvataggio e chiudi la vista
                    
                }
                Button("Cancel", role: .cancel) {
                    // Non fare nulla, l'alert si chiude automaticamente
                    
                }
            } message: {
                Text("Are you sure you want to start this challenge?")
                
            }
            
            .alert("HealthKit Access Denied", isPresented: $healthKitAccessDenied) {
                Button("OK") {
                    healthKitAccessDenied = false
                }
            } message: {
                Text("The challenge won't track your progress until you grant HealthKit access. Please go to Settings to enable it.")
            }

        }
    }
    
    // Funzione per calcolare il reward
    private func calculateReward(goalType: GoalType, goal: Double) -> Int {
        switch goalType {
        case .steps:
            // Ogni 1500 passi danno 10 coin
            return Int(goal / 1000) * 10
            
        case .kilometers:
            // Ogni 1 km dà 10 coin
            return Int(goal * 10)
        }
    }
    
    // Funzione per aggiornare il reward
    private func updateReward() {
        let goalType: GoalType = selectedGoalType == "Steps" ? .steps : .kilometers
        let goal = selectedGoalType == "Steps" ? Double(stepsGoal) : distanceGoal
        reward = calculateReward(goalType: goalType, goal: goal)
    }
    
    private func startChallenge() {
        // Verifica se HealthKit è autorizzato
        healthKitManager.checkAuthorizationStatus { authorized in
            if !authorized {
                // Mostra l'avviso se l'accesso è negato
                DispatchQueue.main.async {
                    healthKitAccessDenied = true
                }
                return
            }
            
            // Procedi con l'avvio della challenge se autorizzato
            print("Starting challenge with goal: \(selectedGoalType == "Steps" ? Double(stepsGoal) : distanceGoal) \(selectedGoalType)")
            
            let goalType: GoalType = selectedGoalType == "Steps" ? .steps : .kilometers
            let challengeReward = calculateReward(goalType: goalType, goal: selectedGoalType == "Steps" ? Double(stepsGoal) : distanceGoal)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let challenge = Challenge(
                goalType: goalType,
                duration: selectedDuration,
                goal: selectedGoalType == "Steps" ? Double(stepsGoal) : distanceGoal,
                startDate: /*dateFormatter.date(from: "1/11/2024") ?? */ Date(),
                reward: challengeReward
            )
            
            do {
                modelContext.insert(challenge)
                try modelContext.save()
                print("Challenge started successfully with reward: \(challengeReward)")
            } catch {
                print("Error saving challenge: \(error)")
            }
            
            dismiss()
        }
    }

    
}

#Preview {
    ChallengeSetupView()
        .environment(\.colorScheme, .dark)
}
