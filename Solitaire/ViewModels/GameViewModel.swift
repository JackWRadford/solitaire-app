//
//  GameViewModel.swift
//  Solitaire
//
//  Created by Jack Radford on 26/09/2023.
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published private(set) var game: Game
    @Published private(set) var secondsElapsed = 0
    
    var isComplete: Bool { game.isComplete }
    var timeElapsed: String { hourMinSecString(from: secondsElapsed) }
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ game: Game) {
        self.game = game
        loadGame()
        startTimer()
    }
    
    private func hourMinSec(from seconds: Int) -> (Int, Int, Int) {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        
        return (h, m, s)
    }
    
    /// Format `seconds` as H:M:S String, only showing the necessary time components
    private func hourMinSecString(from seconds: Int) -> String {
        let (h, m, s) = hourMinSec(from: seconds)
        
        var string = ""
        if h > 0 {
            string += "\(h):"
        }
        string += paddedStringFromInt(m) + ":" + paddedStringFromInt(s)
        
        return string
    }
    
    private func paddedStringFromInt(_ int: Int) -> String {
        return String(format: "%02d", int)
    }
    
    //MARK: - Intent
    
    func startTimer() {
        if !cancellables.isEmpty { cancelCancellables() }
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.secondsElapsed += 1
            }
            .store(in: &cancellables)
    }
    
    func cancelCancellables() {
        for item in cancellables {
            item.cancel()
        }
    }
    
    func iterateTalon() {
        game.iterateTalon()
    }
    
    func autoMove(_ card: Card) {
        let _ = game.autoMove(card)
    }
    
    /// Initialises a new Game model and resets secondsElapsed
    func resetGame() {
        game = Game()
        secondsElapsed = 0
    }
    
    private let UDGameStateKey = "solitaireGameState"
    
    /// Cancels the Timer, updated the game secondsElapsed, and tries to save the game state
    func saveGame() {
        cancelCancellables()
        game.secondsElapsed = secondsElapsed
        do {
            let encoder = JSONEncoder()
            let encodedGame = try encoder.encode(game)
            UserDefaults.standard.set(encodedGame, forKey: UDGameStateKey)
        } catch {
            print("Save Error: \(error.localizedDescription)")
        }
    }
    
    /// Tries to load the game state and sets the secondsElapsed value
    func loadGame() {
        if let savedGameData = UserDefaults.standard.data(forKey: UDGameStateKey) {
            do {
                let decoder = JSONDecoder()
                let savedGame = try decoder.decode(Game.self, from: savedGameData)
                game = savedGame
                secondsElapsed = savedGame.secondsElapsed
            } catch {
                print("Load Error: \(error.localizedDescription)")
            }
        }
    }
}
