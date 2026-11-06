//
//  ShopView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 11/11/24.
//




import SwiftUI
import SwiftData


struct ShopView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(filter: #Predicate<Item> { !$0.unlocked }) var items: [Item]
    
    @Query var users: [User]
    
    @State private var showPurchaseModal = false
    @State private var selectedItem: Item? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let categoryOrder: [(category: Category, title: String)] = [
        (.mask, "Masks:"),
        (.cape, "Capes:"),
        (.gloves, "Gloves:"),
        (.others, "Others:")
    ]
    
    var body: some View {
        
        NavigationView {
            ZStack {
                ScrollView {
                    let groupedItems = Dictionary(grouping: items, by: { $0.category })
                                            
                    ForEach(categoryOrder, id: \.category) { (category, title) in
                        if let itemsInCategory = groupedItems[category], !itemsInCategory.isEmpty {
                            Section(header: Text(title)
                                .font(.headline)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity, alignment: .leading)) {
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(itemsInCategory, id: \.id) { item in
                                            HeroShopItem(item: item, userWallet: users.first?.wallet ?? 100, showPurchaseModal: $showPurchaseModal, selectedItem: $selectedItem)
                                                .onTapGesture {
                                                    if users.first?.wallet ?? 100 >= item.price {
                                                        selectedItem = item
                                                        showPurchaseModal.toggle()
                                                    }
                                                }
                                        }
                                    }
                                }
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("SuperHeroShop")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 5) {
                            
                            Image("superherobyfede")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                            Text("\(users.first?.wallet ?? 0)")
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                    
                }
                if showPurchaseModal, let selectedItem = selectedItem {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 10) {
                            Image(selectedItem.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top, 15)
                            
                            Text("Do you want to unlock \(selectedItem.name)?")
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .foregroundColor(.primary)
                            HStack {
                                Text("Price:")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text("\(selectedItem.price) FitCoins")
                                    .foregroundColor(.primary)
                            }
                            .padding(.bottom, 10)
                            
                            HStack {
                                
                                Button(action: {
                                    showPurchaseModal = false
                                }) {
                                    Text("Cancel")
                                        .fontWeight(.bold)
                                        .frame(width: 140, height: 40)
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    purchaseItem(selectedItem)
                                }) {
                                    Text("Unlock")
                                        .fontWeight(.bold)
                                        .frame(width: 140, height: 40)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                
                            }
                            .padding(.bottom, 15)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(15)
                        .shadow(radius: 60)
                    }
                    
                }
            }
        }
        
    }
    
    func purchaseItem(_ item: Item) {
        guard let user = users.first, user.wallet >= item.price else { return }
            
        user.wallet -= item.price
        item.unlocked = true
        
        user.wardrobe?.append(item)
            
        try? modelContext.save()
            
        showPurchaseModal = false
    }
    
}

#Preview {
    ShopView()
}
