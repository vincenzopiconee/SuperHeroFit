//
//  User.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 13/11/24.
//





import SwiftUI
import SwiftData


@Model
class User : Identifiable{
    var id: UUID = UUID()
    var wardrobe: [Item]?
    var wallet: Int = 0
    
    var mask: Item?
    var cape: Item?
    var gloves: Item?
    var other: Item?
    
    init(wallet: Int = 0, mask: Item? = nil, cape: Item? = nil, gloves: Item? = nil, other: Item? = nil) {
        self.id = UUID()
        self.wardrobe = ItemData.items.filter { $0.unlocked }
        self.wallet = wallet
        self.mask = mask
        self.cape = cape
        self.gloves = gloves
        self.other = other
    }
}
