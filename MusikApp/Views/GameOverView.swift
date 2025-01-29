//
//  GameOverView.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameOverViewModel
    @State private var navigateToLineUp = false
    @State private var navigateToBackstage = false
    @State private var roomId: String? = "FB1S" //nil //#TODO: set to nil
    
    @State var gameController: GameController = GameController.shared
    
    var body: some View {
        NavigationStack {
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
                        roomId = gameController.activeRoom?.id
                        navigateToLineUp = true
                    }
                    .buttonStyle(.htwPrimary)
                    
                    Button("Backstage") {
                        // Backstage action
                        navigateToBackstage = true
                    }
                    .buttonStyle(.htwDestructive)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .navigationDestination(isPresented: $navigateToBackstage) {
                BackstageView()
            }
            .navigationDestination(isPresented: $navigateToLineUp) {
                if let roomId = roomId {
                    LineUpView(roomId: roomId)
                } else {
                    Text("Error: Room ID is missing").foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    GameOverView(viewModel: GameOverViewModel(players: [Player(name: "Dennis", points: 10), Player(name: "Max", points: 5)]))
}
