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
    
    var body: some View {
        NavigationView {
            List {
                ColorSettingsSection
                DeveloperSection
                Color.clear.listRowBackground(Color.clear)
            }
            .font(.headline)
            .accentColor(settingManager.theme.mainColor)
            .listStyle(.automatic)
            .navigationTitle("Settings")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: settingManager.theme.mainColor) { dismiss() }
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
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(settingManager.theme.mainColor))
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
                        .foregroundColor(vm.selectedTheme == theme ? settingManager.theme.mainColor : nil)
                    Spacer()
                    Group {
                        theme.mainColor
                        theme.secondaryColor
                    }
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.selectedTheme = theme
                }
            }
            .padding(.vertical)
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
            Link("Visit Website 🖥️", destination: vm.personalURL)
            Link("Contact me on Twitter 🐦", destination: vm.twitterURL)
            Link("See my public projects on GitHub 👨‍💻", destination: vm.githubURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
