//
//  ContentView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 04/11/24.
//



import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query var users: [User]
    
    
    var body: some View {
        
        if users.isEmpty {
            WelcomeView()
        } else {
            
            TabView {
                HomeView()
                    .tabItem{
                        Image(systemName: "poweroutlet.type.f.fill")
                        Text("SuperHeroFit")
                    }
                HistoryView()
                    .tabItem{
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }
                ShopView()
                    .tabItem{
                        Image(systemName: "basket")
                        Text("SuperHeroShop")
                    }
            }
        }
        
        
        
    }
}

#Preview {
    ContentView()
}
