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
    
    var body: some View {
        if let lastCard = gameVM.game.stock.last {
            CardView(lastCard)
                .frame(width: cardWidth)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
    }
}
