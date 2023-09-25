//
//  Card.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import Foundation

extension SolitaireGame {
    struct Card {
        let id: UUID
        let rank: Rank
        let suit: Suit
        var isFaceUp = false
        
        enum Suit: CaseIterable {
            case spade, club, diamond, heart
        }
        enum Rank: CaseIterable {
            case ace, two, three, four,
                 five, six, seven , eight,
                 nine, ten, jack, queen, king
        }
    }
}
