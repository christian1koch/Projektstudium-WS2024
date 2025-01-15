import UIKit

let controller = ServerComsController()

Task {
    let newRoom = Room(id: nil, host: Player(name: "David"), players: nil, rounds: nil, settings: Settings(mode: .FASTEST_STOPS, maxPlayers: 5, isPublic: true), status: nil, activeRound: nil)
    
    // creation of room was sucessfully tested
    /*
    controller.createRoom(room: newRoom, completion: { result in
        switch result {
        case .success(let room):
            print(room)
            print("\n")
        case .failure(let error):
            print(error)
        }
    })
     */
    
    // get all rooms was sucessfully tested
    /*
    controller.getAllRooms(completion: { result in
        switch result {
        case .success(let rooms):
            print(rooms)
            print("\n")
        case .failure(let error):
            print(error)
        }
    })
     */
     
    
    // get room by id was sucessfully tested
    
    controller.getRoomById(id: "OV3Q", completion: { result in
        switch result {
        case .success(let room):
            print(room)
            print("\n")
            
            let updatedRoom = Room(id: room.id, host: room.host, players: room.players, rounds: room.rounds, settings: Settings(mode: .FIXED_TIME, maxPlayers: 7, isPublic: true), status: room.status, activeRound: room.activeRound)
            controller.updateRoom(id: room.id!, room: updatedRoom, completion: { result in
                switch result {
                case .success(let room):
                    print(room)
                    print("\n")
                    // TODO: maxPlayers (Settings) is not updated
                case .failure(let error):
                    print(error)
                }
            })
        case .failure(let error):
            print("here")
            print(error)
        }
    })
    
    // close room was successfully tested
    /*
    controller.closeRoom(id: "LKV6", playerName: "David",completion: { result in
        switch result {
        case .success():
            print("Room deleted.")
        case .failure(let error):
            print("Failed to delete room:")
            print(error)
        }
    })
     */
        
}
    
