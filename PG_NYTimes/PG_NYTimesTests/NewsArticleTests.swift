//
//  NewsArticleTests.swift
//  PG_NYTimes
//
//  Created by Samrat on 29/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import XCTest
@testable import PG_NYTimes

class NewsArticleTests: XCTestCase {
    
    /****************************/
    // MARK: - Setup & Teardown
    /****************************/
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /****************************/
    // MARK: - Tests
    /****************************/
    
    func testInitializerSuccess() {
        // Create the object
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        let article1 = NewsArticle.init(doc1)
        
        // Now check if the values are correctly mapped
        XCTAssertNotNil(article1)
        XCTAssertEqual(article1?.headline, "Increase in oil prices")
        XCTAssertEqual(article1?.snippet, "Oil prices are increasing due to the high demand..")
        XCTAssertEqual(article1?.id, "12345678900ae512")
        XCTAssertEqual(article1?.webUrl, "https://nytimes.com/")
        XCTAssertEqual(article1?.imageUrl, Constants.URLs.ImageBaseURL + "nus/api/v1.json")
        XCTAssertEqual(article1?.publicationDate, "Jan 25, 2017")
    }
    
    func testInitializerFailure() {
        // Pass an empty dictionary
        let article = NewsArticle.init([String:Any]())
        
        XCTAssertNil(article)
    }
    
    func testDateIncorrectFormat() {
        // Create the object
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25+0000"
        let article1 = NewsArticle.init(doc1)
        
        // Now check if the values are correctly mapped
        XCTAssertNotNil(article1)
        XCTAssertEqual(article1?.publicationDate, "")
    }
    
    func testMultimediaIncorrectFormat() {
        // Create the object
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25+0000"
        
        // No image present
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = []
        
        
        let article1 = NewsArticle.init(doc1)
        
        // Now check if the values are correctly mapped
        XCTAssertNotNil(article1)
        XCTAssertEqual(article1?.publicationDate, "")
        
    }
    
    func testEquatableSuccessScenario() {
        // Create the object
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        
        let article1 = NewsArticle.init(doc1)
        let article2 = NewsArticle.init(doc1)
        
        // Now check if the values are correctly mapped
        XCTAssertNotNil(article1)
        XCTAssert(article1 == article2)
    }
    
    func testEquatableFailedScenario() {
        // Create the objects
        let headline1 = [Constants.ResponseParameters.GetArticlesHeadlineMain : "Increase in oil prices"]
        
        let imageUrl1 = [Constants.ResponseParameters.GetArticlesMultimediaUrl : "nus/api/v1.json"]
        
        var doc1: [String:Any] = [:]
        doc1[Constants.ResponseParameters.GetArticlesId] = "12345678900ae512"
        doc1[Constants.ResponseParameters.GetArticlesSnippet] = "Oil prices are increasing due to the high demand.."
        doc1[Constants.ResponseParameters.GetArticlesWebUrl] = "https://nytimes.com/"
        doc1[Constants.ResponseParameters.GetArticlesHeadline] = headline1
        doc1[Constants.ResponseParameters.GetArticlesMultimedia] = [imageUrl1]
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-01-25T09:51:34+0000"
        
        let article1 = NewsArticle.init(doc1)
        
        // Second object
        doc1[Constants.ResponseParameters.GetArticlesPublicationDate] = "2017-02-28T09:51:34+0000"
        let article2 = NewsArticle.init(doc1)
        
        // Now check if the values are correctly mapped
        XCTAssertNotNil(article1)
        XCTAssertNotEqual(article1, article2)
    }
}
