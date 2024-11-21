//
//  RadarDiagrammView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 21.11.24.
//

import Foundation
import SwiftUI
import DDSpiderChart

struct NamedValue: Hashable {
    let id: Int;
    let label: String;
    let value: Int
}

struct RadarDiagrammView: View {
    var namedValuesArray: [NamedValue]
    
    var axesLabels: [String] {
        return namedValuesArray.map({$0.label})
    }
    var diagramValues: [Float] {
        return namedValuesArray.map({Float($0.value) / 100})
    }
    var body: some View {

        VStack {
            List(namedValuesArray, id: \.id) { namedValue in
                    Text("\(namedValue.label), \(namedValue.value)")
            }
            DDSpiderChart(
                axes: axesLabels,
                values: [
                    DDSpiderChartEntries(values: diagramValues, color: .green),
                ],
                fontTitle: .boldSystemFont(ofSize: 16),
                textColor: .black
            ).frame(width: 300, height: 300)
        }
        .padding()
    }
    
}

// Mock Values for Preview
private let MOCK_VALUES = [
    NamedValue(id: 1, label: "Danceability", value: 80),
    NamedValue(id: 2, label: "Energy", value: 90),
    NamedValue(id: 3, label: "Speechiness", value: 30),
    NamedValue(id: 4, label: "Acousticness", value: 40),
    NamedValue(id: 5, label: "Instrumentalness", value: 20),
    NamedValue(id: 6, label: "Liveness", value: 70),
    NamedValue(id: 7, label: "Valence", value: 60)
]

#Preview {
    RadarDiagrammView(namedValuesArray: MOCK_VALUES)
}



