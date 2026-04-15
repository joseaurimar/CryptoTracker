//
//  MockCoinDetailDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 14/04/26.
//

@testable import CryptoTracker

actor MockCoinDetailDataService: CoinDetailDataServiceProtocol {
    func getCoinDetails(with id: String) async throws -> CoinDetail {
        return CoinDetail(id: id,
                          symbol: "btc",
                          name: "Bitcoin",
                          blockTimeInMinutes: nil,
                          hashingAlgorithm: nil,
                          description: Description(en: "english description"),
                          links: nil)
    }
}
