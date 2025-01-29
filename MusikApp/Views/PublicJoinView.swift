//
//  JoinStageView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI

struct PublicJoinView: View {
    let gameController = GameController.shared
    @State private var rooms: [Room] = []
    @State private var selectedRoomId: String?
    @State private var timer: Timer?
    @State private var navigateToRoom = false
    @State private var isJoiningRoom = false
    let apiService = ServerComsController()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rooms, id: \.id) { room in
                    HStack {
                        Text("Host: \(room.host.name ?? "???")")
                        Spacer(minLength: 20)
                        Text("Players: \(room.players?.count ?? 0)")
                    }
                    .contentShape(Rectangle()) // ✅ Makes the whole row tappable
                    .onTapGesture {
                        selectedRoomId = room.id // ✅ Update selected room ID manually
                    }
                    .background(
                        room.id == selectedRoomId ? Color.blue.opacity(0.2) : Color.clear // ✅ Highlight selection
                    )
                }
            }
            .onAppear {
                startPeriodicFetching()
            }
            .onDisappear {
                stopPeriodicFetching()
            }
            .navigationTitle("Rooms (public)")
            .navigationDestination(isPresented: $navigateToRoom){
                LineUpView(roomId: selectedRoomId ?? "ABCD")
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if selectedRoomId == nil || isJoiningRoom {
                        Button("Join Room") {
                            // Do nothing when button is disabled
                        }
                        .disabled(true)
                    } else {
                        Button("Join Room") {
                            joinRoom()
                        }
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                    }
                }
            }
        }
        
    }
    
    private func startPeriodicFetching() {
        print("fetching rooms...")
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
                    print("success", fetchedRooms);
                case .failure(let error):
                    print("Rooms fetch error: \(error)")
                }
            }
        }
    }
    private func joinRoom() {
        guard let selectedRoomId = selectedRoomId else { return }
        
        isJoiningRoom = true  // Set the flag to disable the button while joining
        
        // Create the player object (using details from your gameController or wherever)
        let player = gameController.player  // Assuming gameController has the player info
        
        apiService.joinRoom(roomId: selectedRoomId, player: player) { result in
            DispatchQueue.main.async {
                isJoiningRoom = false  // Reset the flag when the operation is complete
                
                switch result {
                case .success(let updatedRoom):
                    print("Joined room successfully: \(updatedRoom)")
                    // Navigate to the LineUpView with the updated room
                    // You can either pass the updated room or just the ID
                    navigateToRoom = true;
                case .failure(let error):
                    print("Failed to join room: \(error.localizedDescription)")
                }
            }
        }
    }

}
#Preview {
    PublicJoinView()
}

