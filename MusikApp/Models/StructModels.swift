//
//  StructModels.swift
//  MusikApp
//
//  Created by david brundert on 15.01.25.
//

/**
    Represents a guess in the game.
    
    A `Guess` has a player id and a list of guesses.
    */
struct Guess: Codable {
    let playerId : String
    let guesses : [String]
}

/**
    Represents a round in the game.
    
    A `Round` has a list of guesses, a song data to be guessed, an index, and the remaining time.
    */
struct Round: Codable {
    var guesses : [Guess]
    let song : SongData
    let index: Int
    var remainingTime: Int
    //#TODO add remaning time
}

/**
    Represents a song in the game.
    
    A `SongData` has a title, album, id, artists, and release year.
    */
struct SongData: Codable {
    let title : String
    let album : String
    let id: String
    let artists : [String]
    let releaseYear : Int
}

/**
    Represents a player in the game.

    A `Player` has a name, score, and a ready state.
    */
struct Player: Codable, Hashable {
    var name: String?
    var points: Int = 0
    var ready: Bool = false
}

/**
    Represents a room in the game.
    
    A `Room` has an id, host, players, rounds, current round number, settings, and status.
    */
enum Status: String, Codable {
    case open = "OPEN"
    case active = "ACTIVE"
    case closed = "CLOSED"
}

/**
    Represents a room in the game.
    
    A `Room` has an id, host, players, rounds, current round number, settings, and status.
    */
struct Room: Codable {
    var id: String?
    var host: Player
    var players: [Player]?
    var rounds: [Round]?
    var currentRoundNumber: Int?
    var settings: Settings
    var status: Status?
}

/**
    Represents room creation request.
    
    A `RoomCreateRequest` has a host and settings.
    */
struct RoomCreateRequest: Codable {
    var host: Player
    var settings: Settings
}

/**
    Represents the game mode.
    
    A `Mode` can be FASTEST_STOPS or FIXED_TIME.
    */
enum Mode: String, Codable, CaseIterable {
    case FASTEST_STOPS = "FASTEST_STOPS"
    case FIXED_TIME = "FIXED_TIME"
}

/**
    Represents the game settings.
    
    A `Settings` has a mode, max players, rounds, max round time, and a public state.
    */
struct Settings: Codable {
    let mode: Mode
    let maxPlayers : Int
    let rounds: Int // in [3, 20]
    let maxRoundTime: Int
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
                case mode
                case maxPlayers
                case rounds
                case maxRoundTime
                case isPublic = "public"
        }
}
