import UIKit

let controller = ServerComsController()

Task {
    controller.joinRoom(roomId: "8T5J", player: Player(name: "something",points: 0,ready: false)) { result in
        DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Successfully joined room")

                    case .failure(let error):
                        print("Error joining room: \(error)")
                    }
                }
    }
}
