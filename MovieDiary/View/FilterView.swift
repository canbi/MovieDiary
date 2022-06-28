//
//  FilterView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    var tintColor: Color
    
    init(mainVM: MainViewModel, tintColor: Color){
        self.tintColor = tintColor
        self._vm = StateObject(wrappedValue: FilterViewModel(mainVM: mainVM))
        UITableView.appearance().contentInset.top = -20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(tintColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(tintColor)]
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchTypeSection
                SearchYearSection
                Color.clear.listRowBackground(Color.clear)
            }
            .font(.headline)
            .accentColor(tintColor)
            .listStyle(.automatic)
            .navigationTitle("Filters")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: tintColor) { dismiss() }
                        .padding(.leading, -24)
                }
            }
            .overlay(ApplyFilterButton, alignment: .bottom)
        }
    }
}

// MARK: Button
extension FilterView {
    private var ApplyFilterButton: some View {
        Button(action: {
            vm.applyFilter()
            dismiss()
        }, label: {
            Text("Apply Filter")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tintColor))
                .padding()
        })
        .opacity(vm.isAnythingChanged ? 1 : 0)
        .disabled(vm.isAnythingChanged ? false : true)
    }
}

// MARK: Sections
extension FilterView {
    private var SearchTypeSection: some View {
        Section(header: Text("Date Filter".uppercased())) {
            Picker("", selection: $vm.selectedSearchType) {
                ForEach(SearchType.allCases) { type in
                    Text(type.name)
                }
            }
            .labelsHidden()
            .pickerStyle(.inline)
        }
    }
    
    private var SearchYearSection: some View {
        Section(header: Text("Year Filter".uppercased())) {
            Picker("", selection: $vm.selectedSearchYear) {
                Text("Default").tag(nil as Int?)
                ForEach((1888...Calendar.current.component(.year, from: Date())).reversed(), id: \.self) { year in
                    Text(String(year)).tag(year as Int?)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Text("Reset Year Filter").onTapGesture {
                withAnimation {
                    vm.selectedSearchYear = nil
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(mainVM: MainViewModel(), tintColor: .red)
            .environmentObject(SettingManager())
    }
}
