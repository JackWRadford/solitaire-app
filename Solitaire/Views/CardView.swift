//
//  CardView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct CardView: View {
    typealias Suit = Card.Suit
    
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 8
        static let lineWidth: CGFloat = 4
        static let shadowRadius: CGFloat = 1
        static let frontHeaderHorizontalPadding: CGFloat = 4
        static let frontHeaderTopPadding: CGFloat = 1
        static let backColor: some ShapeStyle = .red
        static let faceColor: some ShapeStyle = .background
    }
    
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
        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
    }
    
    var base: some InsettableShape {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
    }
    
    var face: some View {
        base.strokeBorder(Constants.faceColor, lineWidth: Constants.lineWidth)
            .background(base.fill(Constants.faceColor).shadow(radius: Constants.shadowRadius))
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(card.rank.label())").font(.subheadline).bold()
                        Spacer()
                        suitImage(for: card.suit).font(.caption)
                    }
                    .padding(.horizontal, Constants.frontHeaderHorizontalPadding)
                    .padding(.top, Constants.frontHeaderTopPadding)
                    Spacer()
                }
                .foregroundColor(suitColor(for: card.suit))
            }
    }
    
    var back: some View {
        base.strokeBorder(.thinMaterial, lineWidth: Constants.lineWidth)
            .background(base.fill(Constants.backColor).shadow(radius: Constants.shadowRadius))
    }
    
    func suitColor(for suit: Suit) -> Color {
        suit.color == .red ? .red : .primary
    }
    
    func suitImage(for suit: Suit) -> Image {
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
