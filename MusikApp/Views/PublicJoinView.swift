//
//  JoinStageView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI

struct Stage: Identifiable, Hashable {
    let id: String
}


private var stagesMock = [
    Stage(id: "ABCD"),
    Stage(id: "APTR"),
    Stage(id: "REJD"),
    Stage(id: "SDMQ"),
    Stage(id: "KDLW"),
]

struct PublicJoinView: View {
    let stages: [Stage]
    @State private var selectedStage: String?;
    
    var body: some View {
        NavigationStack() {
            List(stages, selection: $selectedStage) {
                Text($0.id)
            }.navigationTitle("Stages (public)").toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Stage") {
                        print("joining \(selectedStage ?? "NO_SELECTED_STAGE")...")
                    }.disabled(selectedStage == nil)
                }
            }
        }
    }
}

#Preview {
    PublicJoinView(stages: stagesMock)
}

