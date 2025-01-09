//
//  ApiController.swift
//  MusikApp
//
//  Created by david brundert on 08.01.25.
//

import Foundation


struct Guess: Codable {
    let player : String
    let guesses : [String]
}

struct Round {
    guesses : [Guess]
    song : SongData
}

struct Player: Codable {
    let name: String
    // Additional fields as needed
}

struct Room: Codable {
    let id: String?
    let host: Player?
    players : [String]
    rounds : [Round]
}

class ServerComsController {

    private let baseUrl: String = "" // TODO: Add the base URL of the server

    /*
    Methods we need:
    - get all rooms
    - join room
    - create room
    - guess 

    */

    // Create a new room
    func createRoom(room: Room, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(room)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let createdRoom = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(createdRoom))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // Get all rooms
    func getAllRooms(completion: @escaping (Result<[Room], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let rooms = try JSONDecoder().decode([Room].self, from: data)
                    completion(.success(rooms))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // Join a room
    func joinRoom(roomId: String, player: Player, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(player)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(room))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // Take a guess (Submit answers)
    func takeAGuess(roomId: String, playerId: String, guesses: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)/\(playerId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(guesses)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    // Start a game
    func startGame(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)/start") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(room))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

}