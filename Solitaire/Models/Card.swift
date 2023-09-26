//
//  Card.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import Foundation

extension Game {
    struct Card: Equatable {
        let id: UUID
        let rank: Rank
        let suit: Suit
        var isFaceUp = false
        
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.id == rhs.id
        }
        
        enum Suit: CaseIterable {
            case spade, club, diamond, heart
            
            var color: String {
                switch self {
                case .club, .spade:
                    return "black"
                case .diamond, .heart:
                    return "red"
                }
            }
        }
        
        enum Rank: Int, CaseIterable {
            case ace = 1
            case two = 2
            case three = 3
            case four = 4
            case five = 5
            case six = 6
            case seven = 7
            case eight = 8
            case nine = 9
            case ten = 10
            case jack = 11
            case queen = 12
            case king = 13
        }
    }
}
