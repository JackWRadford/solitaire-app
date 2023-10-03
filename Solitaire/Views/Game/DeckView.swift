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
        CardStackView(Array(gameVM.game.stock.suffix(3)), cardWidth: cardWidth, placeholderImage: "circle.fill")
            .onTapGesture {
                withAnimation {
                    gameVM.iterateTalon()
                }
            }
    }
}

struct DeckView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        DeckView(cardWidth: 40)
            .environmentObject(GameViewModel(Game()))
            .environmentObject(NamespaceWrapper(namespace: namespace))
    }
}
