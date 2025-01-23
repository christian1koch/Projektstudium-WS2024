//
//  LineUpView.swift
//  MusikApp
//
//  Created by Christian Trefzer on 23.01.25.
//

import SwiftUI

struct LineUpView: View {
    var room: Room

    var body: some View {
        VStack(spacing: 16) {
            Text(room.id ?? "Unknown Room ID")
                .htwContainerStyle()
                .font(.headline)

            Text("Spieler")
                .htwTitleStyle()

            ForEach(Array(room.players ?? []), id: \.self) { player in
                Text(player.name ?? "Unknown")
                    .padding()
                    .htwContainerStyle()
            }

            Button("showtime") {
                // TODO: Add action
            }
            .buttonStyle(.htwPrimary)
        }
        .padding()
    }
}

#Preview {
    LineUpView(room: Room(id: "1234", host: Player(name: "Host"), players: [Player(name: "Klaus"), Player(name: "Gabi")], rounds: nil, settings: Settings(mode: .FASTEST_STOPS, maxPlayers: 2, isPublic: false), status: nil, activeRound: nil))
}
