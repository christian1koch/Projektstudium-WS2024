import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let controller = ServerComsController()

Task {
    
    
    controller.getAllRooms(completion: { result in
        switch result {
        case .success(let rooms):
            print(rooms)
        case .failure(let error):
            print(error)
        }
    })}
    
