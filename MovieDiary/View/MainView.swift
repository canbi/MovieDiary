//
//  MainView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct MainView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var settingManager: SettingManager
    @EnvironmentObject var dataService: JSONDataService
    @StateObject var vm: MainViewModel = MainViewModel()
    
    init() {
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { reader in
                ScrollView {
                    let oneColumns = [GridItem(.flexible(maximum: .infinity))]
                    let twoColumns = [GridItem(.flexible(maximum: .infinity), alignment: .topLeading),
                                      GridItem(.flexible(maximum: .infinity), alignment: .topLeading)]
                    
                    LazyVGrid(columns: settingManager.gridDesign == .oneColumn ? oneColumns : twoColumns,
                              alignment: .leading,
                              spacing: 0, pinnedViews: .sectionHeaders) {
                        Section(header: GridHeader) {
                            if let searchResult = vm.searchResults {
                                ForEach(searchResult.search, id:\.imdbID) { result in
                                    MovieCell(result)
                                }
                            } else {
                                Text("You didnt search anything")
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: $vm.selectedMovie) { movie in
                DetailView(movie)
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
            HStack(spacing: 0) {
                Text("Search Movie")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                if vm.searching {
                    Button("Cancel") {
                        vm.searchText = ""
                        withAnimation {
                            vm.searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                } else {
                    GridButton
                    SettingsButton
                }
                
            }
            .padding(.top, safeAreaInsets.top)
            .background(Rectangle().fill(Color(UIColor.systemBackground)))
            
            SearchBar(searchText: $vm.searchText, searching: $vm.searching)
                .padding(.trailing)
        }
        .padding(.leading)
        
    }
    
    
    private func MovieCell(_ movie: Search) -> some View {
        Group {
            if settingManager.gridDesign == .oneColumn {
                HStack(alignment: .top){
                    ImageView(photo: movie)
                        .frame(maxWidth: 140)
                    Spacer().frame(width: 10)
                    VStack(alignment: .leading ){
                        Text(movie.title)
                            .bold()
                            .font(.title3)
                        
                        LabelCapsule(text: movie.type.name)
                        LabelCapsule(text: movie.year)
                        Spacer()
                    }
                }
            } else {
                VStack(alignment: .leading){
                    ImageView(photo: movie)
                        .frame(width: 140, height: 200)
                    
                    Text(movie.title + "\n\n")
                        .lineLimit(3)
                        .font(.caption.bold())
                    Group {
                        LabelCapsule(text: movie.type.name)
                        LabelCapsule(text: movie.year)
                    }.font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .onTapGesture {
            vm.selectedMovie = movie
        }
        .padding(settingManager.gridDesign == .oneColumn ? [.horizontal, .top] : [.top, .leading])
    }
    
    private func LabelCapsule(text: String) -> some View {
        Text(text)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(settingManager.theme.mainColor)
            )
    }
}

// MARK: - Buttons
extension MainView {
    private var GridButton: some View {
        Button {
            withAnimation {
                settingManager.changeGrid()
            }
            
        } label: {
            Image(systemName: settingManager.gridDesign == .oneColumn ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
                .font(.title)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
        .tint(settingManager.theme.mainColor)
    }
    
    private var SettingsButton: some View {
        Button {
            vm.showingSettingsViewSheet.toggle()
        } label: {
            Image(systemName: "gear")
                .font(.title)
                .padding(.vertical)
                .padding(.leading, 8)
                .padding(.trailing)
        }
        .sheet(isPresented: $vm.showingSettingsViewSheet) {
            SettingsView()
        }
        .tint(settingManager.theme.mainColor)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView().preferredColorScheme(.dark)
        }
        .environmentObject(JSONDataService.previewInstance)
        .environmentObject(SettingManager.previewInstance)
    }
}
