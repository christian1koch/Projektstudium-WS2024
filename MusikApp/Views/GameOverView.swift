//
//  GameOverView.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameOverViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Show is Over\n(Elvis has left the building)")
                .htwTitleStyle()
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading) {
                            HStack {
                                Text("Spieler")
                                    .htwTitleStyle()
                                Spacer()
                                Text("Punkte")
                                    .htwTitleStyle()
                            }
                            .padding(.bottom, 5)
                        
                        ForEach(Array(viewModel.players.enumerated()), id: \.offset) { _, player in
                            HStack {
                                Text(player.name ?? "unnamed player")
                                    .htwSimpleTextStyle()
                                Spacer()
                                Text("\(player.points)")
                                    .htwSimpleTextStyle()
                                    .monospacedDigit()
                            }
                        }
                    }
                    .padding()
                    .htwContainerStyle()
                .frame(height: 150)
            
            VStack(spacing: 10) {
                Button("Restart") {
                    // Restart action
                }
                .buttonStyle(.htwPrimary)
                
                Button("Backstage") {
                    // Backstage action
                }
                .buttonStyle(.htwDestructive)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}

#Preview {
    GameOverView(viewModel: GameOverViewModel(players: [Player(name: "Dennis", points: 10), Player(name: "Max", points: 5)]))
}
