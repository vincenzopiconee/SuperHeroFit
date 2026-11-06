//
//  AvatarItem.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 12/11/24.
//



import SwiftUI
import SwiftData

enum Category: String, Codable {
    case mask
    case cape
    case gloves
    case others
}

enum ItemColor: String, Codable {
    case red
    case orange
    case blue
    case green
    case yellow
    case purple
    case cyan
    case magenta
    case nothing
}

@Model
class Item : Identifiable {
    
    var id: UUID = UUID()
    var imageName: String
    var component: String
    var name: String
    var price: Int
    var color: ItemColor
    var category: Category
    var unlocked: Bool
    
    
    
    init(imageName: String = "", component: String = "", name: String = "", price: Int = 0, color: ItemColor = .nothing, category: Category = .others, unlocked: Bool = false) {

        self.id = UUID()
        self.imageName = imageName
        self.component = component
        self.name = name
        self.price = price
        self.category = category
        self.unlocked = unlocked
        self.color = color
    }
}
struct ItemData {
    static let items: [Item] = [
        //Default
        Item(imageName: "herofitwithoutnothing", name: "No mask", color: .nothing, category: .mask, unlocked: true),
        Item(imageName: "herofitwithoutnothing", name: "No cape", color: .nothing, category: .cape, unlocked: true),
        Item(imageName: "herofitwithoutnothing", name: "No gloves", color: .nothing, category: .gloves, unlocked: true),
        Item(imageName: "herofitwithoutnothing", name: "No others", color: .nothing, category: .others, unlocked: true),
        // Red
        Item(imageName: "herofitredM", name: "Lava Band", price: 20, color: .red, category: .mask),
        Item(imageName: "herofitredC", name: "Magma Cape", price: 40, color: .red, category: .cape, unlocked: false),
        Item(imageName: "herofitblueG 8", name: "Inferno Grips", price: 30, color: .red, category: .gloves, unlocked: false),
        
        
        // Orange
        Item(imageName: "herofitorangeM", name: "Sunburst Band", price: 20, color: .orange, category: .mask),
        Item(imageName: "herofitrorangeC", name: "Dusk Defender", price: 40, color: .orange, category: .cape),
        Item(imageName: "herofitblueG 7", name: "Blaze Gloves", price: 30, color: .orange, category: .gloves),
        
        // Yellow
        Item(imageName: "herofityellowM", name: "Lightning Wrap", price: 20, color: .yellow, category: .mask),
        Item(imageName: "herofityellowC", name: "Dawn Cloak", price: 40, color: .yellow, category: .cape, unlocked: false),
        Item(imageName: "herofitblueG 6", name: "Thunder Fists", price: 30, color: .yellow, category: .gloves),
        
        // Green
        Item(imageName: "herofitgreenM", name: "Verdant Veil", price: 20, color: .green, category: .mask, unlocked: false),
        Item(imageName: "herofitgreenC", name: "Nature Guard", price: 40, color: .green, category: .cape),
        Item(imageName: "herofitblueG 5", name: "Grass Empower", price: 30, color: .green, category: .gloves, unlocked: false),
        
        // Blue
        Item(imageName: "herofitblueM", name: "Wave Band", price: 20, color: .blue, category: .mask),
        Item(imageName: "herofitblueC", name: "Sky Shield", price: 40, color: .blue, category: .cape),
        Item(imageName: "herofitblueG", name: "Aqua Force", price: 30, color: .blue, category: .gloves),
        
        // Purple
        Item(imageName: "herofitpurpleM", name: "Mystic Band", price: 20, color: .purple, category: .mask, unlocked: false),
        Item(imageName: "herofitpurpleC", name: "Twilight Cloak", price: 40, color: .purple, category: .cape),
        Item(imageName: "herofitblueG 3", name: "Mystic Touch", price: 30, color: .purple, category: .gloves, unlocked: false),
        
        // Light Blue
        Item(imageName: "herofitcyanM", name: "Breeze Band", price: 20, color: .cyan, category: .mask),
        Item(imageName: "herofitcyanC", name: "Crystal Cape", price: 40, color: .cyan, category: .cape),
        Item(imageName: "herofitblueG 2", name: "Icy Aura", price: 30, color: .cyan, category: .gloves),
        
        // Magenta
        Item(imageName: "herofitmagentaM", name: "Spirit Spark", price: 20, color: .magenta, category: .mask),
        Item(imageName: "herofitmagentaC", name: "Magenta Might", price: 40, color: .magenta, category: .cape),
        Item(imageName: "herofitblueG 4", name: "Spirit Surge", price: 30, color: .magenta, category: .gloves, unlocked: false),
        
        //Aura
        Item(imageName: "SPARKLE", name: "Shining Sparkle", price: 70, color: .green, category: .others, unlocked: false),
        Item(imageName: "AURARED", name: "Crimson Flame", price: 120, color: .red, category: .others, unlocked: false),
        Item(imageName: "AURAYELLOW", name: "Golden Glow", price: 120, color: .yellow, category: .others, unlocked: false),
        Item(imageName: "AURABLUE", name: "Azure Aura", price: 120, color: .blue, category: .others, unlocked: false),
        Item(imageName: "AURAROSE", name: "Radiant Rose", price: 120, color: .magenta, category: .others, unlocked: false),
        Item(imageName: "Group 5", name: "Angel Wings", price: 100, color: .purple, category: .others, unlocked: false),
        Item(imageName: "Group 6", name: "Dragon Wings", price: 100, color: .cyan, category: .others, unlocked: false)
    ]
}
