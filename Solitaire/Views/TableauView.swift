//
//  TableauView.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import SwiftUI

struct TableauView: View {
    @EnvironmentObject var gameVM: GameViewModel
    
    var body: some View {
        
        let yOffset: CGFloat = -60
        let columnSpacing: CGFloat = 10
        
        HStack(alignment: .top, spacing: columnSpacing) {
            ForEach(Array(0..<Game.tableauColumnCount), id: \.self) { index in
                VStack {
                    ForEach(Array(gameVM.game.tableau[index].enumerated()), id: \.1.id) { index, card in
                        CardView(card)
                            .offset(x: 0, y: yOffset * CGFloat(index))
                    }
                }
            }
        }
    }
}

struct TableauView_Previews: PreviewProvider {
    static var previews: some View {
        TableauView()
            .background(.quaternary)
            .padding()
            .environmentObject(GameViewModel(Game()))
    }
}
