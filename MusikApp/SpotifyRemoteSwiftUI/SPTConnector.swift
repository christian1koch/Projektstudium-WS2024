//
//  SPTConnector.swift
//  SpotifyRemoteSwiftUI
//
//  Created by Geoffrey Matrangola on 2/12/23.
//

import SwiftUI
import SpotifyiOS

class SPTConnector: NSObject, ObservableObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate, SPTSessionManagerDelegate {
    // Indicates whether the app is connected to Spotify
    @Published var isConntected: Bool = false
    
    // Indicates whether the user is authorized
    @Published var isAuthorized: Bool = false;
    
    // Stores the current state of the Spotify player
    @Published var playerSteate: SPTAppRemotePlayerState? = nil
    
    // Stores the artwork for the currently playing track
    @Published var artwork: UIImage? = nil
    
    // Stores any errors encountered during operations
    @Published var error: Error? = nil
    
    // Stores the current Spotify session
    @Published var sptSession: SPTSession? = nil
    
    // Caches the last known player state
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    // MARK: - Spotify Authorization & Configuration
    
    // Stores the response code used to fetch an access token
    var responseCode: String? {
        didSet {
            print("responseCode didSet")
            fetchAccessToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    self.error = error
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    print("responseCode didSet appRemote")
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }
    
    // Lazy-loaded instance of the Spotify app remote
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        print("appRemote \(appRemote.description)")
        return appRemote
    }()
    
    // Extracts and sets the access token from a URL after authentication
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        print("setAccessToken")
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    func getAccessTokenFromURL(from url: URL) -> String? {
        let parameters = appRemote.authorizationParameters(from: url)
        print("setAccessToken")
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            return accessToken;
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            return nil;
        }
        return nil;
    }
    // Stores the access token and updates it in UserDefaults
    var accessToken = UserDefaults.standard.string(forKey: accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: accessTokenKey)
        }
    }
    
    // Extracts the response code or access token from a URL and updates properties
    func setResponseCode(from url: URL) {
        let parameters = self.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            self.responseCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            self.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
        }
    }
    
    // Configuration for the Spotify app, including client ID and redirect URL
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: redirectUri)
        configuration.playURI = nil
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    // Called when a connection to Spotify is successfully established
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        isConntected = true
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
                self.error = error
            }
        })
        print("appRemoteDidEstablishConnection")
        fetchPlayerState()
    }
    
    // MARK: - Session Manager
    
    // Lazy-loaded session manager for handling Spotify sessions
    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        print("sessionManager \(manager.description)")
        return manager
    }()
    
    // Handles session failures and logs errors
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
            print("AUTHENTICATE with WEBAPI")
        } else {
            isAuthorized = false
            print(error.localizedDescription)
            self.error = error
        }
    }
    
    // Called when a session is successfully renewed
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session Renewed \(session.description)")
        self.sptSession = session
    }
    
    // Called when a session is successfully initiated
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("sessionManager didInitiate \(session.description)")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    // Initiates a session with the specified scopes
    func initiateSession(trackId: String) {
        print("initiateSession() start")
        configuration.playURI = "spotify:track:\(trackId)"
        guard let sessionManager = sessionManager else { return }
        sessionManager.initiateSession(with: scopes, options: .clientOnly, campaign: nil)
        print("initiateSession() called")
    }
    
    // Handles a failed connection attempt and logs the error
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Could not connetect \(String(describing: error))")
        self.error = error
        self.isConntected = false
    }
    
    // Handles disconnections and resets state properties
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Connection Lost \(String(describing: error))")
        isConntected = false
        self.error = error
        playerSteate = nil
        artwork = nil
    }
    
    // Updates the player state and fetches artwork if necessary
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("playerStateDidChange()")
        lastPlayerState = self.playerSteate
        self.playerSteate = playerState
        if (lastPlayerState == nil || lastPlayerState?.track.uri != playerState.track.uri) {
            fetchArtwork(for: playerState.track)
        }
    }
    
    // MARK: - Networking
    
    // Fetches an access token using a POST request to Spotify's token endpoint
    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        print("fetchAccessToken")
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((spotifyClientId + ":" + spotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ")
        
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: spotifyClientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: redirectUri.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                print("Error fetching token \(error?.localizedDescription ?? "")")
                return completion(nil, error)
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    // Fetches artwork for the current track using Spotify's image API
    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.artwork = image
            }
        })
    }
    
    // Retrieves the current state of the Spotify player
    func fetchPlayerState() {
        print("fetchPlayerState()")
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
                self?.error = error
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.playerSteate = playerState
                print("got player state \(playerState.description)")
                self?.fetchArtwork(for: playerState.track)
            }
        })
    }
}
