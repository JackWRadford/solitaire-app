//
//  GameView.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//
import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @State var cardWidth: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: TableauView.columnSpacing) {
                FoundationsView(cardWidth: cardWidth)
                TalonView(cardWidth: cardWidth)
                DeckView(cardWidth: cardWidth)
            }
            TableauView(cardWidth: $cardWidth)
        }
        .padding()
        .background(.quaternary)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel(Game()))
    }
}
