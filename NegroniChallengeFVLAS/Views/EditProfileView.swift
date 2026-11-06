//
//  EditProfileView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 11/11/24.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var users: [User]
    
    @State private var selectedMask: Item?
    @State private var selectedCape: Item?
    @State private var selectedGloves: Item?
    @State private var selectedOther: Item?
    
    var body: some View {
        if let user = users.first {
            NavigationStack {
                VStack {
                    AvatarView(mask: selectedMask ?? user.mask,
                               cape: selectedCape ?? user.cape,
                               gloves: selectedGloves ?? user.gloves,
                               other: selectedOther ?? user.other)
                        .frame(height: 440)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 5) {
                            WardrobeSelectionView(
                                title: "Masks:",
                                items: user.wardrobe?.filter { $0.category == .mask } ?? [],
                                selection: $selectedMask
                            )
                            WardrobeSelectionView(
                                title: "Capes:",
                                items: user.wardrobe?.filter { $0.category == .cape } ?? [],
                                selection: $selectedCape
                            )
                            WardrobeSelectionView(
                                title: "Gloves:",
                                items: user.wardrobe?.filter { $0.category == .gloves } ?? [],
                                selection: $selectedGloves
                            )
                            WardrobeSelectionView(
                                title: "Others:",
                                items: user.wardrobe?.filter { $0.category == .others } ?? [],
                                selection: $selectedOther
                            )
                        }
                    }
                }
                .padding()
                .navigationTitle("Edit Avatar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button("Cancel") {
                    dismiss()
                }, trailing: Button("Save") {
                    saveChanges(for: user)
                    dismiss()
                })
                .onAppear {
                    // Inizializza i valori selezionati con quelli attualmente assegnati all'utente
                    selectedMask = user.mask
                    selectedCape = user.cape
                    selectedGloves = user.gloves
                    selectedOther = user.other
                }
            }
        } else {
            Text("No user found")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    
    private func saveChanges(for user: User) {
        user.mask = selectedMask ?? user.mask
        user.cape = selectedCape ?? user.cape
        user.gloves = selectedGloves ?? user.gloves
        user.other = selectedOther ?? user.other
        
        try? modelContext.save()
    }
}


#Preview {
    EditProfileView()
}
