//
//  JoinStageView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI

struct PublicJoinView: View {
    @State private var rooms: [Room] = []
    @State private var selectedRoomId: String?
    @State private var timer: Timer?
    @State private var isNavigating = false
    @State private var joinError: String?
    
    let apiService = ServerComsController()
    
    var body: some View {
        NavigationStack {
            List(rooms, id: \.id, selection: $selectedRoomId) { room in
                HStack {
                    Text("Host: \(room.host.name ?? "???")")
                    Spacer(minLength: 20)
                    Text("Players: \(room.players!.count)")
                }
                .contentShape(Rectangle()) // Makes row fully tappable
                .onTapGesture {
                    selectedRoomId = room.id
                }
            }
            .onAppear {
                startPeriodicFetching()
            }
            .onDisappear {
                stopPeriodicFetching()
            }
            .navigationTitle("Rooms (public)")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Room") {
                        joinSelectedRoom()
                    }
                    .disabled(selectedRoomId == nil)
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                            if let roomId = selectedRoomId {
                                LineUpView(roomId: roomId)
                            }
                        }
            
            if let error = joinError {
                Text(error)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func joinSelectedRoom() {
        guard let roomId = selectedRoomId else { return }
        apiService.joinRoom(roomId: roomId, player: GameController.shared.player) { result in
            DispatchQueue.main.async {
                        switch result {
                        case .success:
                            print("Successfully joined room")
                            isNavigating = true  // Trigger navigation ONLY after successful join
                            joinError = nil      // Clear any previous error

                        case .failure(let error):
                            print("Error joining room: \(error)")
                            joinError = "Failed to join room: \(error.localizedDescription)"
                            
                            // Automatically clear error after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                joinError = nil
                            }
                        }
                    }
        }
    }
    
    private func startPeriodicFetching() {
        print("Fetching rooms...")
        fetchRooms()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            fetchRooms()
        }
    }
    
    private func stopPeriodicFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchRooms() {
        apiService.getAllRooms { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRooms):
                    rooms = fetchedRooms
                    print("Rooms fetched successfully:", fetchedRooms)
                case .failure(let error):
                    print("Rooms fetch error:", error)
                }
            }
        }
    }
}
#Preview {
    PublicJoinView()
}

