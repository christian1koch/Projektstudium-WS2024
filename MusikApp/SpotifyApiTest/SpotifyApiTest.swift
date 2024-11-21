//
//  SpotifyApiTest.swift
//  MusikApp
//
//  Created by David Adrian Brundert on 07.11.24.
//

import Foundation


func apiCall(token: String) {
    // Die Basis-URL der API
    var baseURL = "https://api.spotify.com/v1/recommendations"
    baseURL = "https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=classical%2Ccountry&seed_tracks=0c6xIDDpzE81m2q797ordA"
    
    guard let url = URL(string: baseURL) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Beispiel-Header (wie Autorisierungstoken)
    request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Erstelle die URLSession
    let session = URLSession.shared

    // Führe die Anfrage aus
    let task = session.dataTask(with: request) { (data, response, error) in
        // Fehlerbehandlung
        if let error = error {
            print("Fehler: \(error.localizedDescription)")
            return
        }
        
        // Verarbeite die Antwort
        if let data = data {
            // Die Antwortdaten als String anzeigen
            if let dataString = String(data: data, encoding: .utf8) {
                print("Antwort: \(dataString)")
            }
        }
    }
    
    // Starte die Aufgabe
    task.resume()
}
