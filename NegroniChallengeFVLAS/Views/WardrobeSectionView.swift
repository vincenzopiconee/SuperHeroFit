//
//  WardrobeSection.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 17/11/24.
//

import SwiftUI

struct WardrobeSectionView: View {
    let title: String
    let items: [Item]
    
    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 1) {
                Text((title))
                    .font(.headline)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items) { item in
                            ProfileItem(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    WardrobeSectionView(title: "Masks:", items: [Item(imageName: "herofitredM", name: "Blaze Band", price: 100, color: .red, category: .mask)])
}
