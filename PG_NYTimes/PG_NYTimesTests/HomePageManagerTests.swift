//
//  HomePageManagerTests.swift
//  PG_NYTimes
//
//  Created by Samrat on 10/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest
@testable import PG_NYTimes

class HomePageManagerControllerTests: XCTestCase {
    
    /****************************/
    // MARK: - Properties
    /****************************/
    var manager: HomePageManager!
    
    /****************************/
    // MARK: - Mocked Service Class
    /****************************/
    class MockNewsArticleService: Gettable {
        
        enum MockError: Error {
            case NoInternetConnection
        }
        
        let successScenario: Bool
        
        // Initializer
        init(forSuccess successScenario: Bool) {
            self.successScenario = successScenario
        }
        
        var getWasCalled = false
        
        let successResult = Result.Success(HomePageManagerControllerTests().getTestData())
        let failureResult = Result<[NewsArticle]>.Failure(MockError.NoInternetConnection)
        
        func getWithParameters(_ parameters: Dictionary<String, String>, completionHandler: @escaping (Result<[NewsArticle]>) -> Void) {
            
            getWasCalled = true
            
            if successScenario {
                completionHandler(successResult)
            } else {
                completionHandler(failureResult)
            }
        }
    }
    
    /****************************/
    // MARK: - Setup & Teardown
    /****************************/
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = HomePageManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /****************************/
    // MARK: - Tests
    /****************************/
    
    func testFilterArray() {
        // Declare the array
        var articles: [NewsArticle] = []
        // Empty array
        XCTAssertEqual(0, (manager.filterArray(articles , ForSearchText: "").count))
        
        XCTAssertEqual(0, (manager.filterArray(articles, ForSearchText: "dummy").count))
        
        // Populate the array now
        articles = getTestData()
        
        XCTAssertEqual(0, (manager.filterArray(articles, ForSearchText: "Test").count))
        
        XCTAssertEqual(1, (manager.filterArray(articles, ForSearchText: "Manchester").count))
        
        XCTAssertEqual(1, (manager.filterArray(articles, ForSearchText: "Oil").count))
        
        // Add similar items now
        articles += getTestData()
        
        /*
         Now we check for size & case sensitivity.
         */
        XCTAssertEqual(0, (manager.filterArray(articles, ForSearchText: "dummy").count))
        
        XCTAssertEqual(2, (manager.filterArray(articles, ForSearchText: "united").count))
        
        XCTAssertEqual(2, (manager.filterArray(articles, ForSearchText: "Prices").count))
    }
    
    func testObjectInitializationOnLaunch() {
        XCTAssertNotNil(manager.service)
        XCTAssertNotNil(manager.lastSearchedItems)
        XCTAssertNotNil(manager.articles)
        XCTAssertNotNil(manager.filteredArticles)
    }
    
    func testFetchNewsArticlesForSuccess() {
        
        let mockNewsArticleService = MockNewsArticleService(forSuccess: true)
        // Before the service is called
        XCTAssertEqual(0, manager.articles.count)
        
        // Call the service
        manager.getNewsArticles(fromService: mockNewsArticleService) { [weak self] (result) in
            switch result {
            case .Success(let newsArticles):
                XCTAssertNotNil(newsArticles)
                XCTAssertEqual(newsArticles.first, (self?.getTestData())!.first)
                XCTAssertEqual(newsArticles.count, self?.getTestData().count)
            case .Failure( _):
                XCTFail("Error scenario received for success call.")
            }
        }
        
        // Check if service was called
        XCTAssertTrue(mockNewsArticleService.getWasCalled)
    }
    
    func testFetchNewsArticlesForFailure() {
        
        let mockNewsArticleService = MockNewsArticleService(forSuccess: false)
        // Before the service is called
        XCTAssertEqual(0, manager.articles.count)
        
        // Call the service
        manager.getNewsArticles(fromService: mockNewsArticleService) { (result) in
            switch result {
            case .Success( _):
                XCTFail("Success scenario received for error mock call.")
            case .Failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        // Check if service was called
        XCTAssertTrue(mockNewsArticleService.getWasCalled)
    }
    
    func testGetArticlesToDisplay() {
        manager.articles = getTestData()
        manager.filteredArticles = getTestFilteredData()
        
        // Initial scenario
        XCTAssertFalse(manager.isFiltered)
        
        XCTAssertNotNil(manager.getArticlesToDisplay())
        XCTAssertEqual(getTestData(), manager.getArticlesToDisplay())
        XCTAssertEqual(getTestData().count, manager.getArticlesToDisplay().count)
        
        // Set the flag
        manager.isFiltered = true
        
        XCTAssertTrue(manager.isFiltered)
        
        XCTAssertNotNil(manager.getArticlesToDisplay())
        XCTAssertEqual(getTestFilteredData(), manager.getArticlesToDisplay())
        XCTAssertEqual(getTestFilteredData().count, manager.getArticlesToDisplay().count)
    }
    
    func testPerformSearchForText() {
        
        // Initial scenario
        XCTAssertFalse(manager.isFiltered)
        XCTAssertEqual(0, manager.getLastSearchedItems().count)
        
        manager.articles = getTestData()
        
        XCTAssertEqual(0, manager.filteredArticles.count)
        
        manager.performSearchForText("Manchester", AndRememberText: false)
        
        XCTAssertTrue(manager.isFiltered)
        XCTAssertNotNil(manager.getArticlesToDisplay())
        XCTAssertEqual(0, manager.getLastSearchedItems().count)
        XCTAssertEqual(1, manager.getArticlesToDisplay().count)
        
        manager.performSearchForText("Manchester", AndRememberText: true)
        
        XCTAssertTrue(manager.isFiltered)
        XCTAssertNotNil(manager.getArticlesToDisplay())
        XCTAssertEqual(1, manager.getLastSearchedItems().count)
        XCTAssertEqual("Manchester", manager.getLastSearchedItems().first)
        
        manager.performSearchForText("Oil", AndRememberText: true)
        XCTAssertEqual(getTestData().first, manager.getArticlesToDisplay().first)
        XCTAssertEqual(2, manager.getLastSearchedItems().count)
        XCTAssertEqual("Oil", manager.getLastSearchedItems().first)
    }
    
    /****************************/
    // MARK: - Private Methods
    /****************************/
    func getTestData() -> [NewsArticle] {
        
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let headline2 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Manchester United planning to increase the stadium size to 88000"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        let imageUrl2 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v2.json"]
        
        // Article 1
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        let article1 = NewsArticle.init(doc1)
        
        
        // Article 2
        var doc2: [String:Any] = [:]
        doc2[Constants.ResponseParameters.GetArticlesId] = "142091818490te11"
        doc2[Constants.ResponseParameters.GetArticlesSnippet] = "Manchester United have been granted the permission by FA to increase their stadium size from current 75000 to 88000."
        doc2[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/manchester_united"
        doc2[Constants.ResponseParameters.GetArticlesHeadline] = headline2
        doc2[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl2]
        doc2[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        let article2 = NewsArticle.init(doc2)
        
        return [article1!, article2!]
    }
    
    func getTestFilteredData() -> [NewsArticle] {
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Obama serves his last day at office."]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        // Article 1
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "14612678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "President Obama is servign his last day at office. Lets have a look.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-27T09:51:34+0000"
        let article1 = NewsArticle.init(doc1)
        
        return [article1!]
    }
}
