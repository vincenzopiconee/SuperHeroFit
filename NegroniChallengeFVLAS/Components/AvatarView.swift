//
//  AvatarView.swift
//  NegroniChallengeFVLAS
//
//  Created by Vincenzo Picone on 13/11/24.
//

import SwiftUI

struct AvatarView: View {
    
    
    var mask: Item?
    var cape: Item?
    var gloves: Item?
    var other: Item?
    
    var body: some View {
        ZStack{
            if other != nil {
                switch other!.color {
                case .red:
                    Image("RedAura")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.bottom, 50)
                        .padding(.trailing, 10)
                case .orange:
                    Text("")
                case .blue:
                    Image("BlueAura")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.bottom, 50)
                        .padding(.trailing, 10)
                case .green:
                    Image("Sparkle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .padding(.bottom, 30)
                        .padding(.trailing, 10)
                case .yellow:
                    Image("YellowAura")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.bottom, 50)
                        .padding(.trailing, 10)
                case .purple:
                    Image("AngelWings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 290)
                        .padding(.bottom, 40)
                case .cyan:
                    Image("DragonWings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340)
                        .padding(.bottom, 30)
                case .magenta:
                    Image("RoseAura")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.bottom, 50)
                        .padding(.trailing, 10)
                case .nothing:
                    Text("")
                }
            }
            
            if cape != nil {
                switch cape!.color {
                case .red:
                    Image("RedCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .orange:
                    Image("OrangeCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .blue:
                    Image("BlueCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .green:
                    Image("GreenCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .yellow:
                    Image("YellowCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .purple:
                    Image("PurpleCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .cyan:
                    Image("CyanCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .magenta:
                    Image("MagentaCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .padding(.top, 130)
                case .nothing:
                    Text("")
                }
            }
            
            Image("HeroBody")
                .resizable()
                .scaledToFit()
                .frame(width: 185)
                .padding(.top, 140)
            
            if cape != nil {
                switch cape!.color {
                case .red:
                    Image("UpRedCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .orange:
                    Image("UpOrangeCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .blue:
                    Image("UpBlueCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .green:
                    Image("UpGreenCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .yellow:
                    Image("UpYellowCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .purple:
                    Image("UpPurpleCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .cyan:
                    Image("UpCyanCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .magenta:
                    Image("UpMagentaCape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .padding(.top, 15)
                case .nothing:
                    Text("")
                }
            }
            
            Image("HeroHead")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding(.bottom, 140)
            
            if mask != nil {
                switch mask!.color {
                case .red:
                    Image("RedMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .orange:
                    Image("OrangeMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .blue:
                    Image("BlueMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .green:
                    Image("GreenMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .yellow:
                    Image("YellowMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .purple:
                    Image("PurpleMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .cyan:
                    Image("CyanMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .magenta:
                    Image("MagentaMask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 195)
                        .padding(.bottom, 192)
                        .padding(.leading, 1)
                case .nothing:
                    Text("")
                }
            }
            
            if gloves != nil {
                switch gloves!.color {
                case .red:
                    Image("RedGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .orange:
                    Image("OrangeGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .blue:
                    Image("BlueGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .green:
                    Image("GreenGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .yellow:
                    Image("YellowGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .purple:
                    Image("PurpleGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .cyan:
                    Image("CyanGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .magenta:
                    Image("MagentaGloves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176)
                        .padding(.top, 155)
                case .nothing:
                    Text("")
                }
            }
        }
    }
}
#Preview {
    AvatarView(mask: Item(imageName: "herofitredM", name: "Lava Band", price: 20, color: .red, category: .mask), cape: Item(imageName: "herofitrorangeC", name: "Dusk Defender", price: 40, color: .cyan, category: .cape), gloves: Item(imageName: "herofitblueG 6", name: "Thunder Fists", price: 30, color: .yellow, category: .gloves), other: Item(imageName: "SPARKLE", name: "Shining Sparkle", price: 70, color: .red, category: .others))
}
