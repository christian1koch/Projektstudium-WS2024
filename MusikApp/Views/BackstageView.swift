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
                        
                        // navigate to stage setup
                        navigateToStageSetup = true
                        NavigationLink(destination: StageSetupView()) {     //FIX This
                        }
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
                
                // Join private game button
                Button("join pivate stage") {
                    if isUserNameValid() {
                        let player = Player(name: playerName, points: 0, ready: false)
                        gameController.player = player
                        // navigate to private stage
                        navigateToPrivateStage = true
                        NavigationLink(destination: PrivateJoinView()) {    //FIX This
                        }
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
                
                // Join public game button
                Button("join public stage") {
                    if isUserNameValid() {
                        let player = Player(name: playerName, points: 0, ready: false)
                        gameController.player = player
                        
                        // navigate to private stage
                        navigateToPublicStage = true
                        NavigationLink(destination: PublicJoinView()) {     //FIX This
                        }
                    }
                }
                .buttonStyle(.htwPrimary)
                .disabled(!isUserNameValid())
                
                // Navigation Links (triggered by state changes)
                NavigationLink(destination: StageSetupView(), isActive: $navigateToStageSetup) {
                    EmptyView()
                }
                NavigationLink(destination: PrivateJoinView(), isActive: $navigateToPrivateStage) {
                    EmptyView()
                }
                NavigationLink(destination: PublicJoinView(), isActive: $navigateToPublicStage) {
                    EmptyView()
                }
            }
            .padding()
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
