//
//  BackstageView.swift
//  MusikApp
//
//  Created by Christian Trefzer on 26.01.25.
//

import SwiftUI

struct BackstageView: View {
    @State private var playerName: String = ""
    
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
                
                // Add player button
                Button("host a stage") {
                    // Add player action
                }
                .buttonStyle(.htwPrimary)
                
                // Join a game
                Button("join a stage") {
                    // Join game action
                }
                .buttonStyle(.htwPrimary)
            }
            
        }
        
    }
}

#Preview {
    BackstageView()
}
