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
    
    let oneColumns = [GridItem(.flexible(maximum: .infinity))]
    let twoColumns = [GridItem(.flexible(maximum: .infinity),
                               spacing: 0,
                               alignment: .topLeading),
                      GridItem(.flexible(maximum: .infinity),
                               spacing: 0,
                               alignment: .topLeading)]
    
    var body: some View {
        NavigationView {
            ScrollViewReader { reader in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                        Section(header: GridHeader) {
                            if vm.searchResults?.search?.isEmpty ?? true {
                                NoResultView
                            }
                            
                            LazyVGrid(columns: settingManager.gridDesign == .oneColumn ? oneColumns : twoColumns,
                                      alignment: .leading,
                                      spacing: 0,
                                      pinnedViews: .sectionHeaders) {
                                
                                ForEach(vm.searchResults?.search ?? [], id:\.imdbID) { result in
                                    MovieCell(result)
                                }
                                
                                if vm.searchResults?.search?.isEmpty ?? true {
                                    Group{
                                        DummyCell
                                        DummyCell
                                        DummyCell
                                        DummyCell
                                    }
                                    .redacted(reason: .placeholder)
                                }
                            }
                            .padding(.trailing)
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
                
                GridButton
                SettingsButton
                
            }
            .padding(.horizontal)
            .padding(.top, safeAreaInsets.top)
            .background(Rectangle().fill(Color(UIColor.systemBackground)))
            
            SearchBar(searchText: $vm.searchText, searching: $vm.searching)
                .padding(.horizontal)
        }
    }
    
    private var DummyCell: some View {
        Group {
            if settingManager.gridDesign == .oneColumn {
                HStack(alignment: .top){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.secondarySystemFill))
                        .frame(width: 130, height: 200)
                    Spacer().frame(width: 10)
                    VStack(alignment: .leading ){
                        Text("Long Dummy Title")
                            .bold()
                            .font(.title3)
                        
                        Text("Movie")
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                            )
                        
                        Text("2022")
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                            )
                        
                        Spacer()
                    }
                }
            } else {
                VStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.secondarySystemFill))
                        .frame(width: 130, height: 200)
                    
                    Text("Long Dummy Title")
                        .lineLimit(3)
                        .font(.caption.bold())
                    Group {
                        Text("Movie")
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                            )
                        
                        Text("2022")
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                            )
                    }
                    .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding([.top, .leading])
        .redacted(reason: .placeholder)
    }
    
    private var NoResultImage: some View {
        Image("no-search")
            .resizable()
            .scaledToFit()
            .frame(width: 140)
    }
    
    private var NoResultMessage: some View {
        VStack(alignment: .trailing, spacing: 0){
            Image("arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.primary)
                .offset(x: 20)
            
            Text("Start\nwith\nsearch!")
                .bold()
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .padding(.trailing)
    }
    
    private var NoResultView: some View {
        HStack(alignment: .center){
            NoResultImage
            
            Spacer(minLength: 0)
                .background(.gray)
            NoResultMessage
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding([.top, .horizontal])
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
                        .frame(width: 130, height: 200)
                    
                    Text(movie.title + "\n\n")
                        .lineLimit(3)
                        .font(.caption.bold())
                    
                    Group {
                        LabelCapsule(text: movie.type.name)
                        LabelCapsule(text: movie.year)
                    }
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
        .padding(.top)
        .padding(.leading)
    }
    
    private func LabelCapsule(text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
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
