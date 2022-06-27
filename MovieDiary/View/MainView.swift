//
//  MainView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct MainView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var dataService: JSONDataService
    @StateObject var vm: MainViewModel = MainViewModel()
    
    @State var searchText = ""
    @State var searching = false
    
    init() {
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { reader in
                ScrollView {
                    let oneColumns = [GridItem(.flexible(maximum: .infinity))]
                    /*let twoColumns = [GridItem(.flexible(maximum: .infinity)),
                     GridItem(.flexible(maximum: .infinity))]*/
                    
                    LazyVGrid(columns: oneColumns,
                              alignment: .leading,
                              spacing: 0, pinnedViews: .sectionHeaders) {
                        Section(header: GridHeader) {
                            if let searchResult = vm.searchResults {
                                
                                ForEach(searchResult.search, id:\.imdbID) { result in
                                    MovieCell(result)
                                }
                                
                            } else {
                                Text("You didnt search anything")
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .navigationBarHidden(true)
            .onAppear{
                vm.setup(dataService: dataService)
                dataService.getSearchResult(for: "game of thrones")
            }
            .gesture(DragGesture()
                .onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
            )
        }
    }
}

extension MainView {
    private var GridHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Search Movie")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                
                if searching {
                    Button("Cancel") {
                        searchText = ""
                        withAnimation {
                            searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                } else {
                    Button("Help") {
                        print("Help tapped!")
                    }
                }
                
            }
            .padding(.top, safeAreaInsets.top)
            .background(Rectangle().fill(Color(UIColor.systemBackground)))
            
            SearchBar(searchText: $searchText, searching: $searching)
        }
        .padding(.horizontal)
        
    }
    
    
    private func MovieCell(_ movie: Search) -> some View {
        HStack(alignment: .top){
            ImageView(photo: movie)
                .frame(maxWidth: 120)
            VStack(alignment: .leading ){
                Text(movie.title)
                    .bold()
                    .font(.title3)
                
                LabelCapsule(text: movie.type.name)
                LabelCapsule(text: movie.year)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding([.horizontal, .top])
    }
    
    private func LabelCapsule(text: String) -> some View {
        Text(text)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.tertiarySystemFill))
            )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView().preferredColorScheme(.dark)
        }
        .environmentObject(JSONDataService.previewInstance)
    }
}
