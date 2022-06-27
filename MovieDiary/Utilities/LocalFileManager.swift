//
//  LocalFileManager.swift
//  MarsRoverPhotos
//
//  Created by Nick Sarno on 4/22/21.
//  Swiftful Thinking https://youtu.be/Yiq-hdhLzVM
//
//  Updated by Can Bi on 06.04.2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    let folderName: String
    var appFolder: FileManager.SearchPathDirectory
    
    init(folderName: String, appFolder: FileManager.SearchPathDirectory){
        self.folderName = folderName
        self.appFolder = appFolder
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard let url = defaultURL() else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    func deleteFolder() {
        guard let url = defaultURL() else { return }
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
            print("Success deleting folder.")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    
    func getPathFor(name: String, type: String) -> URL? {
        guard let url = defaultURL() else { return nil }
        return url.appendingPathComponent("\(name).\(type)")
    }
    
    func deleteItem(name: String, type: String) -> String {
        guard let path = getPathFor(name: name, type: type)?.path,
              FileManager.default.fileExists(atPath: path) else {
            return "Error getting path."
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "Sucessfully deleted."
        } catch let error {
            return "Error deleting \(type). \(error)"
        }
    }
    
    func defaultURL() -> URL? {
        guard let path = FileManager
            .default
            .urls(for: appFolder, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName) else { return nil }
        return path
    }
}


class LocalFileManagerJSON: LocalFileManager, ObservableObject {
    let type: String = "JSON"
    
    func saveJSON<T: Codable >(name: String, data: T){
        do {
            guard
                let data = try? JSONEncoder().encode(data),
                let path = getPathFor(name: name, type: type) else {
                print("Error getting data.")
                return
            }
            
            
            try data.write(to: path ,options: [.atomic, .completeFileProtection])
            print("Success saving!")
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func getJSON<T: Codable>(name: String, dataType: T) -> T? {
        guard let filename = getPathFor(name: name, type: type),
              FileManager.default.fileExists(atPath: filename.path) else {
            print("Error getting path.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: filename)
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(T.self, from: data)
            
            return decodedData
        } catch {
            print("Whoops: \(error.localizedDescription)")
            return nil
        }
    }
}


class LocalFileManagerImage: LocalFileManager, ObservableObject {
    static var instance = LocalFileManagerImage(folderName: "images", appFolder: .cachesDirectory)
    
    let type: String = "jpg"
    
    func saveImage(image: UIImage, name: String, compressionQuality: Double = 0.8) -> String {
        guard
            let data = image.jpegData(compressionQuality: compressionQuality),
            let path = getPathFor(name: name, type: type) else {
            return "Error getting data."
        }
        
        do {
            try data.write(to: path,options: [.atomic, .completeFileProtection])
            return "Success saving!"
        } catch let error {
            return "Error saving. \(error)"
        }
    }
    
    func getImage(name: String) -> UIImage? {
        guard let path = getPathFor(name: name, type: type)?.path,
              FileManager.default.fileExists(atPath: path) else {
            print("Error getting path.")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
}
