//
//  ClientAuthController.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 13.11.24.
//

import Foundation

enum SpotifyClientAuthError: Error {
    case credentialsEncode
}

struct SpotifyClientAuthResponse: Decodable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

class SpotifyClientAuthController {
    let spotifyClientId = "9c72d168785c44269283b02508014d5a"
    let spotifyClientSecret = "b47b0acd20e3410abaefac09d53df6ea"
    let authURL = "https://accounts.spotify.com/api/token"
    var credentials: String {
        "\(spotifyClientId):\(spotifyClientSecret)"
    }
    func getBase64EncodedCredentials() throws -> String {

        if let data = credentials.data(using: .utf8) {
            // Encode the data to Base64
            let base64String = data.base64EncodedString()
            return base64String;
        }
        throw SpotifyClientAuthError.credentialsEncode
    }
    
    func requestAccessToken() async throws -> String {
        
        struct RequestData: Encodable {
            let grant_type: String
        }        
        let url = URL(string: authURL)!
        var request = URLRequest(url: url)
        let credentials = try getBase64EncodedCredentials()
        let body = "grant_type=client_credentials"
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(SpotifyClientAuthResponse.self, from: data)
        
        return decoded.access_token
    }
    
}

