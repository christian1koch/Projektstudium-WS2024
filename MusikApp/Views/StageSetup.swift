//
//  StageSetup.swift
//  MusikApp
//
//  Created by Alexandra Karoline Kästner on 05.01.25.
//

import Foundation
import SwiftUI


struct StageSetupContainerPreviewView: View {
    @State private var selectedPlaylist: String? = nil
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String? = nil
    @State private var navigateToLineUp = false
    @State private var isCreateStagePressed: Bool = false
    @State private var isPrivateStage: Bool? = nil
    @State private var selectedSongCount: Int? = nil
    @State private var selectedTimeLimit: Int? = nil

    let setlistoptions = ["Setlist", "Lieblingssongs", "TOP-50 Deutschland", "UK Drill Musik", "Deutschrap Brandneu"]
    @State  private  var selectedOptionIndex =  0
    @State  private  var showDropdown =  false
    var body : some View {
        VStack {
            VStack {
                DropDownMenu(options: setlistoptions, selectedOptionIndex: $selectedOptionIndex, showDropdown: $showDropdown)
            }
                .onTapGesture {
                    withAnimation {
                    showDropdown =  false}}
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
                .disabled(!validateInputs()) //Button deaktiviert wenn Felder unvollständig
                .buttonStyle(.htwPressed(isSelected: isCreateStagePressed))
                .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Fehler"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))}
                
                /**
                 Navigation zu LineUp Screen, wenn vorhanden
                //NavigationLink(
                //destination: LineUpView(),
                //isActive: $navigateToLineUp)*/
                EmptyView()
            }.padding()
        }
}
                             
    // Funktion zum Abrufen der Playlists von der API
       func fetchPlaylists() {
           // Simulierte Server-Abfrage (später mit ServerComsController verbinden)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               setlistoptions // Beispiel-Daten
           }
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



#Preview {
    StageSetupContainerPreviewView()
}

