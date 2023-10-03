//
//  GameArea.swift
//  Solitaire
//
//  Created by Jack Radford on 03/10/2023.
//

import SwiftUI

struct GameArea: View {
    @Namespace private var gameNamespace
    
    @State var cardWidth: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: TableauView.columnSpacing) {
                FoundationsView(cardWidth: cardWidth)
                TalonView(cardWidth: cardWidth)
                DeckView(cardWidth: cardWidth)
            }
            .padding(TableauView.columnSpacing)
            .background(Color.accentColor.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: CardView.cornerRadius + TableauView.columnSpacing))
            
            TableauView(cardWidth: $cardWidth)
        }
        .padding()
        .background(.quaternary)
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
    }
}

struct GameArea_Previews: PreviewProvider {
    static var previews: some View {
        GameArea()
    }
}
