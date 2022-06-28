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
    @EnvironmentObject var coreDataService: CoreDataDataService
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel
    
    init(movie: Search? = nil, cdMovie: CDMovie? = nil, mainVM: MainViewModel){
        self._vm = StateObject(wrappedValue: DetailViewModel(movie: movie,
                                                             cdMovie: cdMovie,
                                                             mainVM: mainVM))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let _ = vm.movie {
                OnlineInformationView
                    .navigationTitle(vm.movieInfo?.title ?? "")
            }
            else {
                OfflineInformationView
                    .navigationTitle(vm.cdMovie!.title ?? "")
            }
        }
        .onAppear{ vm.setup(dataService: dataService, coreDataService: coreDataService) }
        .onDisappear{ dataService.movieInfo = nil }
        .sheet(isPresented: $vm.showingZoomImageView, content: {
            ImageZoomView(image: vm.clickedImage!, tintColor: settingManager.theme.mainColor)
        })
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(color: settingManager.theme.mainColor) { dismiss() }
                    .padding(.leading, -24)
            }
        }
    }
}

// MARK: Offline Info Views
extension DetailView {
    private var OfflineInformationView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                CoverOfflineView
                
                VStack(alignment: .leading) {
                    MainInfoOfflineView
                    
                    GenreOfflineView
                    Spacer(minLength: 8)
                    
                    RatingOfflineView
                }
            }
            .padding(.vertical)
            
            
            Group {
                Divider()
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                
                PlotOfflineView
                
                CastOfflineView
                
                DirectorOfflineView
                
                WriterOfflineView
                
                ProductionOfflineView
                
                BoxOfficeOfflineView
                
                AwardsOfflineView
                
                WebsiteOfflineView
                
                LocalInfoOfflineView
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private var CoverOfflineView: some View {
        Group {
            ImageOfflineView(movie: vm.cdMovie!)
                .frame(width: 150)
                .padding(.leading)
                .overlay(ZoomButton(action: vm.zoomImage), alignment: .bottomTrailing)
                .overlay(FavoritesButton, alignment: .topTrailing)
        }
    }
    
    
    private var MainInfoOfflineView: some View {
        Group {
            Text(vm.cdMovie!.title ?? "Default")
                .fixedSize(horizontal: false, vertical: true)
                .font(.title3.bold())
            Text(vm.cdMovie!.type?.capitalized ?? "Default")
            
            Group {
                HStack {
                    Text(vm.cdMovie!.runtime ?? "Default")
                    Text(vm.cdMovie!.rated ?? "Default")
                    Text(vm.cdMovie!.year ?? "Default")
                }
                if let totalSeasons = vm.cdMovie!.totalSeasons {
                    Text("Total \(totalSeasons) season")
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            
        }
        .padding(.horizontal)
    }
    
    
    private var GenreOfflineView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.cdMovie!.genres ?? ["Default1", "Default2"], id: \.self) { genre in
                    Text(genre)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(settingManager.theme.mainColor, lineWidth: 2)
                        )
                        .padding(.leading)
                        .padding(.trailing, -12)
                }
            }
        }
    }
    
    private var PlotOfflineView: some View {
        Group {
            Text("Plot")
                .bold()
            Text(vm.cdMovie!.plot ?? "Default plot longer than any other default text because redacted view should be bigger than any other redacted views.")
                .font(.callout)
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var CastOfflineView: some View {
        Group {
            Text("Cast")
                .bold()
            Text(vm.cdMovie!.actors ?? "Default cast")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var DirectorOfflineView: some View {
        Group {
            Text("Director")
                .bold()
            Text(vm.cdMovie!.director ?? "Default director")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var WriterOfflineView: some View {
        Group {
            Text("Writer")
                .bold()
            Text(vm.cdMovie!.writer ?? "Default writer")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var LocalInfoOfflineView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Language")
                    .bold()
                Text(vm.cdMovie!.language ?? "Default language")
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Country")
                    .bold()
                Text(vm.cdMovie!.country ?? "Default country")
                    .foregroundColor(.secondary)
            }
            
            Spacer(minLength: 0)
        }
    }
    
    private var BoxOfficeOfflineView: some View {
        Group {
            Text("Box Office")
                .bold()
            Text(vm.cdMovie!.boxOffice ?? "Default boxoffice")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var AwardsOfflineView: some View {
        Group {
            Text("Award")
                .bold()
            Text(vm.cdMovie!.awards ?? "Default awards")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var ProductionOfflineView: some View {
        Group {
            if let production = vm.cdMovie!.production {
                Text("Production")
                    .bold()
                Text(production)
                    .foregroundColor(.secondary)
                Spacer().frame(height: 10)
            }
        }
    }
    
    private var WebsiteOfflineView: some View {
        Group {
            if let website = vm.cdMovie!.website {
                Text("Website")
                    .bold()
                Text(website)
                    .foregroundColor(.secondary)
                Spacer().frame(height: 10)
            }
        }
    }
    
    private var RatingOfflineView: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image("IMDb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                Text("\(vm.cdMovie!.imdbRating ?? "Default"),")
                Text("\(vm.cdMovie!.imdbVotes ?? "Default") votes")
            }
            
            if let score = vm.cdMovie!.metacriticScore {
                HStack {
                    Image("Metacritic")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                    Text(score)
                }
            }
            
            if let score = vm.cdMovie!.rottenScore {
                HStack{
                    Image("Rotten Tomatoes")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                    Text(score)
                }
            }
        }
        .font(.footnote)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}

// MARK: Online Info Views
extension DetailView {
    private var OnlineInformationView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                CoverView
                
                VStack(alignment: .leading) {
                    MainInfoView
                    GenreView
                    Spacer(minLength: 8)
                    
                    RatingView
                }
            }
            .padding(.vertical)
            
            Group {
                Divider()
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                
                PlotView
                
                CastView
                
                DirectorView
                
                WriterView
                
                ProductionView
                
                BoxOfficeView
                
                AwardsView
                
                WebsiteView
                
                LocalInfoView
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .redacted(reason: vm.movieInfo == nil ? .placeholder : [])
    }
    
    private var CoverView: some View {
        Group {
            if let movie = vm.movie {
                ImageView(photo: movie)
                    .frame(width: 150)
                    .padding(.leading)
                    .overlay(ZoomButton(action: vm.zoomImage), alignment: .bottomTrailing)
                    .overlay(FavoritesButton, alignment: .topTrailing)
            }
        }
    }
    
    private var MainInfoView: some View {
        Group {
            Text(vm.movieInfo?.title ?? "Default")
                .fixedSize(horizontal: false, vertical: true)
                .font(.title3.bold())
            Text(vm.movieInfo?.type.capitalized ?? "Default")
            
            Group {
                HStack {
                    Text(vm.movieInfo?.runtime ?? "Default")
                    Text(vm.movieInfo?.rated ?? "Default")
                    Text(vm.movieInfo?.year ?? "Default")
                }
                
                if let totalSeasons = vm.movieInfo?.totalSeasons {
                    Text("Total \(totalSeasons) season")
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    private var GenreView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.movieInfo?.genres ?? ["Default1", "Default2"], id: \.self) { genre in
                    Text(genre)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(settingManager.theme.mainColor, lineWidth: 2)
                        )
                        .padding(.leading)
                        .padding(.trailing, -12)
                }
            }
        }
    }
    
    private var PlotView: some View {
        Group {
            Text("Plot")
                .bold()
            Text(vm.movieInfo?.plot ?? "Default plot longer than any other default text because redacted view should be bigger than any other redacted views.")
                .font(.callout)
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var CastView: some View {
        Group {
            Text("Cast")
                .bold()
            Text(vm.movieInfo?.actors ?? "Default cast")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var DirectorView: some View {
        Group {
            Text("Director")
                .bold()
            Text(vm.movieInfo?.director ?? "Default director")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var WriterView: some View {
        Group {
            Text("Writer")
                .bold()
            Text(vm.movieInfo?.writer ?? "Default writer")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var LocalInfoView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Language")
                    .bold()
                Text(vm.movieInfo?.language ?? "Default language")
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Country")
                    .bold()
                Text(vm.movieInfo?.country ?? "Default country")
                    .foregroundColor(.secondary)
            }
            
            Spacer(minLength: 0)
        }
    }
    
    private var BoxOfficeView: some View {
        Group {
            Text("Box Office")
                .bold()
            Text(vm.movieInfo?.boxOffice ?? "Default boxoffice")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var AwardsView: some View {
        Group {
            Text("Award")
                .bold()
            Text(vm.movieInfo?.awards ?? "Default awards")
                .foregroundColor(.secondary)
            Spacer().frame(height: 10)
        }
    }
    
    private var ProductionView: some View {
        Group {
            if let production = vm.movieInfo?.production {
                Text("Production")
                    .bold()
                Text(production)
                    .foregroundColor(.secondary)
                Spacer().frame(height: 10)
            }
        }
    }
    
    private var WebsiteView: some View {
        Group {
            if let website = vm.movieInfo?.website {
                Text("Website")
                    .bold()
                Text(website)
                    .foregroundColor(.secondary)
                Spacer().frame(height: 10)
            }
        }
    }
    
    private var RatingView: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image("IMDb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                Text("\(vm.movieInfo?.imdbRating ?? "Default"),")
                Text("\(vm.movieInfo?.imdbVotes ?? "Default") votes")
            }
            if let movieInfo = vm.movieInfo {
                if let score = movieInfo.metacriticScore {
                    HStack {
                        Image("Metacritic")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                        Text(score)
                    }
                }
                
                if let score = movieInfo.rottenTomatoesScore {
                    HStack{
                        Image("Rotten Tomatoes")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                        Text(score)
                    }
                }
            }
        }
        .font(.footnote)
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}

// MARK: Buttons
extension DetailView {
    private var FavoritesButton: some View {
        Button{
            vm.favoriteButton {dismiss()}
        } label: {
            Image(systemName: vm.isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 30))
                .foregroundColor(vm.isFavorited ? settingManager.theme.mainColor : .white)
        }
        .padding([.trailing, .top], 8)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailView(movie: Search.previewData, mainVM: MainViewModel())
            DetailView(movie: Search.previewData, mainVM: MainViewModel()).preferredColorScheme(.dark)
        }
        .environmentObject(SettingManager.previewInstance)
        .environmentObject(JSONDataService.previewInstance)
        .environmentObject(CoreDataDataService(moc: CoreDataController().container.viewContext))
    }
}
