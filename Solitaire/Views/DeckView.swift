//
//  DeckView.swift
//  Solitaire
//
//  Created by Jack Radford on 27/09/2023.
//

import SwiftUI

struct DeckView: View {
    @EnvironmentObject var gameVM: GameViewModel
    let cardWidth: CGFloat
    
    private var yOffsetConstant: CGFloat { -(cardWidth * 0.01) }
    
    var body: some View {
        ZStack {
            ForEach(Array(gameVM.game.stock.enumerated()), id: \.1.id) { index, card in
                CardView(card, hasShadow: false)
                    .offset(x: 0, y: yOffsetConstant * CGFloat(index))
            }
        }
        .frame(width: cardWidth)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
    }
}
