//
//  GameArea.swift
//  Solitaire
//
//  Created by Jack Radford on 03/10/2023.
//

import SwiftUI

struct GameArea: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Namespace private var gameNamespace
    @State private var cardWidth: CGFloat = .zero
    
    private let portraitVerticalSpacing: CGFloat = 24
    private let landscapeHorizontalSpacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if horizontalSizeClass == .regular { landscapeLayout } else { portraitLayout }
            }
            .onAppear { calculateCardWidth(geometry) }
        }
        .padding(.horizontal)
        .background(.quaternary)
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
    }
    
    private var landscapeLayout: some View {
        HStack(alignment: .top, spacing: landscapeHorizontalSpacing) {
            foundations
            tableau
            VStack(alignment: .trailing) {
                deck
                talon
            }
        }
    }
    private var portraitLayout: some View {
        VStack(spacing: portraitVerticalSpacing) {
            HStack(spacing: TableauView.columnSpacing) {
                foundations
                talon
                deck
            }
            tableau
        }
    }
    
    private var foundations: some View { FoundationsView(cardWidth: cardWidth) }
    private var deck: some View { DeckView(cardWidth: cardWidth) }
    private var talon: some View { TalonView(cardWidth: cardWidth) }
    private var tableau: some View { TableauView(cardWidth: cardWidth) }
    
    /// Calculates and sets the `cardWidth` dependant on the columnSpacing and the given `geometry`
    private func calculateCardWidth(_ geometry: GeometryProxy) {
        var columnCount = Game.tableauColumnCount
        let totalTableauSpacingWidth = TableauView.columnSpacing * CGFloat(columnCount - 1)
        let gameAreaSpacingWidth = landscapeHorizontalSpacing * 2
        var totalSpacingWidth = totalTableauSpacingWidth
        if horizontalSizeClass == .regular {
            totalSpacingWidth += gameAreaSpacingWidth
            columnCount += 3 // (1 for the Foundations) + (2 for the Deck and Talon area)
        }
        
        let aspectRatio = CardView.aspectRatio
        
        let proposedWidthFromWidth = (geometry.size.width - totalSpacingWidth) / CGFloat(columnCount)
        /// Calculate max cardWidth from the total height availab (19 max number of cards in a column not including the last one)
        let proposedWidthFromHeight = (geometry.size.height / (TableauView.yOffsetMultiplier * 19 + (1/aspectRatio)))
        
        cardWidth = min(proposedWidthFromWidth, proposedWidthFromHeight)
    }
}

struct GameArea_Previews: PreviewProvider {
    static var previews: some View {
        GameArea()
            .environmentObject(GameViewModel(Game()))
    }
}
