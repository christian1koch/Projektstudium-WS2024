//
//  StructModels.swift
//  MusikApp
//
//  Created by david brundert on 15.01.25.
//

struct Guess: Codable {
    let playerId : String
    let guesses : [String]
}

struct Round: Codable {
    let guesses : [Guess]
    let song : SongData
}

struct SongData: Codable {
    let title : String
    let album : String
    let id: String
    let artists : [String]
    let releaseYear : Int
}

struct Player: Codable, Hashable {
    var name: String?
    var points: Int = 0
    var ready: Bool = false
}

enum Status: String, Codable {
    case open = "OPEN"
    case active = "ACTIVE"
    case closed = "CLOSED"
}

struct Room: Codable {
    var id: String?
    var host: Player
    var players: [Player]?
    var rounds: [Round]?
    var settings: Settings
    var status: Status?
    var activeRound: Int?
}

enum Mode: String, Codable {
    case FASTEST_STOPS = "FASTEST_STOPS"
    case FIXED_TIME = "FIXED_TIME"
}

struct Settings: Codable {
    let mode: Mode
    let maxPlayers : Int
    let isPublic: Bool
    // ... additional settings
    
    enum CodingKeys: String, CodingKey {
                case mode
                case maxPlayers
                case isPublic = "public"
        }
}
