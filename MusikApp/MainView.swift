//
//  ContentView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 04.11.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        
        VStack {
           Text("Welcome to Music App")
           StageSetupView()
        }
        .padding()
    }
}

#Preview {
    MainView()
}
