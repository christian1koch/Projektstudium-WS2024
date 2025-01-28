//
//  BackstageView.swift
//  MusikApp
//
//  Created by Christian Trefzer on 26.01.25.
//

import SwiftUI

struct BackstageView: View {
    @State var playerName: String = ""
    @State var navigateToStageSetup = false
    @State var navigateToPrivateStage = false
    @State var navigateToPublicStage = false
    
    private var gameController: GameController = GameController.shared

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Title
                Text("Backstage")
                    .htwTitleStyle()
                
                // Enter player name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name").htwTitleStyle()
                    TextField("Elvis Parsley", text: $playerName)
                        .padding()
                }
                .htwContainerStyle()
                
                // Host game button
                Button("host stage") {
                    if isUserNameValid() {
                        let player = Player(name: playerName, points: 0, ready: false)
                        gameController.player = player
                        navigateToStageSetup = true
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
                
                // Join private game button
                Button("join pivate stage") {
                    if isUserNameValid() {
                        let player = Player(name: playerName, points: 0, ready: false)
                        gameController.player = player
                        navigateToPrivateStage = true
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
                
                // Join public game button
                Button("join public stage") {
                    if isUserNameValid() {
                        let player = Player(name: playerName, points: 0, ready: false)
                        gameController.player = player
                        navigateToPublicStage = true
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
            }
            .padding()
            .navigationDestination(isPresented: $navigateToStageSetup) {
                StageSetupView()
            }
            .navigationDestination(isPresented: $navigateToPrivateStage) {
                PrivateJoinView()
            }
            .navigationDestination(isPresented: $navigateToPublicStage) {
                PublicJoinView()
            }
        }
    }
    
    // checks if user name is valide
    private func isUserNameValid() -> Bool {
        return !playerName.isEmpty
    }
}

#Preview {
    BackstageView()
}
