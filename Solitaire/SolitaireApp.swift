//
//  SolitaireApp.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import SwiftUI

@main
struct SolitaireApp: App {
    @StateObject var gameVM = GameViewModel(game: Game())
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(gameVM)
        }
    }
}
