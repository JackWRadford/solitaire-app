//
//  GameView.swift
//  Solitaire
//
//  Created by Jack Radford on 24/09/2023.
//
import SwiftUI

struct GameView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var gameVM: GameViewModel
    @State var cardWidth: CGFloat = .zero
    @State private var showingCompleteAlert = false
    @Namespace private var gameNamespace
    
    var body: some View {
        NavigationStack {
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
                ToolbarItem(placement: .navigationBarLeading) {
                    newGameBtn
                }
            }
            .alert("Complete!", isPresented: $showingCompleteAlert) {
                Button("Play Again") { resetGame() }
            }
            .onChange(of: gameVM.isComplete) { value in
                showingCompleteAlert = value
            }
            .onChange(of: scenePhase, perform: handleScenePhaseChange)
        }
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
    }
    
    private var newGameBtn: some View {
        Button("New Game") { resetGame() }
    }
    
    /// Saves the game state if `newScenePhase` is background or inactive
    private func handleScenePhaseChange(newScenePhase: ScenePhase) {
        switch newScenePhase {
        case .background, .inactive:
            gameVM.saveGame()
        default:
            break
        }
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
