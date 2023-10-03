//
//  CardView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct CardView: View {
    typealias Suit = Card.Suit
    
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper
    
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
        static let backColor: some ShapeStyle = Color.accentColor.gradient
        static let lightFaceColor: Color = Color.white
        static let darkFaceColor: Color = Color(red: 0.24, green: 0.24, blue: 0.24)
    }
    
    private var faceColor: some ShapeStyle {
        return colorScheme == .dark ? Constants.darkFaceColor : Constants.lightFaceColor
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
        .matchedGeometryEffect(id: card.id, in: namespaceWrapper.namespace)
        .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    var base: some InsettableShape {
        RoundedRectangle(cornerRadius: Self.cornerRadius)
    }
    
    var face: some View {
        base.strokeBorder(faceColor, lineWidth: Constants.lineWidth)
            .background(base.fill(faceColor).shadow(radius: shadowRadius))
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
            .onTapGesture {
                withAnimation {
                    gameVM.autoMove(card)
                }
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
    @Namespace static var namespace
    
    static var previews: some View {
        let gameVm = GameViewModel(Game())
        let card1 = Card(id: UUID(), rank: .ace, suit: .club)
        var card2: Card {
            var card = Card(id: UUID(), rank: .ace, suit: .club)
            card.isFaceUp = true
            return card
        }
        
        HStack {
            CardView(card1)
                .frame(maxWidth: 100)
            CardView(card2)
                .frame(maxWidth: 100)
        }
        .environmentObject(gameVm)
        .environmentObject(NamespaceWrapper(namespace: namespace))
    }
}
