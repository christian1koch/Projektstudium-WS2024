//
//  GameController.swift
//  MusikApp
//
//  Created by david brundert on 15.01.25.
//
import Foundation

/*
 Class to controll the main game logic and transitions between game states.
 */
class GameController {
    
    /*
     The server communication controller to handle all communication with the server.
     */
    let serverComsController = ServerComsController()
    
    /*
     A list of all rooms that the user can join. Will be kept up to date while the user is not in a room.
     */
    var joinableRooms: [Room] = []
    
    /*
     The frequency with which the room discovery is performed in seconds.
     */
    let roomDiscoveryFrequency = 0.2
    
    /*
     The frequency with which the active room is refreshed in seconds
     */
    let activeRoomRefreshFrequency = 0.2
    
    /*
     The room that the user is currently in. Will be nil if the user is not in a room.
     Contains all relevant information about the current game state and will be kept up to date while the user is playing.
     */
    var activeRoom: Room?
    
    /*
     True when the player is currently playing and in an active room.
     */
    var gameRunning: Bool = false
    
    /*
     The player that is currently playing the game.
     */
    var player: Player = Player(name: nil, points: 0, ready: false)
    
    /*
     Requests all rooms from the server continuously while not in a room and updates the joinableRooms list
     */
    func runRoomDiscovery() {
        while !gameRunning {
            Timer.scheduledTimer(withTimeInterval: self.roomDiscoveryFrequency, repeats: true) { timer in
                self.serverComsController.getAllRooms(completion: { result in
                    switch result {
                    case .success(let rooms):
                        self.joinableRooms = rooms
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }
    }
    
    /*
     Updates the active room continuously while playing by requesting the room from the server.
     */
    func startRoomRefreshLoop(id: String) {
        while gameRunning {
            Timer.scheduledTimer(withTimeInterval: self.activeRoomRefreshFrequency, repeats: true) { timer in
                self.serverComsController.getRoomById(id: id, completion: { result in
                    switch result {
                    case .success(let room):
                        self.activeRoom = room
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }
    }
}
