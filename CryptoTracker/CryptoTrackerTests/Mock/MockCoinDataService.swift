//
//  MockCoinDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 17/04/26.
//

import Foundation
@testable import CryptoTracker

actor MockCoinDataService: CoinDataServiceProtocol {
    var shouldThrowError: Bool = false
    var errorToThrow: Error = URLError(.badServerResponse)
    
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }
    
    func getCoins() async throws -> [Coin] {
        if shouldThrowError {
            throw errorToThrow
        }
        let coin = await DeveloperPreview.instance.coin
        let coins = [coin]
        return coins
    }
    
    func getMarketData() async throws -> MarketData {
        if shouldThrowError {
            throw errorToThrow
        }
        return MarketData(totalMarketCap: [:],
                          totalVolume: [:],
                          marketCapPercentage: [:],
                          marketCapChangePercentage24HUsd: 0.0)
    }
}
