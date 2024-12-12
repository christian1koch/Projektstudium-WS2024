//
//  HTWContainerModifier.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 12.12.24.
//

import Foundation
import SwiftUI

/**
 View Modifiers
 */
struct HTWContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(UIColor.systemGray6))
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .cornerRadius(16)
    }
}

extension View {
    func htwContainerStyle() -> some View {
        self.modifier(HTWContainerModifier())
    }
   
}

/**
 Text Modifiers
 */

struct HTWTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.black)
    }
}
struct HTWSimpleTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
    }
}
struct HTWMutedTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundStyle(.gray)
    }
}

extension Text {
    func htwTitleStyle() -> some View {
        self.modifier(HTWTitleModifier())
    }
    func htwSimpleTextStyle() -> some View {
        self.modifier(HTWSimpleTextModifier())
    }
    func htwMutedTextStyle() -> some View {
        self.modifier(HTWMutedTextModifier())
    }
}

/**
 Button Modifiers
 */

struct HTWPrimaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .padding()
          .background(Color.green)
          .foregroundColor(.white)
          .cornerRadius(10)
          .shadow(radius: 5)
  }
}
struct HTWSecondaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .padding()
          .background(Color.gray)
          .foregroundColor(.white)
          .cornerRadius(10)
          .shadow(radius: 5)
  }
}
struct HTWDestructiveButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .padding()
          .background(Color.red)
          .foregroundColor(.white)
          .cornerRadius(10)
          .shadow(radius: 5)
  }
}

extension ButtonStyle where Self == HTWPrimaryButtonStyle {
    static var htwPrimary: HTWPrimaryButtonStyle {
        HTWPrimaryButtonStyle()
    }
}
extension ButtonStyle where Self == HTWSecondaryButtonStyle {
    static var htwSecondary: HTWSecondaryButtonStyle {
        HTWSecondaryButtonStyle()
    }
}
extension ButtonStyle where Self == HTWDestructiveButtonStyle {
    static var htwDestructive: HTWDestructiveButtonStyle {
        HTWDestructiveButtonStyle()
    }
}

struct HTWContainerPreviewView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Raum ID").htwTitleStyle()
                Text("Subtitle Text...").htwSimpleTextStyle()
                Text("Muted Text...").htwMutedTextStyle()
            }
            .padding()
            HStack {
                Button("Create") {
                    
                }.buttonStyle(.htwPrimary)
                
                Button("Cancel") {
                    
                }.buttonStyle(.htwSecondary)
                Button("Delete") {
                    
                }.buttonStyle(.htwDestructive)
                
            }.padding()
        }.htwContainerStyle()
    }
}

#Preview {
    HTWContainerPreviewView()
}
