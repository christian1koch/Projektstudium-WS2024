//
//  StageSetup.swift
//  MusikApp
//
//  Created by Alexandra Karoline Kästner on 05.01.25.
//

import Foundation
import SwiftUI


struct StageSetupView: View {
    let setlist = ["Setlist", "Lieblingssongs", "TOP-50 Deutschland", "UK Drill Musik", "Deutschrap Brandneu"]
    @State private var spotifyAuthController = SpotifyClientAuthController()
    @State private var playlists: [Playlist] = []
    @State private var selectedPlaylist: Playlist? = nil
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil
    @State private var navigateToLineUp = false
    @State private var isCreateStagePressed: Bool = false
    @State private var isPrivateStage: Bool? = nil
    @State private var selectedSongCount: Int? = nil
    @State private var selectedTimeLimit: Int? = nil
    
    
    @State  private  var selectedOptionIndex =  0
    @State  private  var showDropdown =  false
    
    var body : some View {
            VStack {
                VStack {
                    DropDownMenu(
                        options: playlists.map { $0.name }, // Dropdown-Optionen
                        selectedOptionIndex: Binding(
                            get: {
                                guard !playlists.isEmpty else { return 0 } // Sicherstellen, dass playlists nicht leer ist
                                return playlists.firstIndex(where: { $0.id == selectedPlaylist?.id }) ?? 0
                            },
                            set: { index in
                                guard index < playlists.count else { return } // Index prüfen, um Fehler zu vermeiden
                                selectedPlaylist = playlists[index]
                            }
                        ),
                        showDropdown: $showDropdown
                    )
                }
                .onTapGesture {
                    withAnimation {
                        showDropdown.toggle()}}
            }.zIndex(100)
            
            
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
                    Text("Zeitlimit").htwTitleStyle()
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
                HStack {
                    Button("Private Stage") { isPrivateStage = true
                        
                    }.buttonStyle(.htwPressed(isSelected: isPrivateStage == true))
                    
                    
                    
                }.padding()
            }
            VStack {
                HStack {
                    Button("Public Stage") { isPrivateStage = false
                    }.buttonStyle(.htwPressed(isSelected: isPrivateStage == false))
                    
                    
                    
                }.padding()
            }
            
            VStack {
                HStack {
                    Button("Create Stage") {
                        guard validateInputs() else {
                            showErrorAlert = true
                            errorMessage = "Bitte fülle alle Felder aus, bevor du vortfährst."
                            return
                        }
                        createRoomAndNavigate()
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Fehler"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))}
                    .disabled(!validateInputs()) //Button deaktiviert wenn Felder unvollständig
                    .buttonStyle(.htwPressed(isSelected: isCreateStagePressed))
                    
                    
                    /**
                     Navigation zu LineUp Screen, wenn vorhanden
                     //NavigationLink(
                     //destination: LineUpView(),
                     //isActive: $navigateToLineUp)*/
                    EmptyView()
                }.padding()
            }
        }
    
    /**Funktion zum Abrufen der Playlists von der API
     private func fetchPlaylists() {
     isLoading = true
     spotifyController.fetchUserPlaylists { result in
     DispatchQueue.main.async {
     isLoading = false
     switch result {
     case .success(let fetchedPlaylists):
     playlists = fetchedPlaylists // Muss [Playlist] sein
     case .failure(let error):
     showErrorAlert = true
     errorMessage = "Fehler beim Laden der Playlists: \(error.localizedDescription)"
     }
     }
     }
     }*/
    
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
            isPublic: isPrivateStage == false)
        
        /**
         let room = Room(
         id: nil,
         host: Player(name: nil, points: 0, ready: false),
         players: nil,
         rounds: nil,
         settings: settings,
         status: open,
         activeRound: nil
         )
         
         let serverComsController = ServerComsController()
         serverComsController.createRoom(room: room) { result in
         DispatchQueue.main.async {
         isLoading = false
         switch result {
         case .success:
         navigateToLineUp = true
         case .failure(let error):
         showErrorAlert = true
         errorMessage = "Fehler beim Erstellen des Raums: \(error.localizedDescription)"
         }
         }
         }*/
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

