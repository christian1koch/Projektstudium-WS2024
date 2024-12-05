import SwiftUI
import ViewModels


struct ShazamView: View {
    @StateObject private var viewModel = ShazamViewModel() 
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.toggleListening()
            }) {
                Text(viewModel.listeningButtonTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            requestMicrophonePermission { granted in
                if granted {
                    print("Microphone access granted")
                    // Proceed with microphone usage, such as recording audio
                } else {
                    print("Microphone access denied")
                    // Handle permission denial
                }
            }
        }
    }
}
