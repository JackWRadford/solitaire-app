//
//  FoundationsView.swift
//  Solitaire
//
//  Created by Jack Radford on 28/09/2023.
//

import SwiftUI

struct FoundationsView: View {
    @EnvironmentObject var gameVM: GameViewModel
    
    let cardWidth: CGFloat
    
    var body: some View {
        HStack(spacing: TableauView.columnSpacing) {
            ForEach(Card.Suit.allCases) { suit in
                let cards = gameVM.game.foundations[suit] ?? []
                CardStackView(cards.suffix(3), cardWidth: cardWidth, placeholderImage: suit.image)
            }
        }
    }
}

struct FoundationsView_Previews: PreviewProvider {
    static var previews: some View {
        FoundationsView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
    }
}
