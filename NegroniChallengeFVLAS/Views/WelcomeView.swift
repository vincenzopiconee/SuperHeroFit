//
//  SwiftUIView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 16/11/24.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var showFullScreenPrompt = false

    var body: some View {
        VStack() {
            // Logo e nome dell'app
            HStack {
                Text("Welcome to")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("SuperHeroFit")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.accent)
            }
            .padding(.top, 100)
            
            VStack(alignment: .leading, spacing: 20) { // Spaziatura uniforme tra ogni HStack
                HStack(alignment: .center, spacing: 15) { // Minor spacing tra icona e testo
                    Image(systemName: "figure.walk.motion")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .leading, spacing: 5) { // Minor spacing tra i testi
                        Text("Step Up")
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundStyle(.primary)
                        
                        Text("Keep up with your fitness routine")
                            .font(.body)
                            .foregroundColor(.secondary) // Colore più tenue per il sottotitolo
                    }
                }
                
                HStack(alignment: .center, spacing: 15) {
                    Image(systemName: "bolt.ring.closed")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Power Up")
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundStyle(.primary)
                        
                        Text("Complete your challenges and boost your energy")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(alignment: .center, spacing: 15) {
                    Image(systemName: "wand.and.sparkles")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hero Up")
                            .fontWeight(.bold)
                            .font(.title3)
                            .foregroundStyle(.primary)
                        
                        Text("Discover your rewards and personalise your superhero")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding() // Margine complessivo per il contenitore VStack

            
            Spacer()
             
            
            // Pulsante di avvio
            Button(action: {
                AddUser()
                preloadItems()
                showFullScreenPrompt = true
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray2))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showFullScreenPrompt) {
                ContentView()
            }
            .padding(.bottom)
            
            //Spacer()
        }
        //.ignoresSafeArea()
    }

    // Aggiungi un nuovo utente
    func AddUser() {
        let user = User()
        modelContext.insert(user)
    }
    
    // Pre-carica gli oggetti iniziali
    func preloadItems() {
        let initialItems = ItemData.items.map { Item(imageName: $0.imageName, component: $0.component, name: $0.name, price: $0.price, color: $0.color, category: $0.category, unlocked: $0.unlocked)}
            
        for item in initialItems {
            modelContext.insert(item)
        }
            
        do {
            try modelContext.save()
        } catch {
            print("Errore durante il salvataggio degli oggetti iniziali: \(error)")
        }
    }
}

#Preview {
    WelcomeView()
        .environment(\.colorScheme, .light)
}

