//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 09/04/26.
//

import Foundation

actor CoinDetailDataService {
    
    @MainActor
    func getCoinDetails(with id: String) async throws -> CoinDetail {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.badURLResponse(url: url) // Handle non-200 status codes
        }
        
        return try JSONDecoder().decode(CoinDetail.self, from: data)
    }
}
