//
//  PrivateJoinView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI


private var stagesMock = [
    Stage(id: "ABCD"),
    Stage(id: "APTR"),
    Stage(id: "REJD"),
    Stage(id: "SDMQ"),
    Stage(id: "KDLW"),
]

struct PrivateJoinView: View {
    let stages: [Stage]
    @State private var stageId: String = "";
    
    var body: some View {
        NavigationStack() {
            Form {
                TextField("Stage Id", text: $stageId).autocorrectionDisabled()
            }.navigationTitle("Join Stage").toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Stage") {
                        print("joining \(stageId)...")
                    }.disabled(stageId.isEmpty)
                }
            }
        }
    }
}

#Preview {
    PrivateJoinView(stages: stagesMock)
}

