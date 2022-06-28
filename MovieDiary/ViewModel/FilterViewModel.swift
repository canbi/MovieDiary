//
//  FilterViewModel.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import Foundation

class FilterViewModel: ObservableObject {
    let mainVM: MainViewModel
    
    // Filters
    @Published var selectedSearchType: SearchType
    @Published var selectedSearchYear: Int? = nil
    
    var isAnythingChanged: Bool { !isSearchTypeSame || !isSearchYearSame }
    
    var isSearchTypeSame: Bool { selectedSearchType == mainVM.searchType }
    var isSearchYearSame: Bool { selectedSearchYear == mainVM.searchYear }
    
    init(mainVM: MainViewModel){
        self.mainVM = mainVM
        self._selectedSearchType = Published(initialValue: mainVM.searchType)
        self._selectedSearchYear = Published(initialValue: mainVM.searchYear)
    }
    
    func applyFilter(){
        guard isAnythingChanged else {return}
        
        mainVM.searchType = selectedSearchType
        mainVM.searchYear = selectedSearchYear
        mainVM.scrollViewProxy.scrollTo("top")
    }
}
