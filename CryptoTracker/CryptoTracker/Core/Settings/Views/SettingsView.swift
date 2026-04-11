//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 11/04/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private var coingeckoURL = URL(string: "https://www.coingecko.com")!
    
    var body: some View {
        NavigationView {
            List {
                coingeckoSection
                applicationSection
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                        })
                }
            }
        }
    }
}

extension SettingsView {
    private var coingeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding()
            Link("Website", destination: coingeckoURL)
                .foregroundStyle(Color.blue)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: coingeckoURL)
                .foregroundStyle(Color.blue)
            Link("Privacy Police", destination: coingeckoURL)
                .foregroundStyle(Color.blue)
        }
    }
}

#Preview {
    SettingsView()
}
