//
//  GameOverView.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameOverViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Show is Over\n(Elvis has left the building)")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .overlay(
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Spieler")
                                .fontWeight(.bold)
                            Spacer()
                            Text("Punkte")
                                .fontWeight(.bold)
                        }
                        .padding(.bottom, 5)
                        
                        ForEach(Array(viewModel.players.enumerated()), id: \.offset) { index, player in
                            HStack {
                                Text(player.name ?? "unnamed player")
                                Spacer()
                                Text("\(player.points)")
                            }
                        }
                    }
                    .padding()
                )
                .frame(height: 150)
            
            VStack(spacing: 10) {
                Button(action: {
                    
                }) {
                    Text("restart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
            
                }) {
                    Text("backstage")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    GameOverView(viewModel: GameOverViewModel(players: [Player(name: "Dennis", points: 10), Player(name: "Max", points: 5)]))
}
