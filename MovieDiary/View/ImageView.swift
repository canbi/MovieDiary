//
//  ImageView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct ImageView: View {
    @StateObject var vm: ImageViewModel
    
    init(photo: Search) {
        self._vm = StateObject(wrappedValue: ImageViewModel(photo: photo))
    }
    
    var body: some View {
        Group {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height:200, alignment: .center)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .previewData)
    }
}
