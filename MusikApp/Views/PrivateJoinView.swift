import Foundation
import SwiftUI

struct PrivateJoinView: View {
    @State private var roomId: String = ""  // Room ID entered by the user
    @State private var room: Room?  // To store fetched room details
    @State private var errorMessage: String?  // To display error messages
    @State private var isJoiningRoom = false  // To disable the join button while joining
    @State private var navigateToLineUpView = false  // Flag to trigger navigation to LineUpView
    let apiService = ServerComsController()
    let gameController = GameController.shared  // To access the current player info
    
    var body: some View {
        NavigationStack {
            Form {
                // Room ID text field for the user to enter the room they want to join
                TextField("Room Id", text: $roomId)
                    .autocorrectionDisabled()
                
                if let room = room {
                    Section("Room Details") {
                        Text("Host: \(room.host.name ?? "Unknown")")
                        Text("Players: \(room.players?.count ?? 0)")
                        if let status = room.status {
                            Text("Status: \(status.rawValue)")
                        }
                    }
                }
                
                // Error message section
                if let errorMessage = errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Join Room")
            .navigationDestination(isPresented: $navigateToLineUpView) {
                LineUpView(roomId: room?.id ?? "")  // Navigate to LineUpView after joining
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Room") {
                        joinRoom()  // Call the method to join the room
                    }
                    .disabled(roomId.isEmpty || isJoiningRoom)  // Disable if no room ID or joining is in progress
                }
            }
        }
    }
    
    // Function to join the room
    private func joinRoom() {
        guard !roomId.isEmpty else { return }
        
        isJoiningRoom = true  // Disable the button while joining
        
        // Fetch room details to verify if it exists
        apiService.getRoomById(id: roomId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRoom):
                    self.room = fetchedRoom
                    self.errorMessage = nil
                    
                    // Join the player to the room after successful fetch
                    self.joinPlayerToRoom(room: fetchedRoom)
                case .failure(let error):
                    self.room = nil
                    self.errorMessage = error.localizedDescription
                    self.isJoiningRoom = false
                }
            }
        }
    }
    
    // Function to join the player to the room
    private func joinPlayerToRoom(room: Room) {
        let player = gameController.player  // Assuming gameController has the player info
        
        apiService.joinRoom(roomId: room.id, player: player) { result in
            DispatchQueue.main.async {
                self.isJoiningRoom = false  // Re-enable the button after operation completes
                
                switch result {
                case .success(let updatedRoom):
                    print("Player successfully joined the room: \(updatedRoom)")
                    // Update room details after successful join
                    self.room = updatedRoom
                    
                    // Trigger navigation to LineUpView
                    self.navigateToLineUpView = true
                case .failure(let error):
                    print("Failed to join room: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription  // Display the error
                }
            }
        }
    }
}

#Preview {
    PrivateJoinView()
}
