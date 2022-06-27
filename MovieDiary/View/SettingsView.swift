//
//  SettingsView.swift
//  MovieDiary
//
//  Created by Can Bi on 27.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var tintColor: Color
    
    init(tintColor: Color ){
        self.tintColor = tintColor
        UITableView.appearance().contentInset.top = -20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(tintColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(tintColor)]
    }
    
    var body: some View {
        NavigationView {
            List {
                GridSettingsSection
                ColorSettingsSection
                DeveloperSection
                APISection
                Color.clear.listRowBackground(Color.clear)
            }
            .font(.headline)
            .accentColor(tintColor)
            .listStyle(.automatic)
            .navigationTitle("Settings")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: tintColor) { dismiss() }
                        .padding(.leading, -24)
                }
            }
            .overlay(ApplySettingsButton, alignment: .bottom)
            .onAppear {
                vm.setup(settingManager)
            }
        }
    }
}

// MARK: Button
extension SettingsView {
    private var ApplySettingsButton: some View {
        Button(action: {
            vm.applySettings()
            dismiss()
        }, label: {
            Text("Apply Settings".uppercased())
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
extension SettingsView {
    private var ColorSettingsSection: some View {
        Section(header: Text("Color Settings".uppercased())){
            ForEach(Themes.allCases) { theme in
                HStack {
                    Text(theme.rawValue)
                        .foregroundColor(vm.selectedTheme == theme ? tintColor : nil)
                    Spacer()
                    
                    theme.mainColor
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.selectedTheme = theme
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    private var GridSettingsSection: some View {
        Section(header: Text("Color Settings".uppercased())){
            ForEach(GridDesign.allCases) { grid in
                HStack {
                    Text(grid.rawValue)
                        .foregroundColor(vm.selectedGrid == grid ? tintColor : nil)
                    Spacer()
                    
                    Image(systemName: grid.iconName)
                        .font(.title2)
                        .padding(.vertical)
                        .padding(.horizontal, 8)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.selectedGrid = grid
                }
            }
        }
    }
    
    
    private var DeveloperSection: some View {
        Section(header: Text("Developer")) {
            Text("This app was developed by Can Bi. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            Link("Visit My Website 🖥️", destination: vm.personalURL)
            Link("Contact me on Twitter 🐦", destination: vm.twitterURL)
            Link("See my public projects on GitHub 👨‍💻", destination: vm.githubURL)
        }
    }
    
    private var APISection: some View {
        Section(header: Text("Developer")) {
            Text("The Open Movie Database\nThe OMDb API is a RESTful web service to obtain movie information, all content and images on the site are contributed and maintained by our users.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            Link("Visit APIs Website 🖥️", destination: vm.apiURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tintColor: .red)
    }
}
