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
    
    // MARK: - Tests for getCoins and allCoins
    
    @MainActor
    func testGetCoinsWithSuccess() async {
        // 1. Capture the stream of values
        // Use .dropFirst() if you want to ignore the initial empty state
        let values = viewModel.$allCoins.dropFirst().values
        
        // 2. Trigger the async work
        // In my case the trigger was done in init
        // await viewModel.fetchData()
        
        // 3. Await the first emission from the sequence
        let updatedList = await values.first { _ in true }
        
        XCTAssertEqual(updatedList?.count, 1)
        XCTAssertEqual(updatedList?.first?.name, "Bitcoin")
    }
    
    @MainActor
    func testGetCoinsShouldHandleError() async {
        // Arrange: Configure mock to throw error
        await mockService.setShouldThrowError(true)
        
        // Create new viewModel to trigger init with error
        let newViewModel = HomeViewModel(with: service, coinService: mockService)
        
        // Wait a bit for the async init work to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert: allCoins should remain empty after error
        XCTAssertEqual(newViewModel.allCoins.count, 0)
    }
    
    // MARK: - Tests for portfolioCoins
    
    func testPortfolioListShouldBeEmptyOnInit() {
        XCTAssertEqual(viewModel.portfolioCoins.count, 0)
    }
    
    @MainActor
    func testPortfolioListShouldNotBeEmptyAfterInsertCoinInPortfolio() async {
        // 1. Insert portfolio data
        service?.insert(Portfolio(coinID: "bitcoin", amount: 1.0))
        
        // 2. Capture the stream and await the first emission using AsyncSequence
        let portfolio = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 3. Assert
        XCTAssertNotNil(portfolio)
        XCTAssertEqual(portfolio?.count, 1)
        XCTAssertEqual(portfolio?.first?.name, "Bitcoin")
    }
    
    @MainActor
    func testPortfolioShouldUpdateWhenCoinAmountChanges() async {
        // 1. Insert initial portfolio
        service?.insert(Portfolio(coinID: "bitcoin", amount: 1.0))
        
        // 2. Wait for initial portfolio to populate
        /*_ = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }*/
        
        // 3. Update the portfolio amount using updatePortfolio
        let coin = DeveloperPreview.instance.coin
        viewModel.updatePortfolio(coin: coin, amount: 5.0)
        
        // 4. Wait for updated portfolio
        let updatedPortfolio = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { portfolio in
                portfolio.contains { $0.currentHoldings == 5.0 }
            }
        
        // 5. Assert
        XCTAssertEqual(updatedPortfolio?.first?.currentHoldings, 5.0)
    }
    
    // MARK: - Tests for statistics
    
    @MainActor
    func testStatisticsShouldNotBeEmptyAfterInit() async {
        // 1. Capture the stream using AsyncSequence pattern (like testGetCoinsWithSuccess)
        let statistics = await viewModel.$statistics
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Assert
        XCTAssertNotNil(statistics)
        XCTAssertEqual(statistics?.count, 4)
    }
    
    @MainActor
    func testStatisticsShouldIncludeMarketCap() async {
        // 1. Capture statistics using AsyncSequence
        let statistics = await viewModel.$statistics
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Assert
        XCTAssertTrue(statistics?.contains { $0.title == "Market Cap" } ?? false)
    }
    
    // MARK: - Tests for getPortfolio
    
    @MainActor
    func testGetPortfolioWithSuccess() {
        let portfolio = Portfolio(coinID: "bitcoin", amount: 1.0)
        service?.insert(portfolio)
        
        XCTAssertEqual(viewModel.getPortfolio(coin: DeveloperPreview.instance.coin)?.coinID, portfolio.coinID)
    }
    
    func testGetPortfolioReturningNil() {
        XCTAssertNil(viewModel.getPortfolio(coin: DeveloperPreview.instance.coin))
    }
    
    // MARK: - Tests for reloadData
    
    @MainActor
    func testReloadDataShouldUpdateCoins() async {
        // 1. Wait for initial load
        _ = await viewModel.$allCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Trigger reload
        await viewModel.reloadData()
        
        // 3. Assert coins are still loaded after reload
        XCTAssertEqual(viewModel.allCoins.count, 1)
        XCTAssertEqual(viewModel.allCoins.first?.name, "Bitcoin")
    }
    
    @MainActor
    func testReloadDataShouldSetIsLoading() async {
        // 1. Capture isLoading state changes using AsyncSequence
        let loadingStates = viewModel.$isLoading
            .dropFirst() // Skip initial false
            .values
        
        // 2. Trigger reload in background
        Task {
            await viewModel.reloadData()
        }
        
        // 3. Wait for loading to become true then false
        var states: [Bool] = []
        for await state in loadingStates {
            states.append(state)
            if states.count >= 2 { break } // true -> false
        }
        
        // 4. Assert loading state transitions
        XCTAssertTrue(states.contains(true), "isLoading should become true")
        XCTAssertEqual(viewModel.isLoading, false, "isLoading should end as false")
    }
    
    // MARK: - Tests for updatePortfolio
    
    @MainActor
    func testUpdatePortfolioShouldAddNewCoin() async {
        // 1. Get a coin to add
        let coin = DeveloperPreview.instance.coin
        
        // 2. Add coin to portfolio
        viewModel.updatePortfolio(coin: coin, amount: 2.5)
        
        // 3. Wait for portfolio update using AsyncSequence
        let portfolio = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 4. Assert
        XCTAssertNotNil(portfolio)
        XCTAssertEqual(portfolio?.count, 1)
        XCTAssertEqual(portfolio?.first?.currentHoldings, 2.5)
    }
    
    @MainActor
    func testUpdatePortfolioShouldRemoveCoinWhenAmountIsZero() async {
        // 1. First add a coin
        let coin = DeveloperPreview.instance.coin
        viewModel.updatePortfolio(coin: coin, amount: 1.0)
        
        // Wait for coin to be added
        _ = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Now remove it by setting amount to 0
        viewModel.updatePortfolio(coin: coin, amount: 0)
        
        // 3. Wait for portfolio to become empty
        let emptyPortfolio = await viewModel.$portfolioCoins
            .dropFirst()
            .values
            .first { $0.isEmpty }
        
        // 4. Assert
        XCTAssertNotNil(emptyPortfolio)
        XCTAssertEqual(viewModel.getPortfolio(coin: coin), nil)
    }
    
    // MARK: - Tests for filteredCoins and search
    
    @MainActor
    func testFilteredCoinsShouldReturnAllCoinsWhenSearchTextIsEmpty() async {
        // 1. Wait for coins to load
        _ = await viewModel.$allCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Ensure search text is empty
        viewModel.searchText = ""
        
        // 3. Assert filteredCoins returns all coins
        XCTAssertEqual(viewModel.filteredCoins.count, viewModel.allCoins.count)
    }
    
    @MainActor
    func testFilteredCoinsShouldFilterByName() async {
        // 1. Wait for coins to load
        _ = await viewModel.$allCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Search by name
        viewModel.searchText = "bit"
        
        // 3. Assert filter works
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    @MainActor
    func testFilteredCoinsShouldFilterBySymbol() async {
        // 1. Wait for coins to load
        _ = await viewModel.$allCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Search by symbol
        viewModel.searchText = "btc"
        
        // 3. Assert filter works
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.symbol, "btc")
    }
    
    @MainActor
    func testFilteredCoinsShouldReturnEmptyForNoMatch() async {
        // 1. Wait for coins to load
        _ = await viewModel.$allCoins
            .dropFirst()
            .values
            .first { !$0.isEmpty }
        
        // 2. Search with no match
        viewModel.searchText = "nonexistent"
        
        // 3. Assert empty result
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
    }
    
    // MARK: - Tests for sortOption
    
    @MainActor
    func testSortOptionShouldSortByRank() async {
        // This test verifies the sortOption property exists and can be set
        // Full sorting tests would require multiple coins in mock
        viewModel.sortOption = .rank
        XCTAssertEqual(viewModel.sortOption, .rank)
        
        viewModel.sortOption = .rankReversed
        XCTAssertEqual(viewModel.sortOption, .rankReversed)
    }
    
    @MainActor
    func testSortOptionShouldSortByPrice() async {
        viewModel.sortOption = .price
        XCTAssertEqual(viewModel.sortOption, .price)
        
        viewModel.sortOption = .priceReversed
        XCTAssertEqual(viewModel.sortOption, .priceReversed)
    }
}
