//
//  ContentView.swift
//  SpotifyRemoteSwiftUI
//
//  Created by Geoffrey Matrangola on 2/4/23.
//

import SwiftUI
import SpotifyiOS

struct SpotifyTestView: View {
    @EnvironmentObject var sptConnector: SPTConnector
    let spotifyWebApiService = SpotifyWebAPIService()
    private var lastPlayerState: SPTAppRemotePlayerState?
    @State var songName = "";
    @State var currentTrackId = "";
    
    var body: some View {
        VStack {
            if let img = sptConnector.artwork {
                Image(uiImage: img)
                    .resizable()
            }
            else {
                Image(systemName: "music.note")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
            
            if let playerState = sptConnector.playerSteate {
                Button {
                    if (playerState.isPaused) {
                        sptConnector.appRemote.playerAPI?.resume(nil)
                    }
                    else {
                        sptConnector.appRemote.playerAPI?.pause(nil)
                    }
                } label: {
                    Image(systemName: playerState.isPaused ? "play.rectangle.fill":"pause.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            if (sptConnector.isConntected) {
                Button {
                    sptConnector.appRemote.disconnect()
                    //                }
                    //                else {
                    //                    sptConnector.initiateSession()
                    //                }
                } label: {
                    Text("Disconnect")
                }
                .controlSize(.large)
                
            } else {
                TextField("Find and Play Song", text: $songName)
                    .onSubmit {
                        spotifyWebApiService.getAccessToken { token in
                            if let token = token {
                                spotifyWebApiService.searchSong(accessToken: token, query: songName) { trackId in
                                    if let trackId = trackId {
                                        print("Track ID: \(trackId)")
                                        currentTrackId = trackId
                                        sptConnector.initiateSession(trackId: trackId)
                                    } else {
                                        print("Track not found or error retrieving track ID.")
                                    }
                                }
                            } else {
                                print("Failed to retrieve access token.")
                            }
                        }
                        
                    }
                    .onOpenURL { url in
                        print("onOpenURL \(url.description)")
                        sptConnector.setResponseCode(from: url)
                    }
                //                    }
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyTestView().environmentObject(SPTConnector())
    }
}
