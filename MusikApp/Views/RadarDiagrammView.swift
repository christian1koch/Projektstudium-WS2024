//
//  RadarDiagrammView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 21.11.24.
//

import Foundation
import SwiftUI

struct NamedValue: Hashable {
    let id: Int;
    let label: String;
    let value: Int
}

let MOCK_VALUES = [
    NamedValue(id: 1, label: "Speed", value: 80),
    NamedValue(id: 2, label: "Accuracy", value: 90),
    NamedValue(id: 3, label: "Agility", value: 70)
]

struct RadarDiagrammView: View {
    let namedValuesArray: [NamedValue]
    var body: some View {
        
        VStack {

            List(namedValuesArray, id: \.id) { namedValue in
                    Text("\(namedValue.label), \(namedValue.value)")

            }
        }
        .padding()
    }
    
}

#Preview {
    RadarDiagrammView(namedValuesArray: MOCK_VALUES)
}
