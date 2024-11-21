//
//  ApiController.swift
//  MusikApp
//
//  Created by david brundert on 21.11.24.
//

import Foundation


class SpotifyApiController {

    var token: String = ""

    func setToken(token: String) {
        self.token = token
    }
    
    /**
        Führt über die Spotify API eine Suche nach einem Track durch, 
        wenn der Name und der Künstler des Tracks bekannt sind
    */
    func searchForTrackId(name: String, artist: String) {
        if name.isEmpty || artist.isEmpty {
            // TODO: defensive logic
        }
        // replace spaces with %2520
        let name_ = name.replacingOccurrences(of: " ", with: "+")
        let artist_ = artist.replacingOccurrences(of: " ", with: "+")

        let query = "https://api.spotify.com/v1/search?q=track:\(name_)+artist:\(artist_)&type=track"
        guard let url = URL(string: query) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Setze die Header
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Fehler: \(error.localizedDescription)")
                return
            }
            
            // TODO: extract track id from response
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Antwort: \(dataString)")
                }
            }
        }
        task.resume()
    }

    func fetchParametersOfTrack(trackId: String) {
        // TODO: implement
        /*
        https://api.spotify.com/v1/audio-features/{id}
        */
    }

    struct Parameters {
        let acousticness: Double
        let min_acousticness: Double
        let max_acousticness: Double
        //------------------------------
        let danceability: Double
        let min_danceability: Double
        let max_danceability: Double
        //------------------------------
        let energy: Double
        let min_energy: Double
        let max_energy: Double
        //------------------------------
        let instrumentalness: Double
        let min_instrumentalness: Double
        let max_instrumentalness: Double
        //------------------------------
        let key: Int
        let min_key: Int
        let max_key: Int
        //------------------------------
        let liveness: Double
        let min_liveness: Double
        let max_liveness: Double
        //------------------------------
        let loudness: Double
        let min_loudness: Double
        let max_loudness: Double
        //------------------------------
        let mode: Int
        let min_mode: Int
        let max_mode: Int
        //------------------------------
        let popularity: Int
        let min_popularity: Int
        let max_popularity: Int
        //------------------------------
        let speechiness: Double
        let min_speechiness: Double
        let max_speechiness: Double
        //------------------------------    
        let tempo: Double
        let min_tempo: Double
        let max_tempo: Double
        //------------------------------
        let valence: Double
        let min_valence: Double
        let max_valence: Double
    }

    func fetchRecommendations(amount: Int, seedGenres: [String], seedArtists: [String], seedTracks: [String], parameters: Parameters) {
        // TODO: implement
    }

    /**
     Führt testweise einen API-Aufruf durch
     - Parameter token: Das Autorisierungstoken
     */
    func apiCallTest() {
        // Die Basis-URL der API
        var baseURL = "https://api.spotify.com/v1/recommendations"
        baseURL = "https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_genres=classical%2Ccountry&seed_tracks=0c6xIDDpzE81m2q797ordA"
        
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Setze die Header
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
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
}
