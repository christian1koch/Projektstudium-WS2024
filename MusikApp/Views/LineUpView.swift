import SwiftUI

struct LineUpView: View {
    var roomId: String // Accept only the Room ID
    @State private var room: Room? // Store the fetched room details
    @State private var errorMessage: String?
    @State private var isFirstLoad = true
    @State private var navigateToGuestView = false
    
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
                    ForEach(Array(room.players ?? []), id: \.self) { player in
                        HStack {
                            Text(player.name ?? "Unknown")
                        }
                        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                        .htwContainerStyle()
                        
                    }
                    Spacer()
                    Button("showtime") {
                        // API call startGame()
                        serverComsController.startGame(roomId: roomId, completion: { result in
                            switch result {
                            case .success:
                                print("Game started")
                            case .failure(let error):
                                print("Error starting game: \(error)")
                            }
                        })
                        // #TODO Musik abspielen
                        navigateToGuestView = true
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
                startFetchingRoom()
            }
        }
    }
        
        /// Continuously fetch the room details in a loop
        private func startFetchingRoom() {
            Task {
                while true {
                    await fetchRoom()
                    try? await Task.sleep(nanoseconds: 5_000_000_000) // Fetch every 5 seconds
                }
            }
        }
        
        /// Fetch a specific room's details using `ServerComsController`
        private func fetchRoom() async {
            if isFirstLoad { isFirstLoad = true } // Show loading indicator only during the first fetch
            
            await withCheckedContinuation { continuation in
                serverComsController.getRoomById(id: roomId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let fetchedRoom):
                            self.room = fetchedRoom
                            self.errorMessage = nil
                            self.isFirstLoad = false
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            self.room = nil
                            self.isFirstLoad = false
                        }
                        continuation.resume()
                    }
                }
            }
        }
    }


#Preview {
    LineUpView(roomId: "UK3F")
}
