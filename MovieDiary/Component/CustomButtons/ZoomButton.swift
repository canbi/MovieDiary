//
//  ZoomButton.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct ZoomButton: View {
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus.magnifyingglass")
                .font(.headline)
                .padding(8)
                .foregroundColor(.primary)
                .background(RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.secondarySystemBackground)))
                .padding([.trailing, .bottom], 8)
        }
    }
}

struct ZoomButton_Previews: PreviewProvider {
    static var previews: some View {
        ZoomButton {
            print("Hello")
        }
    }
}
