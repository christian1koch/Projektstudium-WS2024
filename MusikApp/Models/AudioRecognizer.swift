// Created by Dennis Forster on 05.12.2024

import AVFoundation
import ShazamKit

class AudioRecognizer: NSObject, ObservableObject, SHSessionDelegate {
    private let audioEngine = AVAudioEngine()
    private let shazamSession = SHSession()
    
    override init() {
        super.init()
        shazamSession.delegate = self
    }
    
    func startListening() {
        // Sicherstellen, dass die Audio-Session richtig konfiguriert ist
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Fehler beim Aktivieren der AudioSession: \(error)")
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Überprüfen, ob das Format gültig ist
        guard recordingFormat.sampleRate > 0 else {
            print("Ungültige Sample-Rate!")
            return
        }
        
        guard recordingFormat.channelCount > 0 else {
            print("Ungültige Kanalanzahl!")
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 16384, format: recordingFormat) { (buffer, time) in
            self.shazamSession.matchStreamingBuffer(buffer, at: time)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Fehler beim Starten der AudioEngine: \(error)")
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0) 
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Fehler beim Deaktivieren der AudioSession: \(error)")
        }
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        print("Song erkannt: \(match.mediaItems.first?.title ?? "Unbekannt")")
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print("Kein Treffer gefunden: \(error)")
        } else {
            print("Kein Treffer gefunden: kein Fehler")
        }
        
    }
}
