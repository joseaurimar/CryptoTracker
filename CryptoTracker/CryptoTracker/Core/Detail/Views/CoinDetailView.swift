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
    
    @StateObject private var viewModel: CoinDetailViewModel
    //@State private var coinDetails: CoinDetail?
    
    private let coin: Coin
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        self.coin = coin
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                
                overviewTitle
                Divider()
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
                    ForEach(viewModel.overviewStatistics) { statistics in
                        StatisticView(statistic: statistics)
                    }
                }
                
                additionalTitle
                Divider()
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
                    ForEach(viewModel.additionalStatistics) { statistics in
                        StatisticView(statistic: statistics)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(coin.name)
        //.task {
        //    coinDetails = await viewModel.getCoinDetails(with: coin.id)
        //}
    }
}

extension CoinDetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        CoinDetailView(coin: DeveloperPreview.instance.coin)
    }
}
