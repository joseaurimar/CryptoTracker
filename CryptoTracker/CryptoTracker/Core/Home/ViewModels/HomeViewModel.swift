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
    
    enum SortOptioin {
        case rank, rankReversed, price, priceReversed, holdings, holdingsReversed
    }
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOptioin = .holdings
    
    private let coinService = CoinDataService()
    private let service: PortfolioDataService
    
    var filteredCoins: [Coin] {
        if searchText.isEmpty {
            return sortCoins()
        } else {
            return filterAndSortCoins()
        }
    }
    
    init(with service: PortfolioDataService) {
        self.service = service
        
        Task {
            await fetchMarketData()
            await getCoins()
        }
    }
    
    private func getCoins() async {
        do {
            allCoins = try await coinService.getCoins()
            portfolioCoins = await fetchPortfolioCoins()
        } catch {
            print(error.localizedDescription)
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
    
    private func filterAndSortCoins() -> [Coin] {
        
        let filteredList = allCoins.filter {
            let lowercasedText = searchText.lowercased()
            return $0.name.lowercased().contains(lowercasedText) || $0.symbol.lowercased().contains(lowercasedText)
        }
        
        switch sortOption {
        case .rank, .holdings:
            return filteredList.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return filteredList.sorted(by: { $0.rank > $1.rank })
        case .price:
            return filteredList.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return filteredList.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortCoins() -> [Coin] {
        switch sortOption {
        case .rank, .holdings:
            return allCoins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return allCoins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return allCoins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return allCoins.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded() {
        // will only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
            portfolioCoins = portfolioCoins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            portfolioCoins = portfolioCoins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            portfolioCoins = portfolioCoins
        }
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
