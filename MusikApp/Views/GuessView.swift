//
//  GuessView.swift
//  MusikApp
//
//  Created by Christian Trefzer on 01.01.25.
//

import SwiftUI

struct GuessView: View {
    @State private var year: Double = 0
    @State private var titleText: String = ""
    @State private var artistText: String = ""
    @State private var albumText: String = ""
    @State private var isMuted: Bool = false  // TODO: add logic
    @State private var navigateToEvaluation = false     // State to trigger navigation to Evaluation
    
    // game controller
    private var gameController: GameController = GameController.shared
    
    var body: some View {
        // Current year to get maximum for guess year slider
        let currentYear = Double(Calendar.current.component(.year, from: Date()))
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    
                    // Guess counter
                    Text("13")
                        .htwContainerStyle()
                        .frame(width: 50, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    // Song is playing
                    Image(systemName: "music.note")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .htwContainerStyle()
                    
                    Spacer()
                    
                    // Mute Button
                    Button(action: {
                        isMuted.toggle()
                    }) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .htwContainerStyle()
                            .foregroundColor(isMuted ? .red : .primary)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                // User input cards
                VStack(spacing: 16) {
                    // Song title input card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title").htwTitleStyle()
                        TextField("Freitext...", text: $titleText)
                            .padding()
                            .htwContainerStyle()
                    }
                    
                    // Artist input card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Artist").htwTitleStyle()
                        TextField("Freitext...", text: $artistText)
                            .padding()
                            .htwContainerStyle()
                    }
                    
                    // Album input card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Album").htwTitleStyle()
                        TextField("Freitext...", text: $albumText)
                            .padding()
                            .htwContainerStyle()
                    }
                    
                    // Year input card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Year").htwTitleStyle()
                        HStack {
                            Slider(value: $year, in: 1950...currentYear, step: 1)  //TODO: discuss limits
                            Text("\(Int(year))")
                                .htwSimpleTextStyle()
                                .monospacedDigit()  // Removes seperator
                        }
                    }
                }
                .padding()
                
                // Submit guess and evaluate results
                Button("Perform") {
                    if isComplete(), let activeRoom = gameController.activeRoom {
                        let roomId = activeRoom.id
                        let playerId = "playerName"     //TODO: get player id - wo bitte steht die???
                        let round = activeRoom.activeRound ?? 0
                        // let guess = Guess(playerId: "", guesses: [titleText, artistText, albumText, String(year)])   // Guess struct
                        let guess = [titleText, artistText, albumText, String(year)]                                    // Guess Array
                        
                        // submit guess
                        gameController.serverComsController.submitAnswers(roomId: roomId, playerId: playerId, round: round, guess: guess, completion: { result in
                            switch result {
                            case .success(let response):
                                print("Response: \(response)")
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        })
                        
                        // evaluate guess
                        
                        // create dataSection
                        
                        // navigate to next view
                        navigateToEvaluation = true  // Trigger navigation
                        
                    } else {
                        print("Please fill out all fields")
                    }
                }
                .buttonStyle(.htwPrimary)
            }
            .padding()
            .htwContainerStyle()
            .navigationDestination(isPresented: $navigateToEvaluation) {
                EvaluationView(tabs: mockDataSections())
            }
        }
    }
    
    // checks if all answer were given, ture = all answers are given
    func isComplete() -> Bool {
        return !titleText.isEmpty && !artistText.isEmpty && !albumText.isEmpty && year != 0
    }
    
    // Mock data for EvaluationView TODO: REMOVE
    func mockDataSections() -> [DataSection] {
        return [
            DataSection(
                title: "Title",
                correctValue: "Thriller",
                entries: [
                    DataEntry(name: "Player 1", value: "Thriller"),
                    DataEntry(name: "Player 2", value: "Billie Jean"),
                    DataEntry(name: "Player 3", value: "Beat It")
                ]
            ),
            DataSection(
                title: "Artist",
                correctValue: "Michael Jackson",
                entries: [
                    DataEntry(name: "Player 1", value: "Michael Jackson"),
                    DataEntry(name: "Player 2", value: "Prince"),
                    DataEntry(name: "Player 3", value: "Madonna")
                ]
            ),
            DataSection(
                title: "Album",
                correctValue: "Thriller",
                entries: [
                    DataEntry(name: "Player 1", value: "Thriller"),
                    DataEntry(name: "Player 2", value: "Bad"),
                    DataEntry(name: "Player 3", value: "Dangerous")
                ]
            ),
            DataSection(
                title: "Year",
                correctValue: "1982",
                entries: [
                    DataEntry(name: "Player 1", value: "1982"),
                    DataEntry(name: "Player 2", value: "1982"),
                    DataEntry(name: "Player 3", value: "1984")
                ]
            )
        ]
    }

}
        
#Preview {
    GuessView()
}

