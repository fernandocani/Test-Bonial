//
//  BonialTests.swift
//  BonialTests
//
//  Created by Fernando Cani on 08/07/2024.
//

import XCTest
@testable import Bonial

final class BonialTests: XCTestCase {

    var viewModel: NewsViewModel!
    var mockService: ServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = ServiceMock.shared
        viewModel = NewsViewModel(mockService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    func testInitialLoad() async throws {
        // Given
        XCTAssertEqual(viewModel.news.count, 0, "Initially, news array should be empty")
        
        // When
        try await viewModel.loadMoreNews()
        
        // Then
        XCTAssertEqual(viewModel.news.count, 13, "After initial load, news array should contain 13 items")
    }
    
    func testPagination() async throws {
        // Given
        try await viewModel.loadMoreNews()
        XCTAssertEqual(viewModel.news.count, 13, "After initial load, news array should contain 13 items")
        
        // When
        try await viewModel.loadMoreNews()
        
        // Then
        XCTAssertEqual(viewModel.news.count, 27, "After loading next page, news array should contain 27 items")
    }
    
    func testSwitchService() async throws {
        // Given
        try await viewModel.loadMoreNews()
        XCTAssertEqual(viewModel.news.count, 13, "After initial load, news array should contain 13 items")
        
        // When
        viewModel.changeService(service: ServiceLive.shared)
        XCTAssertEqual(viewModel.news.count, 0, "After switching service, news array should be reset")
    }
    
    func testServiceMockDataLoading() async throws {
        let serviceMock = ServiceMock.shared
        let news = try await serviceMock.getNews(page: 1)
        XCTAssertEqual(news.count, 15, "ServiceMock should load 15 items for the first page")
    }
    
}
