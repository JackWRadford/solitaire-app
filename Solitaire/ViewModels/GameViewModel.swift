//
//  GameViewModel.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import Foundation

class GameViewModel: ObservableObject {
    private(set) var game: Game
    
    init(_ game: Game) {
        self.game = game
    }
}
