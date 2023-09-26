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
            TableauView()
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
