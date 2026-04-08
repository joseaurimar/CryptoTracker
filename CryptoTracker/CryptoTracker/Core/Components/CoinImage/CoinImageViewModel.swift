//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 31/03/26.
//

import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading = false
    
    private let coin: Coin
    private let coinDataService = CoinDataService()
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        isLoading = true
        imageName = coin.id
        getImage(imageURL: coin.image)
    }
    
    private func getImage(imageURL: String) {
        
        Task {
            if let localImage = await fileManager.getImage(with: imageName, in: folderName) {
                image = localImage
            } else {
                image = try await coinDataService.downloadCoinImage(with: imageURL)
                
                if let downloadedImage = image {
                    await fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
                }
            }
            
            isLoading = false
        }
    }
}
