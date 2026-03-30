//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 30/03/26.
//

import Foundation

actor CoinDataService {
    
    init() {}
    
    func getCoins() async throws -> [Coin] {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=brl&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.badURLResponse(url: url) // Handle non-200 status codes
        }
        
        return try JSONDecoder().decode([Coin].self, from: data)
    }
}
