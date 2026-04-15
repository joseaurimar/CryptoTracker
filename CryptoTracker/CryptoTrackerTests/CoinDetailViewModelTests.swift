//
//  CoinDetailViewModelTests.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 14/04/26.
//

import XCTest
@testable import CryptoTracker

final class CoinDetailViewModelTests: XCTestCase {
    private var mockService: MockCoinDetailDataService!
    private var viewModel: CoinDetailViewModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockCoinDetailDataService()
        viewModel = CoinDetailViewModel(coin: DeveloperPreview.instance.coin, service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testGetCoinDetailsSuccess() async {
        // Given
        
        // When
        await viewModel.getCoinDetails()
        
        // Then
        XCTAssertEqual(viewModel.coinDescription, "english description")
    }
}
