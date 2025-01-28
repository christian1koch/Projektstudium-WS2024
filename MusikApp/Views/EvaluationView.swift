//
//  EvaluationView.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation
import SwiftUI

struct EvaluationView: View {
    let tabs: [DataSection]
    @State var players: [Player]
    @State private var navigateToGameOver = false
    @State private var viewedTabs: Set<Int> = []
    @State private var selectedTabIndex = 0
    @State private var gameController = GameController.shared
    
    init(tabs: [DataSection]) {
        self.tabs = tabs
        if let firstTab = tabs.first {
            self.players = firstTab.entries.map { Player(name: $0.name, points: 0) }
        } else {
            self.players = []
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ergebnis")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                TabView(selection: $selectedTabIndex) {
                    ForEach(tabs.indices, id: \.self) { index in
                        let tab = tabs[index]
                        DataSectionView(
                            viewModel: DataSectionViewModel(
                                section: DataSection(
                                    title: tab.title,
                                    correctValue: tab.correctValue,
                                    entries: tab.entries
                                )
                            ),
                            players: $players
                        )
                        .tabItem {
                            Text(tab.title)
                        }
                        .onAppear {
                            viewedTabs.insert(index)
                        }
                        .tag(index)
                    }
                }
                
                Spacer()
                
                //#TODO: differ next round/ endround
                // #TODO mark player as ready, navigate to next screen when all players are ready
                // green/ready by default, when clicked grey/waiting
                // continue when all players are ready
                Button(action: {
                    //if gameController.P
                    navigateToGameOver = true
                }) {
                    Text("Continue")
                }
                .buttonStyle(.htwPrimary)
                .padding()
                .navigationDestination(isPresented: $navigateToGameOver) {
                                    GameOverView(viewModel: GameOverViewModel(players: players))
                                }
            }
            .navigationTitle("Evaluation")
            .navigationBarHidden(true)
        }
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        
        let tab1 = DataSection(
            title: "Section 1",
            correctValue: "0",
            entries: [
                DataEntry(name: "0", value: "0"),
                DataEntry(name: "Bob", value: "0"),
                DataEntry(name: "Charliiee", value: "1")
            ]
        )
        
        let tab2 = DataSection(
            title: "Section 2",
            correctValue: "1",
            entries: [
                DataEntry(name: "0", value: "0"),
                DataEntry(name: "Bob", value: "0"),
                DataEntry(name: "Charliiee", value: "1")
            ]
        )
        
        EvaluationView(tabs: [tab1, tab2])
            .previewDevice("iPhone 13 Pro")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

