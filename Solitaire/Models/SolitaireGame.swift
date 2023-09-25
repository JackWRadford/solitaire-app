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
    
    enum Pile {
        case tableau(column: Int)
        case foundation(suit: Card.Suit)
        case stock
        case waste
    }
    
    mutating func moveSelected(cards: [Card], from source: Pile, to destination: Pile) {
        guard let bottomCard = cards.first else { return }
        let onlyOneCard = cards.count == 1
        switch (source, destination) {
        case (.waste, .tableau(let destinationColumn)):
            if canMoveCardToTableau(bottomCard, column: destinationColumn) {
                removeCardFromWaste(bottomCard)
                addCardsToTableau([bottomCard], at: destinationColumn)
            }
        case (.waste, .foundation(let destinationSuit)):
            if canMoveCardToFoundation(bottomCard, for: destinationSuit) {
                removeCardFromWaste(bottomCard)
                addCardToFoundation(bottomCard, at: destinationSuit)
            }
        case (.tableau(let sourceColumn), .tableau(let destinationColumn)):
            if canMoveCardToTableau(bottomCard, column: destinationColumn) {
                removeCardsFromTableau(cards, at: sourceColumn)
                addCardsToTableau(cards, at: destinationColumn)
            }
        case (.tableau(let sourceColumn), .foundation(let destinationSuit)):
            guard onlyOneCard else { return }
            if canMoveCardToFoundation(bottomCard, for: destinationSuit) {
                removeCardsFromTableau([bottomCard], at: sourceColumn)
                addCardToFoundation(bottomCard, at: destinationSuit)
            }
        case (.foundation(let sourceSuit), .tableau(let destinationColumn)):
            guard onlyOneCard else { return }
            if canMoveCardToTableau(bottomCard, column: destinationColumn) {
                foundations[sourceSuit]?.removeAll { $0.id == bottomCard.id }
                addCardsToTableau([bottomCard], at: destinationColumn)
            }
        default:
            break
        }
    }
    
    private mutating func removeCardFromWaste(_ card: Card) {
        waste.removeAll { $0.id == card.id }
    }
    
    private mutating func removeCardsFromTableau(_ cards: [Card], at column: Int) {
        let sourceColumnCards = tableau[column]
        tableau[column] = sourceColumnCards.filter { !cards.contains($0) }
    }
    
    private mutating func addCardsToTableau(_ cards: [Card], at column: Int) {
        tableau[column].append(contentsOf: cards)
    }
    
    private mutating func addCardToFoundation(_ card: Card, at suit: Suit) {
        foundations[suit]?.append(card)
    }
    
    private func canMoveCardToTableau(_ card: Card, column: Int) -> Bool {
        guard column < tableau.count else { return false }
        if let destinationCard = tableau[column].last {
            return card.suit.color != destinationCard.suit.color && card.rank.rawValue == destinationCard.rank.rawValue - 1
        } else {
            return card.rank == .king
        }
    }
    
    private func canMoveCardToFoundation(_ card: Card, for suit: Suit) -> Bool {
        guard let foundation = foundations[suit] else { return false }
        if let destinationCard = foundation.last {
            return card.suit == destinationCard.suit && card.rank.rawValue == destinationCard.rank.rawValue + 1
        } else {
            return card.rank == .ace
        }
    }
    
    func isComplete() -> Bool {
        for suit in Suit.allCases {
            guard let foundation = foundations[suit] else { return false }
            return foundation.count == 13
        }
        return false
    }
}
