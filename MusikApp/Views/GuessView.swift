//
//  GuessView.swift
//  MusikApp
//
//  Created by Christian Trefzer on 01.01.25.
//

import SwiftUI

struct GuessView: View {
    @State private var year: Double = 1983
    @State private var titleText: String = ""
    @State private var artistText: String = ""
    @State private var albumText: String = ""
    @State private var isMuted: Bool = false  // TODO: add logic
    
    // TODO: remove when perform btn logic is implemented
    @Environment(\.dismiss) var dismiss // To go back to the previous view

    var body: some View {
        // Current year to get maximum for guess year slider
        let currentYear = Double(Calendar.current.component(.year, from: Date()))
        
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

            // Submit and evaluate results
            Button("Perform") {
                // TODO: Add logic
                dismiss()
            }
            .buttonStyle(.htwPrimary)
        }
        .padding()
        .htwContainerStyle()
    }
}

#Preview {
    GuessView()
}
