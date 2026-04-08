//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 31/03/26.
//

import SwiftUI

actor LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() {}
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getURLForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print("Error creating directory called: \(folderName) -> \(error)")
            }
        }
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // Create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard let image = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        
        // save image to path
        do {
            try image.write(to: url)
        } catch {
            print("Error saving image called: \(imageName) -> \(error)")
        }
    }
    
    func getImage(with name: String, in folderName: String) -> UIImage? {
        
        guard let url = getURLForImage(imageName: name, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
}
