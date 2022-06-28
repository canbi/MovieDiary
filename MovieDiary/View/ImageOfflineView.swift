//
//  ImageOfflineView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

struct ImageOfflineView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: ImageOfflineViewModel
    
    var currentTintColor: Color { settingManager.theme.mainColor }
    
    init(movie: CDMovie){
        self._vm = StateObject(wrappedValue: ImageOfflineViewModel(movie: movie))
    }
    
    var body: some View {
        Group {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height:200, alignment: .center)
            }
        }
    }
}

struct ImageOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        ImageOfflineView(movie: CDMovie())
    }
}
