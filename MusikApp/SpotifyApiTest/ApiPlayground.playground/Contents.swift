let controller = SpotifyClientAuthController()
let apiController = SpotifyApiController()

Task {
    let token = try await controller.requestAccessToken()
    //print(token)
    
    apiController.apiCallTest(token: token)
}


