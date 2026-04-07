//
//  PortfolioDataServiceTests.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 07/04/26.
//

import XCTest
@testable import CryptoTracker

final class PortfolioDataServiceTests: XCTestCase {
    private var service: PortfolioDataService?
    
    @MainActor
    override func setUp() async throws {
        let swiftDataContextManager = MockSwiftDataContextManager()
        let container = swiftDataContextManager.container
        let context = swiftDataContextManager.context
        
        service = PortfolioDataService(container: container, context: context)
    }
    
    override func tearDown() async throws {
        service = nil
    }
    
    @MainActor
    func testInsertPortfolio() async {
        var portfolioCoins: [Portfolio] = []
        
        // Check if portfolio is empty
        portfolioCoins = service?.fetchPortfolioCoins() ?? []
        XCTAssertEqual([], portfolioCoins)
        
        let portfolio = Portfolio(coinID: "bitcoin", amount: 1.0)
        service?.insert(portfolio)
        
        // Check if portfolio is inserted
        portfolioCoins = service?.fetchPortfolioCoins() ?? []
        XCTAssertEqual(portfolio, portfolioCoins[0])
    }
}
