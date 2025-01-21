//
//  SpotifyRemoteSwiftUIApp.swift
//  SpotifyRemoteSwiftUI
//
//  Created by Geoffrey Matrangola on 2/4/23.
//

import SwiftUI

struct SpotifyControllerView: View {
    @StateObject var spotifyController = SpotifyController()
    var body: some View {
        SpotifyTestView()
            .environmentObject(spotifyController)
    }    }

