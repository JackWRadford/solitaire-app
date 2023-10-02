//
//  GameView.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//
import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @State var cardWidth: CGFloat = .zero
    @State private var showingCompleteAlert = false
    @Namespace private var gameNamespace
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: TableauView.columnSpacing) {
                FoundationsView(cardWidth: cardWidth)
                TalonView(cardWidth: cardWidth)
                DeckView(cardWidth: cardWidth)
            }
            TableauView(cardWidth: $cardWidth)
        }
        .padding()
        .background(.quaternary)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                newGameBtn
            }
        }
        .alert("Complete!", isPresented: $showingCompleteAlert) {
            Button("Play Again") { resetGame() }
        }
        .onChange(of: gameVM.isComplete) { value in
            showingCompleteAlert = value
        }
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
    }
    
    private var newGameBtn: some View {
        Button("New Game") { resetGame() }
    }
    
    private func resetGame() {
        withAnimation {
            gameVM.resetGame()
        }
    }
}

class NamespaceWrapper: ObservableObject {
    var namespace: Namespace.ID
    
    init(namespace: Namespace.ID) {
        self.namespace = namespace
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel(Game()))
    }
}
