//
//  HTWContainerModifier.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 12.12.24.
//

import Foundation
import SwiftUI

/**
 Drop Down Modifiers
 */
struct  DropDownMenu: View {

let options: [String]

var menuWdith: CGFloat  =  300
var buttonHeight: CGFloat  =  60
var maxItemDisplayed: Int  =  3

@Binding  var selectedOptionIndex: Int
@Binding  var showDropdown: Bool

@State  private  var scrollPosition: Int?

var body: some  View {
VStack {

VStack(spacing: 0) {
// selected item
Button(action: {
withAnimation {
showDropdown.toggle()
}
}, label: {
HStack(spacing: nil) {
Text(options[selectedOptionIndex])
Spacer()
Image(systemName: "chevron.down")
.rotationEffect(.degrees((showDropdown ?  -180 : 0)))
}
})
.padding(.horizontal, 20)
.frame(width: menuWdith, height: buttonHeight, alignment: .leading)


// selection menu
if (showDropdown) {
let scrollViewHeight: CGFloat  = options.count > maxItemDisplayed ? (buttonHeight*CGFloat(maxItemDisplayed)) : (buttonHeight*CGFloat(options.count))
ScrollView {
LazyVStack(spacing: 0) {
ForEach(0..<options.count, id: \.self) { index in
Button(action: {
withAnimation {
selectedOptionIndex = index
showDropdown.toggle()
}

}, label: {
HStack {
Text(options[index])
Spacer()
if (index == selectedOptionIndex) {
Image(systemName: "checkmark.circle.fill")

}
}

})
.padding(.horizontal, 20)
.frame(width: menuWdith, height: buttonHeight, alignment: .leading)

}
}
.scrollTargetLayout()
}
.scrollPosition(id: $scrollPosition)
.scrollDisabled(options.count <=  3)
.frame(height: scrollViewHeight)
.onAppear {
scrollPosition = selectedOptionIndex
}

}

}
.foregroundStyle(Color.black)
.background(RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.systemGray6)))

}
.frame(width: menuWdith, height: buttonHeight, alignment: .top)
.zIndex(100)

}
}

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

struct HTWPressedButtonStyle: ButtonStyle {
    var isSelected: Bool // Zustand des Buttons
    var menuWdith: CGFloat  =  600
    var buttonHeight: CGFloat  =  60
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .padding()
          .background(isSelected ? Color.teal.opacity(0.6) :
            configuration.isPressed ? Color.teal : Color(UIColor.systemGray6))
          .foregroundColor(.black)
          .cornerRadius(10)
          .shadow(radius: 5)
          .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Leichtes Schrumpfen
          .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
          .frame(width: menuWdith, height: buttonHeight, alignment: .center)
  }
}

struct HTWLittleButtonStyle: ButtonStyle {
    var isSelected: Bool // Zustand des Buttons
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .padding()
          .background(isSelected ? Color.teal.opacity(0.6): configuration.isPressed ? Color.teal : Color.gray)
          .foregroundColor(.white)
          .cornerRadius(10)
          .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Leichtes Schrumpfen
          .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
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
extension ButtonStyle where Self == HTWPressedButtonStyle {
    static func htwPressed(isSelected: Bool) -> HTWPressedButtonStyle {
        HTWPressedButtonStyle(isSelected: isSelected)
    }
}
extension ButtonStyle where Self == HTWLittleButtonStyle {
    static func htwLittle(isSelected: Bool) -> HTWLittleButtonStyle {
        HTWLittleButtonStyle(isSelected: isSelected)
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
