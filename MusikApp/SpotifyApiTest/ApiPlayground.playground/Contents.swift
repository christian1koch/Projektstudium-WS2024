let controller = SpotifyClientAuthController()

Task {
    let token = try await controller.requestAccessToken()
    //print(token)
    
    apiCall(token: token)
}


