import SwiftUI

struct LineUpView: View {
    var roomId: String // Accept only the Room ID
    @State private var room: Room? // Store the fetched room details
    @State private var errorMessage: String?
    @State private var isFirstLoad = true
    @State private var navigateToGuestView = false
    @State private var timer: Timer?
    // Reference to your API controller
    private let serverComsController = ServerComsController()
    private let gameController = GameController.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                if let room = room {
                    
                    // Display room details
                    VStack {
                        Text(room.id)
                            .htwTitleStyle()
                            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
                    }.htwContainerStyle().frame(minWidth: 200)
                    
                    Spacer()
                    
                    // Make the player list scrollable
                    ScrollView {
                        VStack {
                            ForEach(Array(room.players ?? []), id: \.self) { player in
                                HStack {
                                    Text(player.name ?? "Unknown")
                                    Spacer()
                                    Button(action: {
                                        markPlayerReady(player: player) // Mark this player as ready
                                    }) {
                                        Text(player.ready ? "Ready" : "Not Ready")
                                            .foregroundColor(player.ready ? .green : .red)
                                            .padding(8)
                                            .background(player.ready ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    .disabled(player.ready)  // Disable button if player is already ready
                                }
                                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                                .htwContainerStyle()
                            }
                        }
                    }
                    .frame(maxHeight: 300) // You can adjust the max height for the scrollable area
                    
                    Spacer()
                    
                    Button("showtime") {
                        // API call startGame()
                        serverComsController.startGame(roomId: roomId, completion: { result in
                            switch result {
                            case .success:
                                print("Game started")
                                navigateToGuestView = true
                            case .failure(let error):
                                print("Error starting game: \(error)")
                            }
                        })
                        // #TODO Musik abspielen
                    }
                    .disabled(room.players?.count ?? -1 < 1 || room.host != gameController.player && false)    // #TODO: set to -1 < 2 again after testing, rmv false
                    .buttonStyle(.htwPrimary)
                    
                } else if isFirstLoad {
                    // Show loading view during the first fetch
                    ProgressView("Loading room details...")
                } else if let errorMessage = errorMessage {
                    // Show error message if fetching fails
                    Text("Failed to load room")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(isPresented: $navigateToGuestView){
                GuessView()
            }
            .onAppear {
                startFetchingRoom() // Start fetching when the view appears
            }
            .onDisappear {
                stopFetchingRoom() // Stop fetching when the view disappears
            }
        }
    }
    
    /// Start periodic fetching of room details every 5 seconds
    private func startFetchingRoom() {
        stopFetchingRoom() // Ensure previous timer is stopped before starting a new one
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            fetchRoom()
        }
    }
    
    /// Stop the timer when the view disappears
    private func stopFetchingRoom() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Fetch a specific room's details using `ServerComsController`
    private func fetchRoom() {
        if isFirstLoad { isFirstLoad = true } // Show loading indicator only during the first fetch
        
        serverComsController.getRoomById(id: roomId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRoom):
                    print("fetchedRoom:", fetchedRoom)
                    self.room = fetchedRoom
                    self.errorMessage = nil
                    self.isFirstLoad = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.room = nil
                    self.isFirstLoad = false
                }
            }
        }
    }
    
    /// Mark a player as ready and update the room details
    private func markPlayerReady(player: Player) {
        guard let roomId = room?.id else { return }
        
        serverComsController.markPlayerReady(roomId: roomId, playerId: player.name ?? "UNKNOWN") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedRoom):
                    print("Player marked as ready, updated room:", updatedRoom)
                    self.room = updatedRoom  // Update room details
                case .failure(let error):
                    print("Error marking player as ready:", error)
                    // Handle error (e.g., show an alert)
                }
            }
        }
    }
}

#Preview {
    LineUpView(roomId: "UK3F")
}
