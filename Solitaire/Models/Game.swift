//
//  Game.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import Foundation

struct Game {
    typealias Suit = Card.Suit
    static let tableauColumnCount = 7
    
    private(set) var stock: [Card] = []
    private(set) var talon: [Card] = []
    private(set) var tableau: [[Card]] = Array(repeating: [], count: tableauColumnCount)
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
    
    /// Add all Rank cards for each Suit, then shuffle
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
    
    /// Deals top cards face up
    private mutating func dealTableau() {
        for column in 0..<Self.tableauColumnCount {
            for index in 0...column {
                if let card = stock.popLast() {
                    tableau[column].append(card)
                    if index == column {
                        tableau[column][index].isFaceUp = true
                    }
                }
            }
        }
    }
    
    /// Move the top Stock card to the Talon,
    /// or if the Stock is empty move all Talon cards into the Stock
    mutating func iterateTalon() {
        if stock.count > 0 {
            dealTalon()
        } else {
            // Set all Talon cards to face down
            for index in 0..<talon.count {
                talon[index].isFaceUp = false
            }
            // Move Talon cards to the Stock in reverse order
            talon.forEach { _ in
                let card = talon.popLast()
                if let card {
                    stock.append(card)
                }
            }
        }
    }
    
    private mutating func dealTalon() {
        guard stock.count > 0 else { return }
        stock[stock.count - 1].isFaceUp = true
        if let card = stock.popLast() {
            talon.append(card)
        }
    }
    
    enum Pile {
        case tableau(column: Int)
        case foundation(suit: Card.Suit)
        case talon
    }
    
    mutating func moveSelected(cards: [Card], from source: Pile, to destination: Pile) {
        guard let bottomCard = cards.first else { return }
        var allowed = false
        
        switch destination {
        case .tableau(let column):
            allowed = canMoveCardToTableau(bottomCard, column: column)
        case .foundation(let suit):
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
