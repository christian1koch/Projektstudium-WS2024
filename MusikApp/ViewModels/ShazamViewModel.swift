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

    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
    // Check if the microphone permission is already granted
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
        // Microphone access is already granted
        completion(true)
    case .notDetermined:
        // Microphone access has not been determined yet, request permission
        AVCaptureDevice.requestAccess(for: .audio) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    case .denied, .restricted:
        // Microphone access has been denied or is restricted
        DispatchQueue.main.async {
            completion(false)
        }
    @unknown default:
        // Handle any other cases (future iOS versions)
        DispatchQueue.main.async {
            completion(false)
        }
    }
}

}
