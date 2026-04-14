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
    @State private var showFullDescription = false
    
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
                    
                    description
                    
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
                    
                    links
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
            .sharedBackgroundVisibility(.hidden)
        }
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
        Text("additional_details")
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
    
    private var description: some View {
        ZStack {
            if let description = viewModel.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .lineLimit(showFullDescription ? nil : 3)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "less" : "Read more...")
                            .font(.caption)
                            .foregroundStyle(Color.blue)
                            .bold()
                            .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var links: some View {
        HStack {
            if let websiteURLString = viewModel.websiteURL, let url = URL(string: websiteURLString) {
                Link("Website", destination: url)
            }
            
            Spacer()
            
            if let redditURLString = viewModel.redditURL, let url = URL(string: redditURLString) {
                Link("Reddit", destination: url)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
        .foregroundStyle(Color.blue)
    }
}

#Preview {
    NavigationView {
        CoinDetailView(coin: DeveloperPreview.instance.coin)
    }
}
