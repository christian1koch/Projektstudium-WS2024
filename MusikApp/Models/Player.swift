//
//  Player.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation

public struct Player: Identifiable {
    public let id: String
    public var points: Int
    
    public init(name: String, points: Int) {
        self.id = name
        self.points = points
    }
}
