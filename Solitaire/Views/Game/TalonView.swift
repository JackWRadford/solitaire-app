//
//  TalonView.swift
//  Solitaire
//
//  Created by Jack Radford on 28/09/2023.
//

import SwiftUI

struct TalonView: View {
    @EnvironmentObject var gameVM: GameViewModel
    
    let cardWidth: CGFloat
    
    private var xOffsetConstant: CGFloat { -(cardWidth * 0.55) }
    
    private var cards: [Card] {
        let allCards = gameVM.game.talon
        return allCards.suffix(3)
    }
    
    var body: some View {
        HStack(spacing: xOffsetConstant) {
            Spacer()
            ForEach(cards) { card in
                CardView(card)
                    .frame(width: cardWidth)
            }
        }
    }
}

struct TalonView_Previews: PreviewProvider {
    static var previews: some View {
        TalonView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
    }
}
