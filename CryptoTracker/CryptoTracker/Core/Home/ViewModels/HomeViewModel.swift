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
    @Published var searchText: String = ""
    @Published var statistics: [Statistic] = [
        Statistic(title: "Title", value: "Value", percentageChange: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", percentageChange: -7)
    ]
    
    var filteredCoins: [Coin] {
        if searchText.isEmpty {
            return allCoins
        } else {
            return allCoins.filter {
                let lowercasedText = searchText.lowercased()
                
                return $0.name.lowercased().contains(lowercasedText) || $0.symbol.lowercased().contains(lowercasedText)
            }
        }
    }

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
