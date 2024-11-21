let controller = SpotifyClientAuthController()
let apiController = SpotifyApiController()

Task {
    let token = try await controller.requestAccessToken()
    //print(token)
    
    apiController.setToken(token: token)
    //apiController.apiCallTest()
    apiController.searchForTrackId(name: "Alles neu", artist: "Peter fox")
}


