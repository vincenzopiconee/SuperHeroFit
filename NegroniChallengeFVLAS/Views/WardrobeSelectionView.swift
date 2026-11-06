import SwiftUI

struct WardrobeSelectionView: View {
    let title: String
    let items: [Item]
    @Binding var selection: Item?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(items) { item in
                        ProfileItem(item: item)
                            .onTapGesture {
                                handleSelection(for: item)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(selection == item ? Color.accentColor : Color.clear, lineWidth: 3)
                            )
                    }
                }
                .padding()
            }
        }
    }
    
    private func handleSelection(for item: Item) {
        if selection == item {
            selection = nil
        } else {
            selection = item
        }
    }
}

#Preview {
    WardrobeSelectionView(title: "Masks:", items: [Item(imageName: "herofitredM", name: "Blaze Band", price: 100, color: .red, category: .mask)], selection: .constant(nil))
}
