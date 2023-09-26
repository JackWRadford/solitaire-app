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
        HStack(alignment: .top) {
            ForEach(Array(0..<Game.tableauColumnCount), id: \.self) { index in
                VStack {
                    ForEach(Array(gameVM.game.tableau[index].enumerated()), id: \.1.id) { index, card in
                        CardView(card)
                            .offset(x: 0, y: -60 * CGFloat(index))
                    }
                }
            }
        }
    }
}

struct TableauView_Previews: PreviewProvider {
    static var previews: some View {
        TableauView()
            .environmentObject(GameViewModel(Game()))
            .padding()
    }
}
