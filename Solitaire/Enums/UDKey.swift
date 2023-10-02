//
//  UDKey.swift
//  Solitaire
//
//  Created by Jack Radford on 02/10/2023.
//

import Foundation

/// Keys used for UserDefaults. Call as a function to get the String rawValue
///
/// **DO NOT CHANGE VALUES**
enum UDKey: String {
    case theme
    
    /// Return the rawValue when called as a function
    ///
    /// Avoids needing `.rawValue`
    func callAsFunction() -> String {
        return self.rawValue
    }
}
