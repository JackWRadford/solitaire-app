//
//  TableauView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct TableauView: View {
    @EnvironmentObject var gameVM: GameViewModel
    let cardWidth: CGFloat
    
    static let columnSpacing: CGFloat = 5
    static let yOffsetMultiplier: CGFloat = 0.32
    private let columnCount = Game.tableauColumnCount
    
    var body: some View {
        HStack(alignment: .top, spacing: Self.columnSpacing) {
            ForEach(Array(0..<columnCount), id: \.self) { index in
                CardStackView(gameVM.game.tableau[index], cardWidth: cardWidth, yOffsetMultiplier: Self.yOffsetMultiplier)
            }
        }
    }
}

struct TableauView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        TableauView(cardWidth: 40)
            .background(.quaternary)
            .padding()
            .environmentObject(GameViewModel(Game()))
            .environmentObject(NamespaceWrapper(namespace: namespace))
    }
}
