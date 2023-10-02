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
        loadGame()
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
    
    private let UDGameStateKey = "solitaireGameState"
    
    func saveGame() {
        do {
            let encoder = JSONEncoder()
            let encodedGame = try encoder.encode(game)
            UserDefaults.standard.set(encodedGame, forKey: UDGameStateKey)
        } catch {
            print("Save Error: \(error.localizedDescription)")
        }
    }
    
    func loadGame() {
        if let savedGameData = UserDefaults.standard.data(forKey: UDGameStateKey) {
            do {
                let decoder = JSONDecoder()
                let savedGame = try decoder.decode(Game.self, from: savedGameData)
                game = savedGame
            } catch {
                print("Load Error: \(error.localizedDescription)")
            }
        }
    }
}
