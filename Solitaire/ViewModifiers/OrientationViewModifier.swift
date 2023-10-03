//
//  OrientationViewModifier.swift
//  Solitaire
//
//  Created by Jack Radford on 03/10/2023.
//

import Foundation
import SwiftUI
import UIKit

/// Calls the `action` with the new `UIDeviceOrientation` when the device orientation changes
struct OrientationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onOrientationChange(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(OrientationViewModifier(action: action))
    }
}
