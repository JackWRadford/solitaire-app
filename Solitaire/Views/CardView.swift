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
    let hasShadow: Bool
    
    init(_ card: Card, hasShadow: Bool = true) {
        self.card = card
        self.hasShadow = hasShadow
    }
    
    static let cornerRadius: CGFloat = 8
    static let aspectRatio: CGFloat = 2/3
    
    private struct Constants {
        static let lineWidth: CGFloat = 4
        static let shadowRadius: CGFloat = 1
        static let frontHeaderHorizontalPadding: CGFloat = 4
        static let frontHeaderTopPadding: CGFloat = 1
        static let backColor: some ShapeStyle = .red
        static let faceColor: some ShapeStyle = .background
    }
    
    private var shadowRadius: CGFloat {
        hasShadow ? Constants.shadowRadius : 0
    }
    
    var body: some View {
        Group {
            if card.isFaceUp {
                face
            } else {
                back
            }
        }
        .aspectRatio(Self.aspectRatio, contentMode: .fit)
    }
    
    var base: some InsettableShape {
        RoundedRectangle(cornerRadius: Self.cornerRadius)
    }
    
    var face: some View {
        base.strokeBorder(Constants.faceColor, lineWidth: Constants.lineWidth)
            .background(base.fill(Constants.faceColor).shadow(radius: shadowRadius))
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(card.rank.label())").font(.subheadline).bold()
                        Spacer()
                        Image(systemName: card.suit.image).font(.caption)
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
            .background(base.fill(Constants.backColor).shadow(radius: shadowRadius))
    }
    
    func suitColor(for suit: Suit) -> Color {
        suit.color == .red ? .red : .primary
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
