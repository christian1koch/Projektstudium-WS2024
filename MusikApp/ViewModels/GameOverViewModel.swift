//
//  GameOverViewModel.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation

class GameOverViewModel: ObservableObject {
    @Published var players: [Player]
    
    init(players: [Player]) {
        self.players = players
    }
}
