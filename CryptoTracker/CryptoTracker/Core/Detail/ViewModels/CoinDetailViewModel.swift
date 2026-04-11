//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 09/04/26.
//

import Foundation
import Combine

final class CoinDetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDataService = CoinDetailDataService()
    private let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        makeOverviewStatistics()
        
        Task {
            await getCoinDetails()
        }
    }
    
    func getCoinDetails() async {
        do {
            let details = try await coinDetailDataService.getCoinDetails(with: coin.id)
            await makeAdditionalStatistics(coinDetail: details)
            coinDescription = details.readableDescription
            websiteURL = details.links?.homepage?.first
            redditURL = details.links?.subredditURL
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func makeOverviewStatistics() {
        overviewStatistics = [
            Statistic(title: "Current Price",
                      value: coin.currentPrice.asCurrencyWith6Decimals(),
                      percentageChange: coin.priceChangePercentage24H),
            Statistic(title: "Market Capitalizatioin",
                      value: "$ \(coin.marketCap?.formattedWithAbbreviations() ?? "")",
                      percentageChange: coin.marketCapChangePercentage24H),
            Statistic(title: "Rank", value: "\(coin.rank)"),
            Statistic(title: "Volume", value: "$ \(coin.totalVolume?.formattedWithAbbreviations() ?? "")")
        ]
    }
    
    private func makeAdditionalStatistics(coinDetail: CoinDetail) async {
        
        let blockTime = coinDetail.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        
        additionalStatistics = [
            Statistic(title: "24h High", value: coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"),
            Statistic(title: "24h Low", value: coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"),
            Statistic(title: "24h Price Change",
                      value: coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a",
                      percentageChange: coin.priceChangePercentage24H),
            Statistic(title: "24h Market Cap Change",
                      value: "$ \(coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")",
                      percentageChange: coin.marketCapChangePercentage24H),
            Statistic(title: "Block Time", value: blockTimeString),
            Statistic(title: "Hashing Algorithm", value: coinDetail.hashingAlgorithm ?? "n/a")
        ]
    }
}
