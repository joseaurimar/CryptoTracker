//
//  CoinImageViewModelTests.swift
//  CryptoTracker
//
//  Created by José Aurimar Sepka Junior on 30/04/26.
//

import XCTest
import Combine
@testable import CryptoTracker

@MainActor
final class CoinImageViewModelTests: XCTestCase {
    private var mockCoinDataService: MockCoinDataService!
    private var mockFileManager: MockLocalFileManager!
    private var viewModel: CoinImageViewModel!
    private var coin: Coin!
    
    override func setUp() {
        super.setUp()
        mockCoinDataService = MockCoinDataService()
        mockFileManager = MockLocalFileManager()
        coin = DeveloperPreview.instance.coin
        viewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
    }
    
    override func tearDown() {
        mockCoinDataService = nil
        mockFileManager = nil
        viewModel = nil
        coin = nil
        super.tearDown()
    }
    
    // MARK: - Tests for isLoading
    
    func testIsLoadingShouldBeTrueOnInit() {
        // When creating a new viewModel, isLoading should start as true
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // Then
        XCTAssertTrue(newViewModel.isLoading)
    }
    
    func testIsLoadingShouldBecomeFalseAfterImageLoad() async {
        // 1. Capture the stream of isLoading values
        let loadingStates = viewModel.$isLoading
            .dropFirst() // Skip initial true value
            .values
        
        // 2. Await for isLoading to become false
        let isNotLoading = await loadingStates.first { $0 == false }
        
        // 3. Assert
        XCTAssertNotNil(isNotLoading)
        XCTAssertEqual(viewModel.isLoading, false)
    }
    
    // MARK: - Tests for downloading image
    
    func testDownloadImageFromNetwork() async {
        // 1. Ensure no local image is available
        await mockFileManager.setShouldReturnImage(false)
        
        // 2. Create new viewModel to trigger download
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // 3. Capture the stream of image values
        let images = newViewModel.$image
            .dropFirst() // Skip initial nil
            .values
        
        // 4. Await for image to be downloaded
        let downloadedImage = await images.first { $0 != nil }
        
        // 5. Assert
        XCTAssertNotNil(downloadedImage)
    }
    
    func testLoadImageFromLocalStorage() async {
        // 1. Configure mock to return a local image
        await mockFileManager.setShouldReturnImage(true)
        
        // 2. Create new viewModel
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // 3. Capture the stream of image values
        let images = newViewModel.$image
            .dropFirst() // Skip initial nil
            .values
        
        // 4. Await for image to be loaded from local
        let localImage = await images.first { $0 != nil }
        
        // 5. Assert
        XCTAssertNotNil(localImage)
    }
    
    func testDownloadImageShouldHandleError() async {
        // 1. Configure mock to throw error
        await mockCoinDataService.setShouldThrowError(true)
        
        // 2. Create new viewModel to trigger download with error
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // 3. Wait for async work to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // 4. Assert image remains nil after error
        XCTAssertNil(newViewModel.image)
        XCTAssertEqual(newViewModel.isLoading, false)
    }
    
    // MARK: - Tests for image property
    
    func testImageShouldBeNilOnInit() {
        // When creating a new viewModel, image should start as nil
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // Then
        XCTAssertNil(newViewModel.image)
    }
    
    func testImageShouldUpdateAfterSuccessfulDownload() async {
        // 1. Capture the stream of image values
        let images = viewModel.$image
            .dropFirst() // Skip initial nil
            .values
        
        // 2. Await for image to be set
        let updatedImage = await images.first { $0 != nil }
        
        // 3. Assert
        XCTAssertNotNil(updatedImage)
        XCTAssertNotNil(viewModel.image)
    }
    
    func testImageShouldSaveToLocalStorageAfterDownload() async {
        // 1. Ensure no local image initially
        await mockFileManager.setShouldReturnImage(false)
        
        // 2. Create new viewModel to trigger download
        let newViewModel = CoinImageViewModel(
            coin: coin,
            coinDataService: mockCoinDataService,
            fileManager: mockFileManager
        )
        
        // 3. Wait for download and save to complete
        let images = newViewModel.$image
            .dropFirst()
            .values
        
        _ = await images.first { $0 != nil }
        
        // 4. Wait a bit for save operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // 5. Verify image was saved to mock file manager
        let key = "coin_images/\(coin.id)"
        let savedImage = await mockFileManager.storedImages[key]
        XCTAssertNotNil(savedImage)
    }
}
