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
    @AppStorage(UDKey.theme()) var theme = Theme.system.rawValue
    
    @State private var showingCompleteAlert = false
    @State private var showingSettingsSheet = false
    
    var body: some View {
        NavigationStack {
            GameArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { menuButton }
                ToolbarItem(placement: .navigationBarLeading) { score }
                ToolbarItem { Text(gameVM.timeElapsed) }
            }
            .font(Font.system(.body, design: .monospaced))
            .onChange(of: gameVM.isComplete) { value in
                showingCompleteAlert = value
            }
            .onChange(of: scenePhase, perform: handleScenePhaseChange)
            .alert("Complete!", isPresented: $showingCompleteAlert) {
                Button("Play Again") { resetGame() }
            }
            .sheet(isPresented: $showingSettingsSheet) { SettingsView() }
        }
        .preferredColorScheme(Theme(rawValue: theme)?.toColorScheme())
    }
    
    private var score: some View {
        Text("Score: \(gameVM.game.score)")
            .animation(.none)
    }
    
    private var menuButton: some View {
        Menu {
            settingsBtn
            newGameBtn
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
    private var settingsBtn: some View {
        Button {
            showingSettingsSheet = true
        } label: {
            Label("Settings", systemImage: "gearshape.fill")
        }
    }
    
    private var newGameBtn: some View {
        Button(action: resetGame) {
            Label("New Game", systemImage: "play.fill")
        }
    }
    
    /// Saves the game state if `newScenePhase` is background or inactive
    private func handleScenePhaseChange(newScenePhase: ScenePhase) {
        switch newScenePhase {
        case .background, .inactive:
            gameVM.saveGame()
        case .active:
            gameVM.startTimer()
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
