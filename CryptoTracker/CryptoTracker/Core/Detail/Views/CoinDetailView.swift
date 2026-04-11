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
        ScrollView(showsIndicators: false) {
            
            VStack {
                ChartView(coin: coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    
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
        }
        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
            .sharedBackgroundVisibility(.hidden)
        }
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
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: coin)
                .frame(width: 25, height: 25)
        }
    }
}

#Preview {
    NavigationView {
        CoinDetailView(coin: DeveloperPreview.instance.coin)
    }
}
