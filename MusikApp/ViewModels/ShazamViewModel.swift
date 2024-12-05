//  Created by Dennis Forster on 05.12.2024

import Models

struct ShazamViewModel: ObservableObject {
    @Published var isListening = false
    @Published var listeningButtonTitle = "Start Listening"
    
    private var audioRecognizer = AudioRecognizer()
    
    func toggleListening() {
        isListening.toggle()
        if isListening {
            audioRecognizer.startListening()
        } else {
            audioRecognizer.stopListening()
        }
        listeningButtonTitle = isListening ? "Stop Listening" : "Start Listening"
    }
}
