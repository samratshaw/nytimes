//
//  HomePageViewControllerTests.swift
//  PG_NYTimes
//
//  Created by Samrat on 25/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest
@testable import PG_NYTimes


class HomePageViewControllerTests: XCTestCase {
    
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
        
        let successResult = Result.Success(HomePageViewControllerTests().getTestData())
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
    // MARK: - Properties
    /****************************/
    var viewController: HomePageViewController!
    
    /****************************/
    // MARK: - Setup & Teardown
    /****************************/
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! HomePageViewController
        
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
        
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
        XCTAssertEqual(0, (viewController.filterArray(articles , ForSearchText: "").count))
        
        XCTAssertEqual(0, (viewController.filterArray(articles, ForSearchText: "dummy").count))
        
        // Populate the array now
        articles = getTestData()
        
        XCTAssertEqual(0, (viewController.filterArray(articles, ForSearchText: "Test").count))
        
        XCTAssertEqual(1, (viewController.filterArray(articles, ForSearchText: "Manchester").count))
        
        XCTAssertEqual(1, (viewController.filterArray(articles, ForSearchText: "Oil").count))
        
        // Add similar items now
        articles += getTestData()
        
        /*
         Now we check for size & case sensitivity.
         */
        XCTAssertEqual(0, (viewController.filterArray(articles, ForSearchText: "dummy").count))
        
        XCTAssertEqual(2, (viewController.filterArray(articles, ForSearchText: "united").count))
        
        XCTAssertEqual(2, (viewController.filterArray(articles, ForSearchText: "Prices").count))
    }
    
    func testStoryBoardConnections() {
        XCTAssertNotNil(viewController.activityIndicator)
        XCTAssertNotNil(viewController.collectionView)
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.searchBar)
    }
    
    func testObjectInitializationOnLaunch() {
        XCTAssertNotNil(viewController.service)
        XCTAssertNotNil(viewController.lastSearchedItems)
        XCTAssertNotNil(viewController.articles)
        XCTAssertNotNil(viewController.arrFilteredArticles)
    }
    
    func testGetArticleForCollection() {
        
        viewController.articles = getTestData()
        viewController.isFiltered = false
        
        XCTAssert(viewController.articles.first! == viewController.getArticleForCollectionCellAtIndexPath(IndexPath(row: 0, section: 0)))
        XCTAssert(viewController.articles[1] == viewController.getArticleForCollectionCellAtIndexPath(IndexPath(row: 1, section: 0)))
        
        // Now check for filtered data
        viewController.isFiltered = true
        viewController.arrFilteredArticles = getTestFilteredData()
        
        XCTAssert(viewController.arrFilteredArticles[0] == viewController.getArticleForCollectionCellAtIndexPath(IndexPath(row: 0, section: 0)))
    }
    
    func testGetNewsArticlesForSuccess() {
        
        let mockNewsArticleService = MockNewsArticleService(forSuccess: true)
        // Before the service is called
        XCTAssertEqual(0, viewController.articles.count)
        XCTAssertFalse(viewController.isInitialDataLoaded)
        XCTAssertTrue(viewController.isTableViewHidden)
        
        // UI should be not displayed to user
        XCTAssertEqual(0, viewController.collectionView.numberOfSections)
        // Call the service
        viewController.getNewsArticles(fromService: mockNewsArticleService)
        
        
        // Check if service was called
        XCTAssertTrue(mockNewsArticleService.getWasCalled)
        
        // Check if the local variables were updated
        XCTAssertEqual(viewController.articles.count, getTestData().count)
        XCTAssertEqual(viewController.articles.first, getTestData().first)
        XCTAssertTrue(viewController.isInitialDataLoaded)
        
        // Data is displayed on screen
        XCTAssertEqual(1, viewController.collectionView.numberOfSections)
        XCTAssertEqual(getTestData().count, viewController.collectionView.numberOfItems(inSection: 0))
        
        // Call the service AGAIN
        viewController.getNewsArticles(fromService: mockNewsArticleService)
        // The total data should be appended
        XCTAssertEqual(viewController.articles.count, (getTestData().count * 2))
        XCTAssertEqual((getTestData().count * 2), viewController.collectionView.numberOfItems(inSection: 0))
    }
    
    func testGetNewsArticlesForFailure() {
        
        let mockNewsArticleService = MockNewsArticleService(forSuccess: false)
        // Before the service is called
        XCTAssertEqual(0, viewController.articles.count)
        XCTAssertFalse(viewController.isInitialDataLoaded)
        XCTAssertTrue(viewController.isTableViewHidden)
        
        // UI should be not displayed to user
        XCTAssertEqual(0, viewController.collectionView.numberOfSections)
        
        // Call the service
        viewController.getNewsArticles(fromService: mockNewsArticleService)
        
        
        // Check if service was called
        XCTAssertTrue(mockNewsArticleService.getWasCalled)
        
        // Check if the local variables were updated
        XCTAssertEqual(0, viewController.articles.count)
        XCTAssertFalse(viewController.isInitialDataLoaded)
        
        // Data is displayed on screen
        XCTAssertEqual(0, viewController.collectionView.numberOfSections)
    }
    
    func testRemoveSearchBarAsFirstResponderAndHideTableView() {
        viewController.searchBar.becomeFirstResponder()
        viewController.tableView.isHidden = false
        
        viewController.removeSearchBarAsFirstResponderAndHideTableView()
        
        XCTAssertFalse(viewController.searchBar.isFirstResponder)
        XCTAssertFalse(viewController.tableView.isHidden)
    }
    
    func testPerformSearchForText() {
        viewController.articles = getTestData()
        viewController.searchBar.becomeFirstResponder()
        viewController.tableView.isHidden = false
        
        viewController.performSearchForText("Increase in")
        
        XCTAssertEqual(viewController.arrFilteredArticles.count, 1)
        XCTAssertTrue(viewController.isFiltered)
        XCTAssertFalse(viewController.searchBar.isFirstResponder)
        XCTAssertFalse(viewController.tableView.isHidden)
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
