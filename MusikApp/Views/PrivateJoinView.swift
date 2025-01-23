//
//  PrivateJoinView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI


struct PrivateJoinView: View {
    @State private var roomId: String = ""
    @State private var room: Room?
    @State private var errorMessage: String?
    let apiService = ServerComsController()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Room Id", text: $roomId)
                    .autocorrectionDisabled()
                
                if let room = room {
                    Section("Room Details") {
                        Text("Host: \(room.host.name)")
                        Text("Players: \(room.players?.count ?? 0)")
                        if let status = room.status {
                            Text("Status: \(status.rawValue)")
                        }
                    }
                }
                
                if let errorMessage = errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Join Room")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Room") {
                        fetchRoom()
                    }
                    .disabled(roomId.isEmpty)
                }
            }
        }
    }
    
    private func fetchRoom() {
        apiService.getRoomById(id: roomId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRoom):
                    room = fetchedRoom
                    errorMessage = nil
                case .failure(let error):
                    room = nil
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    PrivateJoinView(stages: stagesMock)
}

