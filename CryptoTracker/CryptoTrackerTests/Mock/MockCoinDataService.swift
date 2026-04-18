//
//  MockCoinDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 17/04/26.
//

@testable import CryptoTracker

actor MockCoinDataService: CoinDataServiceProtocol {
    func getCoins() async throws -> [Coin] {
        let coin = await DeveloperPreview.instance.coin
        let coins = [coin]
        return coins
    }
    
    func getMarketData() async throws -> MarketData {
        return MarketData(totalMarketCap: [:],
                          totalVolume: [:],
                          marketCapPercentage: [:],
                          marketCapChangePercentage24HUsd: 0.0)
    }
}
