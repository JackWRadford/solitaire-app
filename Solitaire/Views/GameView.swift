//
//  GameView.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//
import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameVM: GameViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .top) {
                ForEach(Array(0..<Game.tableauColumnCount), id: \.self) { index in
                    VStack {
                        ForEach(gameVM.game.tableau[index], id: \.id) { card in
                            CardView(card)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(.quaternary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel(Game()))
    }
}
