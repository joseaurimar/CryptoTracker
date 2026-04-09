//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 09/04/26.
//

import SwiftUI

struct CoinDetailLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        print("Init: \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    CoinDetailView(coin: DeveloperPreview.instance.coin)
}
