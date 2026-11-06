//
//  ActiveChallengeView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 18/11/24.
//

import SwiftUI
import SwiftData
import HealthKit
import Charts

struct ActiveChallengeView: View {
    // Context per il fetch dei dati da SwiftData
    @Query var challenges: [Challenge]
    
    @Query var users: [User]
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeleteAlert: Bool = false
    
    @StateObject private var healthKitManager = HealthKitManager()
        
    @Environment(\.modelContext) var modelContext
    
    @State private var weeklyProgress: [DailyProgress] = []
    
    @State private var allSteps: Double = 0
    @State private var allDistance: Double = 0
    
    @State private var currentChallenge: Challenge?
    
    @State private var isEditSheetPresented = false
    
    @State private var currentUser: User?
       
       // Variabile per gestire lo stato del toggle
    @State private var isChallengeCompleted = false
    
    @State private var isOnToggle = false

    
    var body: some View {
        NavigationStack {
            VStack {
                if let challenge = challenges.first(where: {$0.isCompleted != true}) {
                                        
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            
                            
                            // Progress Section
                            VStack(spacing: 12) {
                                
                                HStack {
                                    Text("PROGRESS")
                                        .font(.headline)
                                        .foregroundColor(.accentColor)
                                    Spacer()
                                }
                                
                                HStack {
                                    Image(systemName: "figure.run")
                                        .foregroundColor(.accentColor)
                                        .font(.system(size: 50))
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        if challenge.goalType == .steps {
                                            
                                            Text("Steps Goal: \(Int(challenge.goal)) steps")
                                            
                                            Text("\(Int(allSteps/challenge.goal * 100))% Completed")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                //.padding(.top)
                                            
                                            ProgressView("", value: allSteps, total: challenge.goal)
                                                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                                        } else {
                                            Text("Distance Goal: \(challenge.goal, specifier: "%.1f") km")
                                            
                                            Text("\(Int(allDistance/challenge.goal * 100))% Completed")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            ProgressView("", value: allDistance, total: challenge.goal)
                                                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                            
                            // Time and Streak Section
                            HStack(spacing: 16) {
                                
                                // Time Section
                                VStack(spacing: 12) {
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.accentColor)
                                        Text("TIME")
                                            .font(.headline)
                                            .foregroundColor(.accentColor)
                                    }
                                    Text("\(challenge.calculateRemainingDays(from: challenge.startDate, duration: challenge.duration)) Days Left")  // Usa la durata della challenge
                                        .fontWeight(.bold)
                                    
                                    Text("Keep going don't give up!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 5)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                                
                                // Streak Section
                                VStack(spacing: 12) {
                                    HStack {
                                        Image(systemName: "gift")
                                            .foregroundColor(.accentColor)
                                        Text("REWARD")
                                            .font(.headline)
                                            .foregroundColor(.accentColor)
                                    }
                                    // Visualizza il reward calcolato
                                    HStack (spacing: 2){
                                        Text("\(challenge.reward)")
                                            .fontWeight(.bold)
                                        Image("superherobyfede")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25)
                                    }
                                    
                                    Text("Gain your Fitcoin and unlock new items!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 5)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                )
                            }
                            .padding(.horizontal)
                            
                            // Activity Section
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "chart.bar.xaxis")
                                        .foregroundColor(.accentColor)
                                    Text("ACTIVITY")
                                        .font(.headline)
                                        .foregroundColor(.accentColor)
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    ScrollViewReader { proxy in
                                        HStack {
                                            Chart(weeklyProgress) { progress in
                                                BarMark(
                                                    x: .value("Day", progress.date, unit: .day),
                                                    y: .value("Value", progress.value)
                                                )
                                                .foregroundStyle(Color.accentColor)
                                                .cornerRadius(5)
                                            }
                                            .chartXAxis {
                                                AxisMarks(values: .stride(by: .day)) { value in
                                                    AxisGridLine()
                                                    
                                                    // Formattazione delle etichette con giorno
                                                    AxisValueLabel {
                                                        if let date = value.as(Date.self) {
                                                            Text(date, format: .dateTime.day().month(.abbreviated))
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(height: 250) // Altezza del grafico
                                            .frame(width: max(CGFloat(weeklyProgress.count) * 55, 82)) // Larghezza dinamica basata sul numero di barre
                                            .padding(.top, 5)
                                            .id("lastItem") // Imposta un ID per l'ultimo elemento
                                        }

                                        .onAppear {
                                            // Scrolla all'ultimo elemento
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                proxy.scrollTo("lastItem", anchor: .trailing)
                                            }
                                        }
                                        
                                
                                    }
                                }
                                .frame(height: 250) // Altezza totale con margini
                                
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                                                        
                            if isChallengeCompleted {
                                Button(action: {
                                    showDeleteAlert = true
                                }) {
                                    Text("Claim your reward")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 300, height: 40)
                                        .background(Color.accentColor)
                                        .cornerRadius(20)
                                }
                            }

                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                } else {
                    // Placeholder o messaggio quando non c'è una challenge attiva
                    Text("No active challenge found.")
                        .font(.title)
                        .padding()
                }
            }
            .onAppear {
                
                checkAndDismissIfNoActiveChallenge()
                
                if let activeChallenge = challenges.first(where: { !$0.isCompleted }) {
                    self.currentChallenge = activeChallenge
                }
                
                if let firstUser = users.first {
                    self.currentUser = firstUser
                }
                // Richiedere permessi a HealthKit quando la vista appare
                healthKitManager.requestAuthorization { success in
                    if success {
                        fetchProgressStats()  // Recupera i dati di oggi da HealthKit
                    } else {
                        print("HealthKit authorization failed.")
                    }
                }
            }
            .navigationTitle("Your Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                            isEditSheetPresented = true
                    }) {
                        Text("Edit")
                    }
                    
                }
                
            }
            .fullScreenCover(isPresented: $isEditSheetPresented) {
                if let challenge = currentChallenge {
                    EditActiveChallengeView(challenge: challenge)
                        .onDisappear {
                            checkAndDismissIfNoActiveChallenge()
                            checkCompletion(for: challenge)
                        }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Claim reward?"),
                    message: Text("Editing this challenge will no longer be allowed.")
                        .font(.footnote) // Smaller text
                        .foregroundColor(.gray), // Gray color
                    primaryButton: .default(Text("Continue")) {
                        if let challenge = currentChallenge {
                            completeChallengeAndUpdateWallet(challenge)
                        } // Call delete method
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        showDeleteAlert = false // Close alert
                    }
                )
            }
             
        }
    }
    
        
    private func checkAndDismissIfNoActiveChallenge() {
        if challenges.isEmpty || challenges.allSatisfy({ $0.isCompleted == true }) {
            dismiss() // Se non ci sono challenge attive, chiudi la vista
        }
    }
    
    
    private func fetchProgressStats() {
        guard let challenge = challenges.first(where: { !$0.isCompleted }) else { return }
        
        // Filtra i passi solo dopo la startDate
        healthKitManager.getSteps(from: challenge.startDate) { steps in
            self.allSteps = steps
            checkCompletion(for: challenge)
            self.updateWeeklyProgress(for: challenge) // Chiamata per aggiornare i progressi settimanali
        }
        
        // Filtra la distanza solo dopo la startDate
        healthKitManager.getDistance(from: challenge.startDate) { distance in
            let distanceInKilometers = distance / 1000
            self.allDistance = distanceInKilometers
            checkCompletion(for: challenge)
            self.updateWeeklyProgress(for: challenge) // Chiamata per aggiornare i progressi settimanali
        }
    }


    
    private func updateWeeklyProgress(for challenge: Challenge) {
        let startOfChallenge = challenge.startDate
        let today = Date()

        // Ottieni i dati giornalieri dopo startDate, escludendo i giorni precedenti
        healthKitManager.getDailyStats(startDate: startOfChallenge, endDate: today, type: challenge.goalType) { dailyValues in
            // Filtra i dati, includendo solo quelli successivi alla startDate
            let filteredValues = dailyValues.filter { $0.date >= startOfChallenge }

            // Mappa i dati filtrati per i progressi giornalieri
            self.weeklyProgress = filteredValues.map { DailyProgress(date: $0.date, value: $0.value) }
        }
    }



    
    private func checkCompletion(for challenge: Challenge) {
        // Dopo aver aggiornato i progressi, verifica se il goal è stato raggiunto
        if challenge.goalType == .steps && allSteps >= challenge.goal {
            // Se i passi raggiungono o superano il goal, completa la challenge
            isChallengeCompleted = true
        } else if challenge.goalType == .kilometers && allDistance >= challenge.goal {
            // Se la distanza raggiunge o supera il goal, completa la challenge
            isChallengeCompleted = true
        } else {
            isChallengeCompleted = false
        }
    }

    
    private func completeChallengeAndUpdateWallet(_ challenge: Challenge) {
        // Imposta isCompleted su true per segnare la challenge come completata
        challenge.isCompleted = true
        
        challenge.endDate = Date()
        // Aggiungi il reward al wallet dell'utente
        if let user = currentUser {
            user.wallet += challenge.reward
        }
        
        // Salva il contesto del modello per applicare la modifica
        do {
            try modelContext.save()
            checkAndDismissIfNoActiveChallenge()
            print("Challenge completed and wallet updated.")
        } catch {
            print("Failed to complete challenge and update wallet: \(error.localizedDescription)")
        }
    }


}

#Preview {
    ActiveChallengeView()
}

