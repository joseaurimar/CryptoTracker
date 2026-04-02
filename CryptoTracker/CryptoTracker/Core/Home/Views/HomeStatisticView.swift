//
//  HomeStatisticView.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 02/04/26.
//

import SwiftUI

struct HomeStatisticView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(viewModel.statistics) { statistic in
                    StatisticView(statistic: statistic)
                        .frame(width: geometry.size.width / 3)
                }
            }
            .frame(width: geometry.size.width,
                   alignment: showPortfolio ? .trailing : .leading)
        }
    }
}

#Preview {
    HomeStatisticView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}
