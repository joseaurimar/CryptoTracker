//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 27/03/26.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            leftColumn
            Spacer()
            
            if showHoldingsColumn {
                centerColumn
                Spacer()
            }
            
            rightColumn
        }
        .font(.subheadline)
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asCurrencyWith6Decimals())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingsColumn: true)
        .frame(height: 50)
}

/*
 struct CoinRowView_Previews: PreviewProvider {
     static var previews: some View {
         CoinRowView(coin: dev.coin)
     }
 }
 */
