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
    @Namespace private var gameNamespace
    @State private var showingCompleteAlert = false
    @State private var showingSettingsSheet = false
    
    @State var cardWidth: CGFloat = .zero
    
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsBtn
                }
                ToolbarItem {
                    HStack {
                        Text(String(gameVM.game.score))
                        Divider()
                        Text(gameVM.timeElapsed)
                    }
                        .font(Font.system(.body, design: .monospaced))
                }
            }
            .alert("Complete!", isPresented: $showingCompleteAlert) {
                Button("Play Again") { resetGame() }
            }
            .onChange(of: gameVM.isComplete) { value in
                showingCompleteAlert = value
            }
            .onChange(of: scenePhase, perform: handleScenePhaseChange)
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView()
            }
        }
        .environmentObject(NamespaceWrapper(namespace: gameNamespace))
        .preferredColorScheme(Theme(rawValue: theme)?.toColorScheme())
    }
    
    private var settingsBtn: some View {
        Button {
            showingSettingsSheet = true
        } label: {
            Image(systemName: "gearshape.fill")
        }
    }
    
    private var newGameBtn: some View {
        Button("New Game") { resetGame() }
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
