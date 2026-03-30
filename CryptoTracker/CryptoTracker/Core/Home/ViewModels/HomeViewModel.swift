//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 29/03/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.allCoins.append(DeveloperPreview.instance.coin)
            self?.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
}
