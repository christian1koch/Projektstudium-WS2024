//
//  StageSetup.swift
//  MusikApp
//
//  Created by Alexandra Karoline Kästner on 05.01.25.
//

import Foundation
import SwiftUI


struct StageSetupContainerPreviewView: View {
    let setlist = ["Setlist", "Lieblingssongs", "TOP-50 Deutschland", "UK Drill Musik", "Deutschrap Brandneu"]
    @State  private  var selectedOptionIndex =  0
    @State  private  var showDropdown =  false
    var body : some View {
        VStack {
            VStack {
                DropDownMenu(options: setlist, selectedOptionIndex: $selectedOptionIndex, showDropdown: $showDropdown)
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
                Button("05") {
                    
                }.buttonStyle(.htwSecondary)
                
                Button("09") {
                    
                }.buttonStyle(.htwSecondary)
                Button("13") {
                    
                }.buttonStyle(.htwSecondary)
                
                Button("21"){
                    
                }.buttonStyle(.htwSecondary)
                
            }.padding()
        }.htwContainerStyle()
        
        VStack {
            VStack {
                Text("Zeitlimit").htwTitleStyle()
            }
            .padding()
            HStack {
                Button("10") {
                    
                }.buttonStyle(.htwSecondary)
                
                Button("30") {
                    
                }.buttonStyle(.htwSecondary)
                Button("60") {
                    
                }.buttonStyle(.htwSecondary)
                
                Button("90"){
                    
                }.buttonStyle(.htwSecondary)
                
            }.padding()
        }.htwContainerStyle()
        
        
        VStack {
            HStack {
                Button("private stage") {
                    
                }.buttonStyle(.htwLong)
                

                
            }.padding()
        }
        VStack {
            HStack {
                Button("public stage") {
                    
                }.buttonStyle(.htwLong)
                

                
            }.padding()
        }
        
    }
    
}

#Preview {
    StageSetupContainerPreviewView()
}

