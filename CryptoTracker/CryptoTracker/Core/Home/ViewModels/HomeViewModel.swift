//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 29/03/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    //@Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
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
        fetchMarketData()
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
    
    private func fetchMarketData() {
        Task {
            do {
                let marketData = try await coinService.getMarketData()
                let marketCap = Statistic(
                    title: "Market Cap",
                    value: marketData.marketCap,
                    percentageChange: marketData.marketCapChangePercentage24HUsd
                )
                
                let volume = Statistic(title: "24h Volume", value: marketData.volume)
                let btcDominance = Statistic(title: "BTC Dominance", value: marketData.btcDominance)
                let portfolio = Statistic(title: "Portfolio Value", value: "R$0,00", percentageChange: 0)
                
                statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPortfolioCoin(where portfolio: Portfolio) -> Coin? {
        return allCoins.first(where: { $0.id == portfolio.coinID })
    }
}
