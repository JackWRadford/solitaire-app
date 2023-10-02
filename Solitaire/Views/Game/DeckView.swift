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
        CardStackView(gameVM.game.stock, cardWidth: cardWidth, placeholderImage: "circle.fill")
            .onTapGesture {
                withAnimation {
                    gameVM.iterateTalon()
                }
            }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
    }
}
