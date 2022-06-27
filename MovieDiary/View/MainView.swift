//
//  MainView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataService: JSONDataService
    @StateObject var vm: MainViewModel = MainViewModel()
    
    init() {
    }
    
    var body: some View {
        ScrollView {
            if let searchResult = vm.searchResults {
                ForEach(searchResult.search, id:\.imdbID) { result in
                    HStack {
                        ImageView(photo: result)
                            .frame(maxWidth: 150)
                        VStack{
                            Text(result.title).bold()
                            Text(result.year)
                            Text(result.type.name)
                        }
                    }
                }
            } else {
                Text("You didnt search anything")
            }
        }
        .onAppear{
            vm.setup(dataService: dataService)
            dataService.getSearchResult(for: "game of thrones")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(JSONDataService.previewInstance)
    }
}
