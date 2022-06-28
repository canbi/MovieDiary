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
    @EnvironmentObject var coreDataService: CoreDataDataService
    @ObservedObject var networkMonitor: NetworkMonitor = NetworkMonitor()
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
                        Section(header: GridHeader, footer: GridFooter) {
                            if vm.initialState {
                                NoSearchView
                            } else if vm.notFoundState {
                                NoResultView
                            } else if vm.noFavoritesState {
                                NoFavoritesView
                            }
                            
                            LazyVGrid(columns: settingManager.gridDesign == .oneColumn ? oneColumns : twoColumns,
                                      alignment: .leading,
                                      spacing: 0,
                                      pinnedViews: .sectionHeaders) {
                                
                                if vm.showingOnlyFavorites {
                                    OfflineMoviesView
                                } else {
                                    OnlineMoviesView
                                }
                                
                                if vm.showDummyCellsState {
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
                .onAppear{
                    vm.setup(dataService: dataService,
                             cdDataService: coreDataService,
                             networkMonitor: networkMonitor)
                    vm.scrollViewProxy = reader
                }
                .sheet(isPresented: $vm.showingFilterViewSheet) {
                    FilterView(mainVM: vm, tintColor: settingManager.theme.mainColor)
                }
            }
            .navigationDestination(for: $vm.selectedMovie) { movie in
                DetailView(movie: movie, mainVM: vm)
            }
            .navigationDestination(for: $vm.selectedOfflineMovie) { movie in
                DetailView(cdMovie: movie, mainVM: vm)
            }
            .ignoresSafeArea(.container, edges: .top)
            .navigationBarHidden(true)
            .gesture(DragGesture()
                .onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
            )
        }
    }
}

// MARK: - Section Header and Footer
extension MainView {
    private var GridHeader: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment:.leading, spacing: 0) {
                    Text("Movie Diary")
                        .font(.largeTitle.bold())
                    FilterSummary
                }
                
                Spacer()
                
                FavoritesButton
                FilterButton
                SettingsButton
            }
            .padding(.horizontal)
            .padding(.top, safeAreaInsets.top)
            .background(Rectangle().fill(Color(UIColor.systemBackground)))
            
            SearchBar(searchText: $vm.searchText, searching: $vm.searching)
                .padding(.horizontal)
        }
        .id("top")
    }
    
    private var FilterSummary: some View {
        HStack(alignment: .top, spacing: 0){
            Text("\(vm.searchType.name), ")
            if let year = vm.searchYear {
                Text(String(year))
            }
            else {
                Text("All")
            }
            
            if vm.showingOnlyFavorites {
                Text(", in Favorites")
            }
            
            Spacer()
        }
        .font(.caption)
    }
    
    private var GridFooter: some View {
        Group {
            if vm.showPageNumberState {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 0){
                        ForEach(1...vm.maxPageNumber, id: \.self) { number in
                            PageNumberView(number)
                                .padding(.trailing)
                        }
                    }
                    .padding([.leading,.vertical])
                }
            }
        }
    }
    
    private func PageNumberView(_ number: Int) -> some View {
        Button {
            withAnimation {
                vm.changePage(to: number)
            }
        } label: {
            Circle()
                .strokeBorder(settingManager.theme.mainColor, lineWidth: 4)
                .background(Circle().fill(vm.currentPageNumber == number ? settingManager.theme.mainColor : .clear))
                .frame(width: 35, height: 35)
                .overlay(
                    Text(String(number))
                        .bold()
                        .foregroundColor(vm.currentPageNumber == number ? .white : .primary)
                )
        }
    }
}

// MARK: - Movie Main Views
extension MainView {
    private var OnlineMoviesView: some View {
        ForEach(vm.searchResults?.search ?? [], id:\.imdbID) { result in
            MovieCell(result)
                .redacted(reason: vm.isPageLoading ? .placeholder : [])
        }
    }
    
    private var OfflineMoviesView: some View {
        ForEach(vm.filteredFavoriteMovies, id:\.wrappedId) { result in
            MovieOfflineCell(result)
        }
    }
}

// MARK: - Dummy Redacted Views
extension MainView {
    private var DummyCell: some View {
        Group {
            if settingManager.gridDesign == .oneColumn {
                DummyOneColumnView
            } else {
                DummuTwoColumnView
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
    
    private var DummyOneColumnView: some View {
        HStack(alignment: .top){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemFill))
                .frame(width: 140, height: 200)
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
    }
    
    private var DummuTwoColumnView: some View {
        VStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemFill))
                .frame(width: 140, height: 200)
            
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

// MARK: - Offline Cell
extension MainView {
    private func OfflineCellImage(_ movie: CDMovie) -> some View {
        ImageOfflineView(movie: movie)
            .frame(width: 140, height: 200)
            .overlay(Image(systemName: "heart.fill")
                .foregroundColor(settingManager.theme.mainColor)
                .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                .padding([.top,.trailing], 6),
                     alignment: .topTrailing)
    }
    
    
    private func MovieOfflineCell(_ movie: CDMovie) -> some View {
        Group {
            if settingManager.gridDesign == .oneColumn {
                HStack(alignment: .top){
                    OfflineCellImage(movie)
                    
                    Spacer().frame(width: 10)
                    
                    VStack(alignment: .leading ){
                        Text(movie.title ?? "")
                            .bold()
                            .font(.title3)
                        
                        LabelCapsule(text: movie.type?.capitalized ?? "")
                        LabelCapsule(text: movie.year ?? "")
                        
                        Spacer()
                    }
                }
            } else {
                
                VStack(alignment: .leading){
                    OfflineCellImage(movie)
                    
                    Text(movie.title ?? "" + "\n\n")
                        .lineLimit(3)
                        .font(.caption.bold())
                    
                    Group {
                        LabelCapsule(text: movie.type?.capitalized ?? "")
                        LabelCapsule(text: movie.year ?? "")
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
            vm.selectedOfflineMovie = movie
        }
        .padding(.top)
        .padding(.leading)
    }
}

// MARK: - Cell
extension MainView {
    private func MovieCellImage(_ movie: Search) -> some View {
        ImageView(photo: movie)
            .frame(width: 140, height: 200)
            .overlay(Image(systemName: "heart.fill")
                .foregroundColor(settingManager.theme.mainColor)
                .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                .opacity(coreDataService.isFavorited(imdbId: movie.imdbID) ? 1 : 0)
                .padding([.top,.trailing], 6),
                     alignment: .topTrailing)
    }
    
    private func MovieCell(_ movie: Search) -> some View {
        Group {
            if settingManager.gridDesign == .oneColumn {
                HStack(alignment: .top){
                    MovieCellImage(movie)
                    
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
                    MovieCellImage(movie)
                    
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

// MARK: - States
extension MainView {
    private var NoResultImage: some View {
        Image("no-search")
            .resizable()
            .scaledToFit()
            .frame(width: 140)
    }
    
    private var NoSearchMessage: some View {
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
    
    private var NoResultMessage: some View {
        VStack(alignment: .trailing, spacing: 0){
            Text("Not Found in this filters!")
                .bold()
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .padding(.trailing)
    }
    
    private var NoFavoritesMessage: some View {
        VStack(alignment: .trailing, spacing: 0){
            Text("No favorites in this filters!")
                .bold()
                .font(.title3)
                .multilineTextAlignment(.center)
        }
        .padding(.trailing)
    }
    
    private var NoSearchView: some View {
        HStack(alignment: .center){
            NoResultImage
            
            Spacer(minLength: 0)
                .background(.gray)
            NoSearchMessage
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding([.top, .horizontal])
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
    
    private var NoFavoritesView: some View {
        HStack(alignment: .center){
            NoResultImage
            
            Spacer(minLength: 0)
                .background(.gray)
            NoFavoritesMessage
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding([.top, .horizontal])
    }
}

// MARK: - Buttons
extension MainView {
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
            SettingsView(tintColor: settingManager.theme.mainColor)
        }
        .tint(settingManager.theme.mainColor)
    }
    
    private var FilterButton: some View {
        Button {
            vm.showingFilterViewSheet.toggle()
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
        .tint(settingManager.theme.mainColor)
    }
    
    private var FavoritesButton: some View {
        Button {
            //TODO: network check
            //guard networkMonitor.isConnected else { return }
            vm.showingOnlyFavorites.toggle()
        } label: {
            Image(systemName: vm.showingOnlyFavorites ? "heart.fill" : "heart")
                .font(.title)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
        .tint(settingManager.theme.mainColor)
    }
}

// MARK: - Preview
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
