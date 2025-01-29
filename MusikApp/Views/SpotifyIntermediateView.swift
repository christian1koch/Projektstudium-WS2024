import SwiftUI
import SpotifyiOS

struct SpotifyIntermediateView: View {
    @StateObject var sptConnector = SPTConnector()
    @State private var isConnected = false
    @State private var navigateToNextView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if sptConnector.isConntected {
                    Text("Connected to Spotify ✅")
                        .font(.title)
                } else {
                    Text("Connecting to Spotify...")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .onAppear {
                sptConnector.initiateSession()
            }
            .navigationDestination(isPresented: $navigateToNextView) {
                GuessView().environmentObject(sptConnector)
            }
            .onOpenURL { url in
                sptConnector.setResponseCode(from: url)
                pauseMusicAndNavigate()
            }
        }
    }
    
    private func pauseMusicAndNavigate() {
        sptConnector.appRemote.playerAPI?.pause { _, error in
            if let error = error {
                print("Error pausing: \(error.localizedDescription)")
            }
        }
        
        // Move to the next screen
        isConnected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            navigateToNextView = true
        }
    }
}
