//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 31/03/26.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading = false
    
    private let coin: Coin
    private let coinDataService = CoinDataService()
    
    init(coin: Coin) {
        self.coin = coin
        isLoading = true
        getImage(imageURL: coin.image)
    }
    
    private func getImage(imageURL: String) {
        Task {
            image = try await coinDataService.getCoinImage(with: imageURL)
            isLoading = false
        }
    }
}
