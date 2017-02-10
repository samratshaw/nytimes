//
//  NewsArticleServiceTests.swift
//  PG_NYTimes
//
//  Created by Samrat on 11/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest
@testable import PG_NYTimes

class NewsArticleServiceTests: XCTestCase {
    
    /****************************/
    // MARK: - Properties
    /****************************/
    var newsArticleService: NewsArticleService!
    
    /****************************/
    // MARK: - Setup & Teardown
    /****************************/
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        newsArticleService = NewsArticleService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /****************************/
    // MARK: - Tests
    /****************************/
    func testGetURLRequestForEmptyParameter() {
        
        let url = URLRequest(url: URL(string: Constants.URLs.GetArticles)!)
        XCTAssertNotNil(newsArticleService.getURLRequest(Dictionary<String, String>()))
        XCTAssertEqual(newsArticleService.getURLRequest(Dictionary<String, String>()), url)
    }
    
    func testGetURLRequestForOneParameter() {
        
        let key = "testKey"
        let value = "testValue"
        let updatedUrl = Constants.URLs.GetArticles + "&\(key)=\(value)"
        
        let url = URLRequest(url: URL(string: updatedUrl)!)
        
        XCTAssertNotNil(newsArticleService.getURLRequest([key:value]))
        XCTAssertEqual(newsArticleService.getURLRequest([key:value]), url)
    }
    
    func testGetURLRequestForMultipleParameters() {
        
        let key1 = "testKey1"
        let value1 = "testValue1"
        
        let key2 = "testKey2"
        let value2 = "testValue2"
        
        let updatedUrl = Constants.URLs.GetArticles + "&\(key1)=\(value1)" + "&\(key2)=\(value2)"
        
        let url = URLRequest(url: URL(string: updatedUrl)!)
        
        let parameters = [key1 : value1, key2 : value2]
        
        XCTAssertNotNil(newsArticleService.getURLRequest(parameters))
        XCTAssertEqual(newsArticleService.getURLRequest(parameters), url)
    }
    
    func testParseResponseForEmptyInput() {
        XCTAssertNotNil(newsArticleService.parseResponse([String:Any]()))
        XCTAssertEqual(0 , newsArticleService.parseResponse([String:Any]()).count)
    }
    
    func testParseResponseForInvalidInput() {
        
        let invalidResponse1 = ["Test" : ""]
        XCTAssertNotNil(newsArticleService.parseResponse(invalidResponse1))
        XCTAssertEqual(0 , newsArticleService.parseResponse(invalidResponse1).count)
        
        
        let invalidResponse2 = ["response" : "random"]
        XCTAssertNotNil(newsArticleService.parseResponse(invalidResponse2))
        XCTAssertEqual(0 , newsArticleService.parseResponse(invalidResponse2).count)
        
        
        let docsWithoutCorrectFormat = ["docs": ["Test"]]
        let invalidResponse3 = ["response" : docsWithoutCorrectFormat]
        XCTAssertNotNil(newsArticleService.parseResponse(invalidResponse3))
        XCTAssertEqual(0 , newsArticleService.parseResponse(invalidResponse3).count)
        
        
        let docsWithoutActualKeys = ["docs": ["testKey" : "testValue"]]
        let invalidResponse4 = ["response" : docsWithoutActualKeys]
        XCTAssertNotNil(newsArticleService.parseResponse(invalidResponse4))
        XCTAssertEqual(0 , newsArticleService.parseResponse(invalidResponse4).count)
    }
    
    func testParseResponseForSuccess() {
        let testDoc1 = getFirstTestDoc()
        let docs1 = ["docs" : [testDoc1]]
        let validResponse1 = ["response" : docs1]
        let article1 = NewsArticle.init(testDoc1)
        
        XCTAssertNotNil(newsArticleService.parseResponse(validResponse1))
        XCTAssertEqual(1 , newsArticleService.parseResponse(validResponse1).count)
        XCTAssertEqual(article1 , newsArticleService.parseResponse(validResponse1).first)
        
        let testDoc2 = getSecondTestDoc()
        let docs2 = ["docs" : [testDoc1, testDoc2]]
        let validResponse2 = ["response" : docs2]
        let article2 = NewsArticle.init(testDoc2)
        
        XCTAssertNotNil(newsArticleService.parseResponse(validResponse2))
        XCTAssertEqual(2 , newsArticleService.parseResponse(validResponse2).count)
        XCTAssertEqual(article2 , newsArticleService.parseResponse(validResponse2).last)
    }
    
    func testGetWithParameters() {
        let testExpectation = expectation(description: "Wait for service to load.")
        var articles: [NewsArticle]?
        newsArticleService.getWithParameters([Constants.RequestParameters.Page : "0"]) { (result) in
            switch result {
            case .Success(let newsArticles):
                articles = newsArticles
            default: break   
            }
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(articles)
        XCTAssertEqual(10, articles!.count)
    }
    
    /****************************/
    // MARK: - Helpers
    /****************************/
    
    func getFirstTestDoc() -> [String:Any] {
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        
        return doc1
    }
    
    func getSecondTestDoc() -> [String:Any] {
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Wayne Rooney scored a hattrick"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "4124142cnd4211"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Manchester United came from behind to score against.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-02-07T07:42:04+0000"
        
        return doc1
    }
}
