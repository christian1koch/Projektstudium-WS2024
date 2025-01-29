//
//  SpotifyController.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 17.01.25.
//

import Foundation
import SpotifyiOS

class SpotifyController: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate, ObservableObject {
    
    var accessToken: String? = nil
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Handle the error
        }
    }
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        print("appRemote \(appRemote.description)")
        return appRemote
    }()
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: redirectUri)
        configuration.playURI = nil
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    func connect(playURI: String) {
        let stringScopes = [
                    "app-remote-control",       // Allows control over playback
                    "streaming",              // Allows streaming
                    "user-modify-playback-state", // Allows modifying playback state (pause, play)
                    "user-read-playback-state"   // Allows reading playback state (current track, status)
                ]
        self.appRemote.authorizeAndPlayURI(playURI, asRadio: false, additionalScopes: stringScopes)
    }
}
