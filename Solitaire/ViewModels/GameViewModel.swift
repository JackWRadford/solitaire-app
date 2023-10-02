//
//  GameViewModel.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var game: Game
    
    var isComplete: Bool { game.isComplete }
    
    init(_ game: Game) {
        self.game = game
    }
    
    //MARK: - Intent
    
    func iterateTalon() {
        game.iterateTalon()
    }
    
    func autoMove(_ card: Card) {
        let _ = game.autoMove(card)
    }
    
    func resetGame() {
        game = Game()
    }
}
