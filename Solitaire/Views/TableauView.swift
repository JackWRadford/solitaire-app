//
//  TableauView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct TableauView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @Binding var cardWidth: CGFloat
    
    static let columnSpacing: CGFloat = 5
    private let columnCount = Game.tableauColumnCount
    private var yOffsetConstant: CGFloat { -(cardWidth * 1.2) }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: Self.columnSpacing) {
                ForEach(Array(0..<columnCount), id: \.self) { index in
                    VStack(spacing: yOffsetConstant) {
                        ForEach(gameVM.game.tableau[index]) { card in
                            CardView(card)
                        }
                    }
                }
            }
            .onAppear {
                let totalSpacingWidth = Self.columnSpacing * CGFloat(columnCount - 1)
                cardWidth = (geometry.size.width - totalSpacingWidth) / CGFloat(columnCount)
            }
        }
    }
}

struct TableauView_Previews: PreviewProvider {
    static var previews: some View {
        TableauView(cardWidth: .constant(40))
            .background(.quaternary)
            .padding()
            .environmentObject(GameViewModel(Game()))
    }
}
