let controller = SpotifyClientAuthController()
let apiController = SpotifyApiController()

Task {
    let token = try await controller.requestAccessToken()
    print(token)
    apiController.setToken(token: token)
    
    // testing audio features api call on its own:
    print("Fetching audio features:")
    apiController.fetchParametersOfTrack(trackId: "5hqxBvQJ3XJDSbxT9vyyqA")
    
    
    apiController.searchForTrackId(name: "Alles neu", artist: "Peter fox"){ trackId in
        if let trackId = trackId {
            //print("Fetching audio features:")
            //apiController.fetchParametersOfTrack(trackId: trackId)
        } else {
            print("No trackId found.")
        }
    }
}


