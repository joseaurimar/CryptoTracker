//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 29/03/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []

    private let coinService = CoinDataService()
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        Task {
            do {
                allCoins = try await coinService.getCoins()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
