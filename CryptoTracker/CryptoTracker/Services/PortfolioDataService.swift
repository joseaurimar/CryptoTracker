//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 06/04/26.
//

import Foundation
import SwiftData

@MainActor
final class PortfolioDataService {
    private let container: ModelContainer?
    private let context: ModelContext?
    
    init(container: ModelContainer?, context: ModelContext?) {
        self.container = container
        self.context = context
    }
    
    func insert(_ entity: Portfolio) {
        self.container?.mainContext.insert(entity)
        try? self.container?.mainContext.save()
    }

    func delete(_ entity: Portfolio) {
        self.container?.mainContext.delete(entity)
        try? self.container?.mainContext.save()
    }
    
    func fetchPortfolioCoins() -> [Portfolio] {
        let fetchDescriptor = FetchDescriptor<Portfolio>(sortBy: [SortDescriptor(\.coinID, order: .forward)])
        let portfolioCoins = try? self.container?.mainContext.fetch(fetchDescriptor)
        return portfolioCoins ?? []
    }
}
