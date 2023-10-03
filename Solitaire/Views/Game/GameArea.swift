//
//  GameArea.swift
//  Solitaire
//
//  Created by Jack Radford on 03/10/2023.
//

import SwiftUI

struct GameArea: View {
    @Namespace private var gameNamespace
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var cardWidth: CGFloat = .zero
    
    private let spacing: CGFloat = 24
    
    var body: some View {
        Group {
            if orientation.isLandscape { landscapeLayout } else { portraitLayout }
        }
        .padding()
        .background(.quaternary)
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
        .onOrientationChange { newOrientation in
            orientation = newOrientation
        }
    }
    
    private var landscapeLayout: some View {
        HStack(alignment: .top, spacing: spacing) {
            foundations
            tableau
            VStack(alignment: .trailing) {
                deck
                talon
            }
        }
    }
    private var portraitLayout: some View {
        VStack(spacing: spacing) {
            HStack(spacing: TableauView.columnSpacing) {
                foundations
                talon
                deck
            }
            tableau
        }
    }
    
    private var foundations: some View { FoundationsView(cardWidth: cardWidth, orientation: orientation) }
    private var deck: some View { DeckView(cardWidth: cardWidth) }
    private var talon: some View { TalonView(cardWidth: cardWidth) }
    private var tableau: some View { TableauView(cardWidth: $cardWidth) }
}

struct GameArea_Previews: PreviewProvider {
    static var previews: some View {
        GameArea()
            .environmentObject(GameViewModel(Game()))
    }
}
