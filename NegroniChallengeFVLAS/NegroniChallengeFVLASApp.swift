//
//  NegroniChallengeFVLASApp.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 04/11/24.
//

import SwiftUI
import SwiftData

@main
struct NegroniChallengeFVLASApp: App {
    
    init() {
        // Impostiamo il colore per tutti i pulsanti in UIAlertController
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self, Item.self, Challenge.self])
        }
        
    }
}
