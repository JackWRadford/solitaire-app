//
//  Card.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//

import Foundation

struct Card: Equatable, Identifiable {
    let id: UUID
    let rank: Rank
    let suit: Suit
    var isFaceUp = false
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum Suit: String, CaseIterable, Identifiable {
        case spade, club, diamond, heart
        
        var id: String { self.rawValue }
        
        enum SuitColor {
            case red, black
        }
        
        var color: SuitColor {
            switch self {
            case .club, .spade:
                return .black
            case .diamond, .heart:
                return .red
            }
        }
        
        var image: String {
            switch self {
            case .club:
                return "suit.club.fill"
            case .spade:
                return "suit.spade.fill"
            case .diamond:
                return "suit.diamond.fill"
            case .heart:
                return "suit.heart.fill"
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
        
        func label() -> String {
            switch self {
            case .ace:
                return "A"
            case .jack:
                return "J"
            case .queen:
                return "Q"
            case .king:
                return "K"
            default:
                return String(self.rawValue)
            }
        }
    }
}
