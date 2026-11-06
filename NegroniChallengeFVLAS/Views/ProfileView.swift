//
//  ProfileView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 11/11/24.
//



import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var users: [User]
    
    @State private var showEditModal = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    AvatarView(mask: users.first?.mask, cape: users.first?.cape, gloves: users.first?.gloves, other: users.first?.other)
                        .frame(height: 440)
                    
                    Text("Wardrobe")
                        .font(.system(size: 20, weight: .semibold))
                    
                    VStack {
                        if let user = users.first {
                            WardrobeSectionView(title: "Masks:", items: user.wardrobe?.filter { $0.category == .mask } ?? [])
                            WardrobeSectionView(title: "Capes:", items: user.wardrobe?.filter { $0.category == .cape } ?? [])
                            WardrobeSectionView(title: "Gloves:", items: user.wardrobe?.filter { $0.category == .gloves } ?? [])
                            WardrobeSectionView(title: "Others:", items: user.wardrobe?.filter { $0.category == .others } ?? [])
                        } else {
                            Text("No items found.")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Your SuperHero")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Edit") {
                showEditModal.toggle()
            })
            .fullScreenCover(isPresented: $showEditModal) {
                EditProfileView()
            }
        }
    }
}


#Preview {
    ProfileView()
}
