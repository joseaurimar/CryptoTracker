//
//  MockCoinDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 17/04/26.
//

import Foundation
import UIKit
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
    
    func downloadCoinImage(with url: String) async throws -> UIImage? {
        if shouldThrowError {
            throw errorToThrow
        }
        
        // Return a small test image (1x1 red pixel)
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
