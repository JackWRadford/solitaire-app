//
//  CardView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct CardView: View {
    typealias Suit = Card.Suit
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        Group {
            if card.isFaceUp {
                face
            } else {
                back
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
    
    var base: some Shape {
        RoundedRectangle(cornerRadius: 8)
    }
    
    var face: some View {
        base.fill(.quaternary)
            .overlay {
                VStack {
                    Text("\(card.rank.rawValue)")
                    getSuitImage(for: card.suit)
                }
                .font(.headline)
            }
    }
    
    var back: some View {
        base.stroke(.thinMaterial, lineWidth: 4)
            .background(base.fill(.blue))
    }
    
    func getSuitImage(for suit: Suit) -> Image {
        var systemName = "questionmark.circle.fill"
        
        switch suit {
        case .club:
            systemName = "suit.club.fill"
        case .spade:
            systemName = "suit.spade.fill"
        case .diamond:
            systemName = "suit.diamond.fill"
        case .heart:
            systemName = "suit.heart.fill"
        }
        
        return Image(systemName: systemName)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let gameVm = GameViewModel(Game())
        CardView(gameVm.game.stock[0])
        .frame(maxWidth: 200)
        .environmentObject(gameVm)
    }
}
