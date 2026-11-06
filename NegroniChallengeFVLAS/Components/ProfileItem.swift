//
//  ProfileItem.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 13/11/24.
//


import SwiftUI

struct ProfileItem: View {
    
    let item: Item
    
    var body: some View {
        ZStack {
            // Sfondo con grigio opaco e sfocatura
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 109.8, height: 149.0)
                .background(
                    Color.gray // Grigio opaco per entrambi i temi
                        .blur(radius: 60) // Leggera sfocatura
                )
                .overlay(
                    Color.black.opacity(0.01) // Sfocatura più scura per profondità
                        .blur(radius: 10)
                )
                .cornerRadius(17.0)
            
            VStack(spacing: 10) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 100)
                
                Text(item.name)
                    .font(.system(size: 15))
                    .foregroundColor(Color.primary) // Colore del testo dinamico
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    ProfileItem(item: Item(imageName: "herofitredM", name: "Blaze Band", price: 100, color: .red, category: .mask))
        .environment(\.colorScheme, .dark) // Test in dark mode
}
