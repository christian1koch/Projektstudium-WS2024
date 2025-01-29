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
    
    // MARK: - Singleton Instance
    
        static let shared = GameController()
    
        private init() {
            // prevent external initialization making it a singleton
        }

    
    // MARK: - Properties
    
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
     The timer that performs the room discovery. Will be nil if the user is in a room.
     */
    private var roomDiscoveryTimer: Timer?
    
    /*
     The frequency with which the active room is refreshed in seconds
     */
    let activeRoomRefreshFrequency = 0.2

    /*
     The timer that refreshes the active room. Will be nil if the user is not playing.
     */
    private var roomRefreshTimer: Timer?

    
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
    var player: Player = Player(name: "DEFAULT", points: 0, ready: false)

    
    // MARK: - Methods

    /*
    Requests all rooms from the server continuously while not in a room and updates the joinableRooms list.
    */
    func runRoomDiscovery() {
        // Invalidate any existing timer before starting a new one
        stopRoomDiscovery()
        
        // Start a new timer
        roomDiscoveryTimer = Timer.scheduledTimer(withTimeInterval: self.roomDiscoveryFrequency, repeats: true) { [weak self] timer in
            guard let self = self, !self.gameRunning else {
                timer.invalidate()
                return
            }
            
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
        
    /*
    Stops the room discovery process.
    */
    func stopRoomDiscovery() {
        roomDiscoveryTimer?.invalidate()
        roomDiscoveryTimer = nil
    }
    
    
    /*
     Updates the active room continuously while playing by requesting the room from the server.
     This is neccessary to obtain info about the game state (time left, answers of other players, ready state of players, etc.)
     */
    func startRoomRefreshLoop(id: String) {
        
        // Stop any existing timer before starting a new one
        stopRoomRefreshLoop()
        
        // Start a new timer
        roomRefreshTimer = Timer.scheduledTimer(withTimeInterval: self.activeRoomRefreshFrequency, repeats: true) {_ in 
            self.serverComsController.getRoomById(id: id, completion: { result in
                switch result {
                case .success(let room):
                    self.activeRoom = room
                    //print("reasigning active room")
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
        
    /*
     Stops the room refresh loop.
     */
    func stopRoomRefreshLoop() {
        roomRefreshTimer?.invalidate()
        roomRefreshTimer = nil
    }
    
    /*
     Returns true if all players in the active room are ready. Indicates if the game can start or advance to the next round.
     */
    func allPlayersReady() -> Bool {
        guard let players = activeRoom?.players else { return false }
        for player in players {
            if !player.ready {
                return false
            }
        }
        return true
    }
    
    /*
     Returns true if the active room has rounds left to play. Indicates if the game can advance to the next round or end.
     */
    func noRoundsLeftToPlay() -> Bool {
        guard let rounds = activeRoom?.rounds else { return false }
        return (activeRoom?.currentRoundNumber!)! == rounds.count
    }
    
    /*
     Returns true if all players have submitted a guess for the current round. Indicates if the round can end and the game can advance
     */
    func allPlayersAnswered() -> Bool {
        guard let rounds = activeRoom?.rounds else { return false }
        let activeRound = rounds[(activeRoom?.currentRoundNumber!)!]
        return activeRound.guesses.count >= (activeRoom?.players!.count)! // >= for the eventuality that a player leaves the game
    }
    
    /*
     Returns true if at least one player has submitted a guess for the current round. Indicates if the round can end if the mode is FASTEST_STOPS.
     */
    func atLeastOnePlayerAnswered() -> Bool {
        guard let rounds = activeRoom?.rounds else { return false }
        let activeRound = rounds[(activeRoom?.currentRoundNumber!)! - 1]
        return activeRound.guesses.count > 0
    }
    
    /*
     Returns true if the time for the current round is over. Indicates if the round can end and the game can advance.
     */
    func timeIsOver() -> Bool {
        return activeRoom?.rounds![(activeRoom?.currentRoundNumber!)!].remainingTime == 0
    }
    
    /*
     Returns true if all conditions are met to advance to the next round of the game.
     */
    func readyToAdvanceToNextRound() -> Bool {
        return allPlayersReady() && !noRoundsLeftToPlay()
    }
    
    /*
     Returns true if all conditions are met to advance to the evaluation of the current round.
     */
    func readyToAdvanceToEvaluation() -> Bool {
        
        if activeRoom?.settings.mode == .FASTEST_STOPS {
            return atLeastOnePlayerAnswered() || timeIsOver()
        } else {
            return allPlayersAnswered() || timeIsOver()
        }
        // check if current round has no time left
        //return timeIsOver() || allPlayersAnswered()
    }
}
