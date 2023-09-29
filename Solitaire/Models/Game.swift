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
    
    enum Pile {
        case tableau(column: Int)
        case foundation(suit: Card.Suit)
        case talon
    }
    
    private mutating func initializeGame() {
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
    
    /// Move the `card` (and any child cards if in the Tableau)
    mutating func autoMove(_ card: Card) -> Bool {
        if let (pile, _) = findCard(card) {
            for suit in Suit.allCases {
                if moveSelected(cards: [card], from: pile, to: .foundation(suit: suit)) { return true }
            }
            for column in 0..<tableau.count {
                if moveSelected(cards: [card], from: pile, to: .tableau(column: column)) { return true }
            }
        } else {
            // Could not find card
        }
        return false
    }
    
    /// Finds the `card`'s Pile and index in that pile
    private func findCard(_ card: Card) -> (pile:Pile, index: Int)? {
        if let (tableauColumn, tableauIndex) = findCardInTableau(card) {
            return (.tableau(column: tableauColumn), tableauIndex)
        } else if let foundationIndex = findCardInFoundations(card) {
            return (.foundation(suit: card.suit), foundationIndex)
        } else if let topTalonCard = talon.last {
            if topTalonCard.id == card.id {
                return (.talon, talon.count - 1)
            }
        }
        return nil
    }
    
    /// Returns the index of the `card` if it is found, otherwise returns nil
    private func findCardInFoundations(_ card: Card) -> Int? {
        guard let foundationCards = foundations[card.suit] else { return nil }
        if let topCard = foundationCards.last {
            return topCard.id == card.id ? foundationCards.count - 1 : nil
        }
        return nil
    }
    
    /// Returns the `column` index and inner `index` of the `card` if it is found, otherwise returns nil
    private func findCardInTableau(_ card: Card) -> (column: Int, index: Int)? {
        for columnIndex in 0..<tableau.count {
            let index = tableau[columnIndex].firstIndex { $0.id == card.id }
            if let index {
                return (columnIndex, index)
            }
        }
        return nil
    }
    
    mutating func moveSelected(cards: [Card], from source: Pile, to destination: Pile) -> Bool {
        guard let bottomCard = cards.first else { return false }
        var allowed = false
        
        switch destination {
        case .tableau(let column):
            allowed = canMoveCardToTableau(bottomCard, column: column)
        case .foundation(let suit):
            guard cards.onlyOne else { return false }
            allowed = canMoveCardToFoundation(bottomCard, for: suit)
        default:
            return false
        }
        
        if allowed {
            moveCards(cards, from: source, to: destination)
        }
        return allowed
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
            removeCardsFromTableau(cards, column: column)
        }
    }
    
    /// Make sure the remaining top card is face up
    private mutating func removeCardsFromTableau(_ cards: [Card], column: Int) {
        // Remove cards
        let sourceColumnCards = tableau[column]
        tableau[column] = sourceColumnCards.filter { !cards.contains($0) }
        // Make sure that the top card is face up
        let lastIndexOfColumn = tableau[column].count - 1
        if lastIndexOfColumn >= 0 {
            tableau[column][lastIndexOfColumn].isFaceUp = true
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
