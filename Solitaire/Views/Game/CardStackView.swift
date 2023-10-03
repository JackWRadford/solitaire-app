//
//  CardStackView.swift
//  Solitaire
//
//  Created by Jack Radford on 28/09/2023.
//

import SwiftUI

struct CardStackView: View {
    
    let cards: [Card]
    let cardWidth: CGFloat
    let placeholderImage: String?
    let yOffsetMultiplier: CGFloat
    
    init(_ cards: [Card],
         cardWidth: CGFloat,
         placeholderImage: String? = nil,
         yOffsetMultiplier: CGFloat = -0.01) {
        self.cards = cards
        self.cardWidth = cardWidth
        self.placeholderImage = placeholderImage
        self.yOffsetMultiplier = yOffsetMultiplier
    }
    
    private var yOffsetConstant: CGFloat { (cardWidth * yOffsetMultiplier) }
    
    var body: some View {
        Group {
            if cards.count > 0 { stack } else { placeholder }
        }
        .frame(width: cardWidth)
    }
    
    var stack: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.1.id) { index, card in
                CardView(card, hasShadow: false)
                    .offset(x: 0, y: yOffsetConstant * CGFloat(index))
            }
        }
    }
    
    var placeholder: some View {
        RoundedRectangle(cornerRadius: CardView.cornerRadius)
            .fill(.regularMaterial)
            .aspectRatio(CardView.aspectRatio, contentMode: .fit)
            .overlay {
                if let placeholderImage {
                    Image(systemName: placeholderImage)
                        .foregroundColor(.secondary)
                }
            }
    }
}

struct CardStackView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardStackView(
            [Card(id: UUID(), rank: .ace, suit: .club), Card(id: UUID(), rank: .ace, suit: .club)],
            cardWidth: 40,
            placeholderImage: "xmark"
        )
        .environmentObject(NamespaceWrapper(namespace: namespace))
    }
}
