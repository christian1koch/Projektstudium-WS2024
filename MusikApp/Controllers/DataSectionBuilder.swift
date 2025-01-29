//
//  DataSectionBuilder.swift
//  MusikApp
//
//  Created by david brundert on 28.01.25.
//

import Foundation

class DataSectionBuilder {
    
    func createDataSections(room: Room) -> [DataSection] {
        var dataSections: [DataSection] = []
        let headers = ["Title", "Artist", "Album", "Year"]
        let rIndex = room.currentRoundNumber! - 1 // (is -1 correct?)
        
        // correct values
        let correctValues: [String] = [room.rounds![rIndex].song.title, room.rounds![rIndex].song.artists.first!,
                                       room.rounds![rIndex].song.album, String(room.rounds![rIndex].song.releaseYear)]
        
        // guesses of players
        let guesses = room.rounds![rIndex].guesses
        var dataEntries: [DataEntry] = [] // consisting of name & solution
        
        // creation of data sections
        var index = 0
        for category in headers {
            // retrieving only the guesses of the current category
            dataEntries = []
            for guess in guesses {
                dataEntries.append(DataEntry(name: guess.playerId, value: guess.guesses[index]))
            }
            // creating a data section for each category
            var DataSection = DataSection(title: category, correctValue: correctValues[index], entries: dataEntries)
            dataSections.append(DataSection)
            index = index + 1
        }
        
        return dataSections
    }
}
