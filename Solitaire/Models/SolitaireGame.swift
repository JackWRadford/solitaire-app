//
//  SolitaireGame.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import Foundation

struct SolitaireGame {
    typealias Suit = Card.Suit
    
    private(set) var stock: [Card] = []
    private(set) var waste: [Card] = []
    private(set) var tableau: [[Card]] = Array(repeating: [], count: 7)
    private(set) var foundations: [Suit: [Card]] = [
        .spade: [],
        .club: [],
        .diamond: [],
        .heart: []
    ]
    
    init() {
        initializeGame()
    }
    
    mutating func initializeGame() {
        initializeDeck()
        dealTableau()
    }
    
    private mutating func initializeDeck() {
        var deck: [Card] = []
        for suit in Suit.allCases {
            for rank in Card.Rank.allCases {
                deck.append(.init(id: UUID(), rank: rank, suit: suit))
            }
        }
        deck.shuffle()
        stock = deck
    }
    
    private mutating func dealTableau() {
        for column in 0..<7 {
            for _ in 0...column {
                if let card = stock.popLast() {
                    tableau[column].append(card)
                }
            }
        }
    }
}
