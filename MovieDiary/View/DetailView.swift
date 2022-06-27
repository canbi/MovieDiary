//
//  DetailView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var settingManager: SettingManager
    @EnvironmentObject var dataService: JSONDataService
    @StateObject var vm: DetailViewModel
    
    init(_ movie: Search){
        self._vm = StateObject(wrappedValue: DetailViewModel(movie: movie))
    }
    
    var body: some View {
        ImageView(photo: vm.movie)
            .onAppear{
                vm.setup(dataService: dataService)
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(Search.previewData)
    }
}
