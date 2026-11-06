//
//  HeroShopItem.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 11/11/24.
//



import SwiftUI

struct HeroShopItem: View {
    let item: Item
    let userWallet: Int
    @Binding var showPurchaseModal: Bool // Variabile di stato per il pop-up
    @Binding var selectedItem: Item? // L'item selezionato per l'acquisto
    
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
            
            VStack(spacing: 5) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64.0, height: 94.0)
                    .opacity(userWallet >= item.price ? 1 : 0.5) // Luminosità ridotta se non acquistabile
                
                Text(item.name)
                    .font(.system(size: 12.0))
                    .foregroundColor(.primary) // Colore adattivo per il testo
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 5) {
                    Text("\(item.price)")
                        .font(.system(size: 13))
                        .foregroundColor(.primary)
                    
                    Image("superherobyfede")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            .padding(.vertical, 8)
        }
        .overlay(
            Color.black.opacity(userWallet >= item.price ? 0 : 0.4) // Oscuramento se non acquistabile
                .cornerRadius(17)
        )
        .onTapGesture {
            if userWallet >= item.price {
                selectedItem = item
                showPurchaseModal.toggle()
            }
        }
    }
}

#Preview {
    HeroShopItem(
        item: Item(imageName: "herofitredM", name: "Blaze Band", price: 100, color: .red, category: .mask),
        userWallet: 100,
        showPurchaseModal: .constant(false),
        selectedItem: .constant(nil)
    )
    .environment(\.colorScheme, .dark) // Test per la modalità scura
}
