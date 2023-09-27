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
    
    private let yOffset: CGFloat = -60
    private let columnSpacing: CGFloat = 5
    private let columnCount = Game.tableauColumnCount
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: columnSpacing) {
                ForEach(Array(0..<columnCount), id: \.self) { index in
                    VStack {
                        ForEach(Array(gameVM.game.tableau[index].enumerated()), id: \.1.id) { index, card in
                            CardView(card)
                                .offset(x: 0, y: yOffset * CGFloat(index))
                        }
                    }
                }
            }
            .onAppear {
                let totalSpacingWidth = columnSpacing * CGFloat(columnCount - 1)
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
