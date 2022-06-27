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
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel
    
    init(_ movie: Search){
        self._vm = StateObject(wrappedValue: DetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                    
                    BoxOfficeView
                    
                    LocalInfoView
                }
                .padding(.horizontal)

                Spacer()
            }
            .redacted(reason: vm.movieInfo == nil ? .placeholder : [])
            .onAppear{ vm.setup(dataService: dataService) }
            .onDisappear{ dataService.movieInfo = nil }
        }
        .sheet(isPresented: $vm.showingZoomImageView, content: {
            ImageZoomView(image: vm.clickedImage!, tintColor: settingManager.theme.mainColor)
        })
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(vm.movieInfo?.title ?? "")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(color: settingManager.theme.mainColor) { dismiss() }
                .padding(.leading, -24)
            }
        }
    }
}

extension DetailView {
    private var CoverView: some View {
        Group {
            if let movie = vm.movie {
                ImageView(photo: movie)
                    .frame(width: 150)
                    .padding(.leading)
                    .overlay(
                        ZoomButton(action: {
                            vm.clickedImage = vm.getImage()
                            vm.showingZoomImageView = true
                        }
                    ),
                        alignment: .bottomTrailing)
            }
        }
    }
    
    private var MainInfoView: some View {
        Group {
            Text(vm.movieInfo?.title ?? "Default")
                .fixedSize(horizontal: false, vertical: true)
                .font(.title3.bold())
            Text(vm.movieInfo?.type.capitalized ?? "Default")
            
            HStack {
                Text(vm.movieInfo?.runtime ?? "Default")
                Text(vm.movieInfo?.rated ?? "Default")
                Text(vm.movieInfo?.year ?? "Default")
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailView(Search.previewData)
            DetailView(Search.previewData).preferredColorScheme(.dark)
        }
            .environmentObject(SettingManager.previewInstance)
            .environmentObject(JSONDataService.previewInstance)
    }
}
