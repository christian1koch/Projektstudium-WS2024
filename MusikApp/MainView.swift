//
//  ContentView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 04.11.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Button("Click to get Spotify Auth Token") {
                
                Task {
                    do {
                        print("requesting...")
                        let clientAuthController = SpotifyClientAuthController()
                        let authToken = try await clientAuthController.requestAccessToken()
                        print("access token", authToken)
                    }
                }
              
                
            }.buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    MainView()
}
