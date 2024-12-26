//
//  RadarDiagrammView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 21.11.24.
//

import Foundation
import SwiftUI

struct RadarDiagrammPreviewView: View {
    @State private var danceability = 0.0
    @State private var energy = 0.0
    @State private var speechiness = 0.0
    @State private var acousticness = 0.0
    @State private var instrumentalness = 0.0
    @State private var liveness = 0.0
    @State private var valence = 0.0
    
    @State private var namedValuesArray: [NamedValue] = []
    
    var body: some View {
        VStack {
            SliderView(label: "Danceability", value: $danceability) { updateValues() }
            SliderView(label: "Energy", value: $energy) { updateValues() }
            SliderView(label: "Speechiness", value: $speechiness) { updateValues() }
            SliderView(label: "Acousticness", value: $acousticness) { updateValues() }
            SliderView(label: "Instrumentalness", value: $instrumentalness) { updateValues() }
            SliderView(label: "Liveness", value: $liveness) { updateValues() }
            SliderView(label: "Valence", value: $valence) { updateValues() }
        }
        .padding()
        RadarDiagrammView(namedValuesArray: namedValuesArray)
    }
    
    func updateValues() {
        namedValuesArray = [
            NamedValue(id: 1, label: "Danceability", value: danceability),
            NamedValue(id: 2, label: "Energy", value: energy),
            NamedValue(id: 3, label: "Speechiness", value: speechiness),
            NamedValue(id: 4, label: "Acousticness", value: acousticness),
            NamedValue(id: 5, label: "Instrumentalness", value: instrumentalness),
            NamedValue(id: 6, label: "Liveness", value: liveness),
            NamedValue(id: 7, label: "Valence", value: valence)
        ]
    }
}

struct SliderView: View {
    let label: String
    @Binding var value: Double
    let onEndSliding: () -> Void
    
    var body: some View {
        VStack {
            Text("\(label): \(Int(value))")
            Slider(value: $value, in: 0...100, onEditingChanged: { editing in
                if !editing {
                    onEndSliding() // Only trigger when sliding ends
                }
            })
        }
    }
}

#Preview {
    RadarDiagrammPreviewView()
}



