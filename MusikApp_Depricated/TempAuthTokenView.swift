//
//  TempAuthTokenView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 13.11.24.
//

import Foundation
import SwiftUI

struct TempAuthTokenView: View {
    @State var authTokenText = "";
    var body: some View {
        
        VStack {
            Text(authTokenText)
            Button("Test get Spotify Token") {
                authTokenText = "requesting..."
                Task {
                    do {
                        let clientAuthController = SpotifyClientAuthController()
                        let authToken = try await clientAuthController.requestAccessToken()
                        authTokenText = authToken
                    }
                }
                
            }.buttonStyle(.bordered)
        }
        .padding()
    }
}
