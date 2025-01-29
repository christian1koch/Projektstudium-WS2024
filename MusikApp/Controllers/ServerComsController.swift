//
//  ApiController.swift
//  MusikApp
//
//  Created by david brundert on 08.01.25.
//
import Foundation


/*
The ServerComsController is responsible for handling all communication with the server.
It provides methods to retrieve rooms, create rooms, update rooms, close rooms, start games, join rooms and submit answers.
*/
class ServerComsController {

    /*
     URL of the server.
     */
    private let baseUrl: String = "http://84.173.203.12:8888"

    /*
    Performs a GET-Request to retrieve all rooms from the server and calls the completion handler with the result.
    The completion handler will return a list of all rooms that are currently open.
    */
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

    /*
    Performs a GET-Request to retrieve a room by its id and calls the completion handler with the result.
    The completion handler will return the room with the given id.
    */
    func getRoomById(id: String, completion: @escaping (Result<Room,Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))

            } else if let data = data {
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(room))
                } catch {
                    completion(.failure(error))
                    print("Server Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
            }
        }.resume()
    }

    /*
    Updates a room by performing a PUT-Request and calls the completion handler with the result.
    The given room will overwrite the existing room with the same id.
    The completion handler will return the updated room.
    */
    func updateRoom(id: String, room: Room, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                    let updatedRoom = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(updatedRoom))
                } catch {
                    completion(.failure(error))
                    print("Server Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
            }
        }.resume()
    }

    /*
    Closes a room by performing a DELETE-Request and calls the completion handler with the result.
    The status of the room will change to CLOSED and hence the room will not be displayed in the list of rooms anymore.
    */
    func closeRoom(id: String, playerName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(id)/\(playerName)/close") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }

    /*
    Create a new room by performing a POST-Request and calls the completion handler with the result.
    The given room needs to contain at least the host player.
    The completion handler will return the created room with the id set, the status set to OPEN, and the list of players containing the host player.
    */
    func createRoom(room: RoomCreateRequest, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(room)
            request.httpBody = jsonData
            print("Request: \(String(data: jsonData, encoding: .utf8) ?? "nil")")

        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                print("Server Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                do {
                    let createdRoom = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(createdRoom))
                } catch {
                    completion(.failure(error))
                    print("Decoding error: \(error)")
                }
            } else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
            }
        }.resume()

    }
    
    /*
    Start a game by performing a POST-Request and calls the completion handler with the result.
    The completion handler will return the updated room with the status set to ACTIVE.
    */
    func startGame(roomId: String, player: String, completion: @escaping (Result<Room, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)/\(player)/start") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                // Log the raw response data to check the structure
                print("Server Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(room))
                } catch {
                    print("Decoding Error: \(error)")  // Print the decoding error for better debugging
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /*
    Join a room by performing a PUT-Request and calls the completion handler with the result.
    The completion handler will return the updated room with the new player added to the list of players.
    */
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
                if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw API Response:", jsonString) // ✅ Check if "id" is missing
                        }
                do {
                    let room = try JSONDecoder().decode(Room.self, from: data)
                    completion(.success(room))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /*	
    Takes a guess (submit answers) by performing a POST-Request and calls the completion handler with the result.
    */
    // TODO: functionality of receiving points is not yet implemented
    func submitAnswers(roomId: String, playerId: String, round: Int, guess: [String],completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)/\(playerId)/\(round)") else { return }
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(guess)
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
    
    func markPlayerReady(roomId: String, playerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/room/\(roomId)/\(playerId)/ready") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // Using POST instead of PUT
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // No need for a body, so we can skip encoding any data
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }

    
}
