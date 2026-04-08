//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 29/03/26.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinService = CoinDataService()
    private let service: PortfolioDataService
    
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
    
    init(with service: PortfolioDataService) {
        self.service = service
        
        Task {
            await fetchMarketData()
        }
        
        getCoins()
    }
    
    private func getCoins() {
        Task {
            do {
                allCoins = try await coinService.getCoins()
                portfolioCoins = await fetchPortfolioCoins()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMarketData() async {
        do {
            let marketData = try await coinService.getMarketData()
            let marketCap = Statistic(
                title: "Market Cap",
                value: marketData.marketCap,
                percentageChange: marketData.marketCapChangePercentage24HUsd
            )
            
            let volume = Statistic(title: "24h Volume", value: marketData.volume)
            let btcDominance = Statistic(title: "BTC Dominance", value: marketData.btcDominance)
            
            let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
            
            let previousValue = portfolioCoins.map { coin -> Double in
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                return coin.currentHoldingsValue / (1 + percentChange)
            }.reduce(0, +)
            
            let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
            
            let portfolio = Statistic(
                title: "Portfolio Value",
                value: portfolioValue.asNumberString(),
                percentageChange: percentageChange
            )
            
            statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reloadData() async {
        isLoading = true
        
        do {
            allCoins = try await coinService.getCoins()
            await fetchMarketData()
        } catch {
            print(error.localizedDescription)
        }
        
        isLoading = false
        HapticManager.notification(type: .success)
    }
    
    // MARK: SwiftData functions
    private func add(coin: Coin, amount: Double) {
        Task { @MainActor in
            service.insert(Portfolio(coinID: coin.id, amount: amount))
            portfolioCoins = await fetchPortfolioCoins()
        }
    }
    
    // Delete portfolio
    private func delete(_ portfolio: Portfolio) {
        Task { @MainActor in
            service.delete(portfolio)
            portfolioCoins = await fetchPortfolioCoins()
        }
    }
    
    @MainActor
    private func fetchPortfolioCoins() async -> [Coin] {
        let portfolioCoins = service.fetchPortfolioCoins()
        var coins: [Coin] = []
        
        portfolioCoins.forEach { portfolio in
            if let coin = allCoins.first(where: { $0.id == portfolio.coinID }) {
                coins.append(coin.updateHoldings(amount: portfolio.amount))
            }
        }
        
        await fetchMarketData()
        
        return coins
    }
    
    // First check if portfolio was added in data base if not add a new coin to portfolio.
    // If the selected coin is in data base check if the amount value is greater than zero to update the amount and if the amount is zero remove portfolio from data base.
    func updatePortfolio(coin: Coin, amount: Double) {
        if let portfolio = service.fetchPortfolioCoins().first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                portfolio.amount = amount
            } else {
                delete(portfolio)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    func getPortfolio(coin: Coin) -> Portfolio? {
        return service.fetchPortfolioCoins().first(where: { $0.coinID == coin.id })
    }
}
