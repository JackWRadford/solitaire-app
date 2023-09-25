//
//  GameView.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//
import SwiftUI

struct GameView: View {
    var body: some View {
        HStack {
            Image(systemName: "suit.spade.fill")
            Image(systemName: "suit.club.fill")
            Image(systemName: "suit.diamond.fill")
            Image(systemName: "suit.heart.fill")
        }
        .imageScale(.large)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
