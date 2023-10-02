//
//  Theme.swift
//  Solitaire
//
//  Created by Jack Radford on 02/10/2023.
//

import Foundation
import SwiftUI

enum Theme: String, Identifiable, CaseIterable, Hashable, Codable {
    case system
    case light
    case dark
    
    var id: Self { self }
    
    func toColorScheme() -> ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        default:
            return .none
        }
    }
    
    /// The `LocalizedStringKey` of `rawValue`
    var local: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}
