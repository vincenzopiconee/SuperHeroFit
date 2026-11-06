import SwiftUI
import HealthKit
import SwiftData

// View per monitorare i progressi della challenge
struct HistoryView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Challenge.startDate, order: .reverse) var challenges: [Challenge]  // Carica tutte le challenge dal database
    
    @State private var allSteps: Double = 0  // Passi fatti oggi
    @State private var allDistance: Double = 0  // Distanza percorsa oggi
    
    @StateObject private var healthKitManager = HealthKitManager()  // Manager per interagire con HealthKit

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Sezione Challenge List
                List {
                    ForEach(challenges) { challenge in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Start Date: \(formattedDate(challenge.startDate))")
                                .foregroundColor(.secondary)
                                
                            /*
                            Text("Goal: \(challenge.goalType == .steps ? "Steps" : "Kilometers")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            */
                            // Se la challenge è completata, mostra "Challenge Complete"
                            if challenge.goalType == .steps {
                                Text("Steps Goal: \(Int(challenge.goal)) steps")
                            } else {
                                Text("Distance Goal: \(challenge.goal, specifier: "%.1f") km")
                            }
                            if challenge.isCompleted {
                                Text("Challenge Complete")
                                    .font(.headline)
                                    .foregroundColor(.green) // Usa un colore verde per indicare completamento
                                    .padding(.vertical, 8)
                                Text("End Date: \(formattedDate(challenge.endDate ?? Date()))")
                                    .foregroundColor(.secondary)
                            } else {
                                // Mostra il progresso della challenge
                                if challenge.goalType == .steps {
                                    //Text("Steps Goal: \(Int(challenge.goal)) steps")
                                    Text("\(Int(allSteps/challenge.goal * 100))% Completed")
                                    
                                    ProgressView("Progress", value: allSteps, total: challenge.goal)
                                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                                } else {
                                    //Text("Distance Goal: \(challenge.goal, specifier: "%.1f") km")
                                    Text("\(Int(allDistance/challenge.goal * 100))% Completed")
                                    ProgressView("Progress", value: allDistance, total: challenge.goal)
                                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                                }
                                
                                Text("Days Remaining: \(challenge.calculateRemainingDays(from: challenge.startDate, duration: challenge.duration))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteChallenge)
                    .padding()
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .onAppear {
                // Richiedere permessi a HealthKit quando la vista appare
                healthKitManager.requestAuthorization { success in
                    if success {
                        fetchProgressStats()  // Recupera i dati di oggi da HealthKit
                    } else {
                        print("HealthKit authorization failed.")
                    }
                }
            }
            .navigationTitle("History")
        }
    }
    
    private func deleteChallenge(_ indexSet: IndexSet) {
        // Elimina le challenge selezionate dalla lista
        for index in indexSet {
            let challenge = challenges[index]
            modelContext.delete(challenge)
        }
        
        // Salva le modifiche nel contesto
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete challenge: \(error.localizedDescription)")
        }
        
        // Richiedi esplicitamente un aggiornamento della lista di sfide
        // (Ricaricando manualmente la query)
        
    }

    

    private func fetchProgressStats() {
        guard let challenge = challenges.first(where: { !$0.isCompleted }) else { return }
        
        // Recupera i passi e aggiorna il progresso
        healthKitManager.getSteps(from: challenge.startDate) { steps in
            self.allSteps = steps
        }
        
        // Recupera la distanza e aggiorna il progresso
        healthKitManager.getDistance(from: challenge.startDate) { distance in
            let distanceInKilometers = distance / 1000
            self.allDistance = distanceInKilometers
        }
    }
    
    // Funzione per formattare la data
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
        .environment(\.colorScheme, .light)
}
