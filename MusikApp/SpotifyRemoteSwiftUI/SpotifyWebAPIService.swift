//
//  SpotifyWebAPIService.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 15.01.25.
//

import Foundation
class SpotifyWebAPIService {
    func getAccessToken(completion: @escaping (String?) -> Void) {
        let tokenURL = "https://accounts.spotify.com/api/token"
        let credentials = "\(spotifyClientId):\(spotifyClientSecretKey)"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "grant_type=client_credentials"
        request.httpBody = bodyData.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                completion(accessToken)
            } else {
                print("Failed to parse token response")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func searchSong(accessToken: String, query: String, completion: @escaping (String?) -> Void) {
        let searchURL = "https://api.spotify.com/v1/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=track&limit=1"
        var request = URLRequest(url: URL(string: searchURL)!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        print("access Token", accessToken)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if there's an error with the network request itself
            guard let data = data, error == nil else {
                print("Error performing search: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Log the raw response data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")  // This will show the entire raw response
            }
            
            // Attempt to parse the response
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let tracks = json["tracks"] as? [String: Any],
                   let items = tracks["items"] as? [[String: Any]],
                   let firstTrack = items.first,
                   let trackId = firstTrack["id"] as? String {
                    completion(trackId)  // Return the track ID if parsing succeeds
                } else {
                    print("Failed to parse search response: \(json)")  // Print out the entire JSON if parsing fails
                    completion(nil)
                }
            } else {
                print("Failed to parse JSON response.")
                completion(nil)
            }
        }
        task.resume()
    }
}
