//
//  ContentView.swift
//  SpotifyRemoteSwiftUI
//
//  Created by Geoffrey Matrangola on 2/4/23.
//

import SwiftUI
import SpotifyiOS

struct SpotifyTestView: View {
    @EnvironmentObject var spotifyController: SpotifyController
    @State var currentTrackId = "";
    
    var body: some View {
        VStack {
            TextField(
                "Enter your Tack ID",
                text: $currentTrackId
            )
            .disableAutocorrection(true)
            .onSubmit(playSpotifyTrack)
            
        }
        .padding()
    }
    
    func playSpotifyTrack() {
        spotifyController.connect(playURI: "spotify:track:\(currentTrackId)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyTestView().environmentObject(SpotifyController())
    }
}
