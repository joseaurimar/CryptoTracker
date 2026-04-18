//
//  HomeViewModelTests.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 17/04/26.
//

import XCTest
import Combine
@testable import CryptoTracker

final class HomeViewModelTests: XCTestCase {
    private var service: PortfolioDataService!
    private var viewModel: HomeViewModel!
    private var mockService: MockCoinDataService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        let swiftDataContextManager = MockSwiftDataContextManager()
        let container = swiftDataContextManager.container
        let context = swiftDataContextManager.context
        
        service = PortfolioDataService(container: container, context: context)
        mockService = MockCoinDataService()
        viewModel = HomeViewModel(with: service, coinService: mockService)
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    @MainActor
    func testGetCoinsWithSuccess() async {
        
        // Start listening to updates asynchronously
        let itemsTask = Task {
            // .values converts the publisher to an AsyncSequence
            // .dropFirst() ignores the initial empty array
            for await items in viewModel.$allCoins.dropFirst().values {
                return items
            }
            return []
        }
        
        // Await the result from our task and assert
        let coins = await itemsTask.value
        XCTAssertEqual(coins.count, 1)
        XCTAssertEqual(coins.first?.name, "Bitcoin")
    }
    
    func testPortfolioListShouldBeEmptyOnInit() {
        XCTAssertEqual(viewModel.portfolioCoins.count, 0)
    }
    
    @MainActor
    func testPortfolioListShouldNotBeEmptyAfterInsertCoinInPortfolio() async {
        service?.insert(Portfolio(coinID: "bitcoin", amount: 1.0))
        
        let itemsTask = Task {
            for await items in viewModel.$portfolioCoins.dropFirst().values {
                return items
            }
            return []
        }
        
        let portfolio = await itemsTask.value
        XCTAssertTrue(!portfolio.isEmpty)
    }
    
    @MainActor
    func testStatisticsShouldNotBeEmptyAfterInit() async {
        
        // Start listening to updates asynchronously
        let itemsTask = Task {
            // .values converts the publisher to an AsyncSequence
            // .dropFirst() ignores the initial empty array
            for await items in viewModel.$statistics.dropFirst().values {
                return items
            }
            return []
        }
        
        // Await the result from our task and assert
        let statistics = await itemsTask.value
        XCTAssertTrue(!statistics.isEmpty)
    }
    
    @MainActor
    func testGetPortfolioWithSuccess() {
        let portfolio = Portfolio(coinID: "bitcoin", amount: 1.0)
        service?.insert(portfolio)
        
        XCTAssertEqual(viewModel.getPortfolio(coin: DeveloperPreview.instance.coin)?.coinID, portfolio.coinID)
    }
    
    func testGetPortfolioReturningNil() {
        XCTAssertNil(viewModel.getPortfolio(coin: DeveloperPreview.instance.coin))
    }
}
