//
//  BackButton.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var color: Color
    
    init(color: Color,action: @escaping () -> Void) {
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack{
                Image(systemName: "chevron.left")
                    .font(.headline)
                
                Text("Back")
                
            }
            .padding(12)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(16)
            .padding()
            .scaleEffect(0.8)
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(color: .red) {
            print("hello")
        }
    }
}
