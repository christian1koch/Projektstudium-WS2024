//
//  StageSetup.swift
//  MusikApp
//
//  Created by Alexandra Karoline Kästner on 05.01.25.
//

import Foundation
import SwiftUI

let setlist = ["TOP-50 Deutschland", "UK Drill Musik", "Deutschrap Brandneu"]

struct StageSetupView: View {
    @State private var spotifyAuthController = SpotifyClientAuthController()
    @State private var selectedPlaylist: String = setlist[0]
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil
    @State private var navigateToLineUp = false
    @State private var isCreateStagePressed: Bool = false
    @State private var isPrivateStage: Bool? = nil
    @State private var selectedSongCount: Int? = nil
    @State private var selectedTimeLimit: Int? = nil
    
    
    //@State private var selectedOptionIndex =  0
    @State private var selectedMode: Mode = Mode.allCases.first ?? .FIXED_TIME
    @State private var showDropdown =  false
    @State private var roomId: String? = "FB1S" //nil // #TODO: set to nill //Holds the room ID for navigation
    
    @State private var gameController = GameController.shared
    @State private var serverComsController = ServerComsController()
    
    var body : some View {
        NavigationStack {
            // select-mode card
            VStack {
                // Dropdown Menu
                VStack {
                    //                    DropDownMenu(
                    //                        options: Mode.allCases.map {$0.rawValue},
                    //                        selectedOptionIndex: Binding(
                    //                            get: {
                    //                                Mode.allCases.firstIndex(of: selectedMode) ?? 0
                    //                            },
                    //                            set: { index in
                    //                                guard index < Mode.allCases.count else { return }
                    //                                                    selectedMode = Mode.allCases[index]
                    //                            }
                    //                        ),
                    //                        showDropdown: $showDropdown
                    //                    )
                    //                }
                    //                .onTapGesture {
                    //                    withAnimation {
                    //                        showDropdown.toggle()}}
                    Picker("Mode", selection: $selectedMode) {
                        ForEach(Mode.allCases, id: \.self) { mode in
                            Text(mode.rawValue)
                        }
                    }
                }
                .zIndex(100)
                .htwContainerStyle()
            }
            VStack {
                Picker("Playlist", selection: $selectedPlaylist) {
                    ForEach(setlist, id: \.self) { playlist in
                        Text(playlist)
                    }
                }
                .htwContainerStyle()
            }
            
            // select-playlist card
            //            VStack {
            //                VStack {
            //                    DropDownMenu(
            //                        options: playlists.map { $0.name }, // Dropdown-Optionen
            //                        selectedOptionIndex: Binding(
            //                            get: {
            //                                guard !playlists.isEmpty else { return 0 } // Sicherstellen, dass playlists nicht leer ist
            //                                return playlists.firstIndex(where: { $0.id == selectedPlaylist?.id }) ?? 0
            //                            },
            //                            set: { index in
            //                                guard index < playlists.count else { return } // Index prüfen, um Fehler zu vermeiden
            //                                selectedPlaylist = playlists[index]
            //                            }
            //                        ),
            //                        showDropdown: $showDropdown
            //                    )
            //                }
            //                .onTapGesture {
            //                    withAnimation {
            //                        showDropdown.toggle()}}
            //            }.zIndex(100)
            
            
            
            // select-songcount card
            VStack {
                VStack {
                    Text("Anzahl Songs").htwTitleStyle()
                }
                .padding()
                HStack {
                    ForEach([05, 09, 13, 21], id: \.self) {
                        count in Button(action: {
                            selectedSongCount = count
                        }) {
                            Text(String(format: "%02d", count))
                        }.buttonStyle(.htwLittle(isSelected: selectedSongCount == count)) // Überprüft, ob der Button ausgewählt ist
                    }
                }.padding()
            }.htwContainerStyle()
            
            VStack {
                VStack {
                    Text("Time Limit").htwTitleStyle()
                }
                .padding()
                HStack {
                    ForEach([10, 30, 60, 90], id: \.self) {
                        limit in Button(action: {
                            selectedTimeLimit = limit
                        }) {
                            Text("\(limit)")
                        }                  .buttonStyle(.htwLittle(isSelected: selectedTimeLimit == limit)) // Überprüft, ob der Button ausgewählt ist
                    }
                }.padding()
            }.htwContainerStyle()
            VStack {
                Button("Private Stage") { isPrivateStage = true
                    
                }.buttonStyle(.htwPressed(isSelected: isPrivateStage == true))
                
                
                // public stage button
                
                Button("Public Stage") { isPrivateStage = false
                }.buttonStyle(.htwPressed(isSelected: isPrivateStage == false))
                
                
                Button("Create Stage") {
                    guard validateInputs() else {
                        showErrorAlert = true
                        errorMessage = "All params required to start the game."
                        return
                    }
                    createRoomAndNavigate()
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Fehler"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))}
                .disabled(!validateInputs()) //Button deaktiviert wenn Felder unvollständig
                .buttonStyle(.htwPrimary)
                
                
                
                // create room auf serverComsController aufrufen (async, returns room)
                // ifsuccessfull
                // id.b: setupscreen:
                //createRoom auf Servers aufrufen -> bei positivem Resultat GameController roomRefreshLoop auf raum ID starten
                // & gameController.gameRunning auf true setzen
                // (da ein Raum erfolgreich erstellt wurde und wir uns in diesem befinden)
                //Navigation zu LineUp Screen, wenn vorhanden
            }
            // private stage button
            
            
            
            
        }
        .padding()
        .navigationDestination(isPresented: $navigateToLineUp) {
            LineUpView(roomId: roomId!)}
    }
    
    
    // Validiert die Eingaben
    private func validateInputs() -> Bool {
        //Playlist fehlt
        selectedSongCount != nil &&
        selectedTimeLimit != nil &&
        isPrivateStage != nil
    }
    
    // Raum erstellen und navigieren
    private func createRoomAndNavigate() {
        isLoading = true
        
        let settings = Settings(
            mode: .FIXED_TIME,
            maxPlayers: 10,
            rounds: selectedSongCount!,
            maxRoundTime: selectedTimeLimit!,
            isPublic: isPrivateStage == false)
        
        
        let room = RoomCreateRequest(
            host: gameController.player,
            settings: settings)
        
        serverComsController.createRoom(room: room) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let createdRoom):
                    roomId = createdRoom.id
                    navigateToLineUp = true
                case .failure(let error):
                    showErrorAlert = true
                    errorMessage = "Fehler beim Erstellen des Raums: \(error)"
                }
            }
        }
    }
    
    
}



// Playlist Models
struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable, Identifiable {
    let id: String
    let name: String
    let tracks: Tracks
}

struct Tracks: Codable {
    let total: Int
}



#Preview {
    StageSetupView()
}

