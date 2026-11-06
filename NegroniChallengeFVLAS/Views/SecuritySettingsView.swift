//
//  SecuritySettingsView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 19/11/24.
//

import SwiftUI

struct SecuritySettingsView: View {
    @StateObject private var healthKitManager = HealthKitManager() // Gestore dei permessi HealthKit
    @State private var healthKitAccessGranted = false // Stato per il permesso HealthKit
    
    var body: some View {
        Form {
            Section(header: Text("Health Data Access")) {
                Toggle("Allow HealthKit Access", isOn: $healthKitAccessGranted)
                    .onChange(of: healthKitAccessGranted) {
                        if healthKitAccessGranted {
                            // Richiedi autorizzazione per leggere e scrivere dati da HealthKit
                            healthKitManager.requestAuthorization { success in
                                if success {
                                    print("HealthKit access granted")
                                } else {
                                    // Se l'autorizzazione fallisce, resetta il toggle
                                    healthKitAccessGranted = false
                                    print("HealthKit authorization failed")
                                }
                            }
                        } else {
                            // Quando l'utente disabilita, mostra un messaggio e reindirizza alle impostazioni
                            showHealthKitRevokeAlert()
                            healthKitAccessGranted = true
                        }
                    }
                
                Button(action: {
                    // Apri le impostazioni per gestire i permessi di HealthKit
                    openHealthSettings()
                }) {
                    Text("Manage Health Data Permissions")
                        .foregroundColor(.red)
                }
            }
            
        }
        .navigationTitle("Security")
        .onAppear {
            // Verifica se i permessi sono già stati concessi all'avvio
            checkHealthKitAuthorization()
        }
    }
    
    // Funzione per verificare se l'accesso a HealthKit è stato già autorizzato
    private func checkHealthKitAuthorization() {
        healthKitManager.requestAuthorization { success in
            if success {
                healthKitAccessGranted = true
                print("HealthKit access granted")
            } else {
                // Se l'autorizzazione fallisce, resetta il toggle
                healthKitAccessGranted = false
                print("HealthKit authorization failed")
            }
        }
    }
    
    // Funzione per aprire le impostazioni dell'app, dove l'utente può gestire i permessi di HealthKit
    private func openHealthSettings() {
        // Usa il nuovo approccio con UIWindowScene per iOS 15 e successivi
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                let settingsURL = URL(string: UIApplication.openSettingsURLString)
                if let url = settingsURL, UIApplication.shared.canOpenURL(url) {
                    rootVC.present(UIAlertController(title: "Settings", message: "Opening app settings...", preferredStyle: .alert), animated: true)
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // Funzione per mostrare un avviso che informa l'utente di disabilitare i permessi nelle impostazioni
    private func showHealthKitRevokeAlert() {
        // Mostra un alert che informa l'utente di disabilitare i permessi nelle impostazioni
        let alert = UIAlertController(title: "Revoke HealthKit Access",
                                      message: "You need to go to the app settings to revoke HealthKit access.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Presenta l'alert usando UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    SecuritySettingsView()
}
