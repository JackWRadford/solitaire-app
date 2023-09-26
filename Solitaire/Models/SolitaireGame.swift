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
    private(set) var talon: [Card] = []
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
        case talon
    }
    
    mutating func moveSelected(cards: [Card], from source: Pile, to destination: Pile) {
        guard let bottomCard = cards.first else { return }
        var allowed = false
        
        switch (source, destination) {
        case (.tableau, .tableau(let column)), (.talon, .tableau(let column)), (.foundation, .tableau(let column)):
            allowed = canMoveCardToTableau(bottomCard, column: column)
        case (.tableau, .foundation(let suit)), (.talon, .foundation(let suit)):
            guard cards.onlyOne else { return }
            allowed = canMoveCardToFoundation(bottomCard, for: suit)
        default:
            break
        }
        
        if allowed {
            moveCards(cards, from: source, to: destination)
        }
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
    
    private mutating func moveCards(_ cards: [Card], from source: Pile, to destination: Pile) {
        removeCardsFromPile(cards, pile: source)
        addCardsToPile(cards, pile: destination)
    }
    
    private mutating func removeCardsFromPile(_ cards: [Card], pile: Pile) {
        switch pile {
        case .talon:
            guard cards.onlyOne else { return }
            talon.removeAll { $0.id == cards[0].id }
        case .foundation(let suit):
            guard cards.onlyOne else { return }
            foundations[suit]?.removeAll { $0.id == cards[0].id}
        case .tableau(let column):
            let sourceColumnCards = tableau[column]
            tableau[column] = sourceColumnCards.filter { !cards.contains($0) }
        case .stock:
            let stockCards = stock
            stock = stockCards.filter { !cards.contains($0) }
        }
    }
    
    private mutating func addCardsToPile(_ cards: [Card], pile: Pile) {
        switch pile {
        case .talon:
            talon.append(contentsOf: cards)
        case .tableau(let column):
            tableau[column].append(contentsOf: cards)
        case .foundation(let suit):
            foundations[suit]?.append(contentsOf: cards)
        case .stock:
            let stockCards = stock
            stock = stockCards.filter { !cards.contains($0) }
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

extension Array {
    /// Returns true if there is only one element
    var onlyOne: Bool {
        self.count == 1
    }
}
