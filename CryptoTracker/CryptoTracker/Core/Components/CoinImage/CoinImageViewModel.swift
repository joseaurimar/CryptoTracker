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
    private let coinDataService: CoinDataServiceProtocol
    private let fileManager: LocalFileManagerProtocol
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin,
         coinDataService: CoinDataServiceProtocol = CoinDataService(),
         fileManager: LocalFileManagerProtocol = LocalFileManager.instance) {
        
        self.coin = coin
        self.coinDataService = coinDataService
        self.fileManager = fileManager
        isLoading = true
        imageName = coin.id
        getImage(imageURL: coin.image)
    }
    
    private func getImage(imageURL: String) {
        
        Task {
            if let localImage = await fileManager.getImage(with: imageName, in: folderName) {
                image = localImage
            } else {
                do {
                    image = try await coinDataService.downloadCoinImage(with: imageURL)
                    
                    if let downloadedImage = image {
                        await fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
                    }
                } catch {
                    // Error handled silently - image remains nil
                }
            }
            
            isLoading = false
        }
    }
}
