//
//  MockLocalFileManager.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 30/04/26.
//

import Foundation
import UIKit
@testable import CryptoTracker

actor MockLocalFileManager: LocalFileManagerProtocol {
    var storedImages: [String: UIImage] = [:]
    var shouldReturnImage: Bool = false
    
    func setShouldReturnImage(_ value: Bool) {
        shouldReturnImage = value
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        let key = "\(folderName)/\(imageName)"
        storedImages[key] = image
    }
    
    func getImage(with name: String, in folderName: String) -> UIImage? {
        guard shouldReturnImage else { return nil }
        let key = "\(folderName)/\(name)"
        if let image = storedImages[key] {
            return image
        }
        // Return a default test image if none stored
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.blue.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
