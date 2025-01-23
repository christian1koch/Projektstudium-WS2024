//
//  DataSectionView.swift
//  bla
//
//  Created by Dennis Forster on 23.01.25.
//

import Foundation
import SwiftUI
import StringMetric

import SwiftUI

struct DataSectionView: View {
    @ObservedObject var viewModel: DataSectionViewModel
    @Binding var players: [Player]
    @State private var navigateToGameOver = false
    @State private var dataLoaded = false

    // if correct value contains characters other than numbers, 20% mistake rate is still acceptable
    private var onlyNumbers: CharacterSet

    var acceptableMistakes: Int {
        if viewModel.correctValue.rangeOfCharacter(from: onlyNumbers) != nil {
            return Int(ceil(Double(viewModel.correctValue.count) * 0.2))
        }
        return 0
    }

    init(viewModel: DataSectionViewModel, players: Binding<[Player]>) {
        self.viewModel = viewModel
        self._players = players
        
        self.onlyNumbers = CharacterSet(charactersIn: viewModel.correctValue).inverted
    }

    func increaseScore(forName name: String) {
        if let index = players.firstIndex(where: { $0.id == name }) {
            players[index].points += 1
        } else {
            print("Player with name \(name) not found.")
        }
    }

    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.headline)
                .padding()
            
            HStack {
                Text("Name")
                Spacer()
                Text(viewModel.correctValue)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            ForEach(viewModel.entries, id: \.name) { entry in
                let distance = entry.value.distanceLevenshtein(between: viewModel.correctValue)
            
                HStack(spacing: 0) {
                    Text(entry.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(distance <= acceptableMistakes ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true) // Ensures the text can grow vertically
                    Text(entry.value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(distance <= acceptableMistakes ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
        .task {
            if !dataLoaded {
                updateScores()
                dataLoaded = true
            }
        }
    }

    private func updateScores() {
        for entry in viewModel.entries {
            let distance = entry.value.distanceLevenshtein(between: viewModel.correctValue)
            if distance <= acceptableMistakes {
                increaseScore(forName: entry.name)
            }
        }
    }
}
