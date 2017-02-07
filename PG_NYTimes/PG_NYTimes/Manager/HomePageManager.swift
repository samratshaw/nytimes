//
//  HomePageManager.swift
//  PG_NYTimes
//
//  Created by Samrat on 7/2/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * This class contains the various business logic attached to the HomePageViewController.
 */
class HomePageManager {
    
    /****************************/
    // MARK: - Properties
    /****************************/
    
    // The service class attached with this controller
    internal var service: NewsArticleService = NewsArticleService()
    
    // Array for keeping track of the last searched items
    internal var lastSearchedItems: Array<String> = []
    
    // Array containing the articles
    internal var articles: Array<NewsArticle> = []
    
    // The array containing the filtered results
    internal var filteredArticles: Array<NewsArticle> = []
    
    // Keep track whether the datasource is filtered or not.
    var isFiltered: Bool = false
    
    // The page that was last loaded
    var pageNumber: CUnsignedShort = 0
    
    /****************************/
    // MARK: - Public Methods
    /****************************/
    
    /**
     * Method to get the list of article that needs to be displayed.
     */
    func getArticlesToDisplay() -> [NewsArticle] {
        return isFiltered ? filteredArticles : articles
    }
    
    /**
     * Method to get the items that the user had last searched.
     */
    func getLastSearchedItems() -> [String] {
        return lastSearchedItems
    }
    
    /**
     * Method to fetch new articles from the web service.
     */
    func fetchNewsArticles(_ completionHandler:@escaping (Result<[NewsArticle]>) -> Void) {
        return getNewsArticles(fromService: service, completionHandler: completionHandler)
    }
    
    /**
     * Method to perform a search on the existing articles.
     * This method will update the "isFiltered" flag & update the array containing lis of filtered articles.
     */
    func performSearchForText(_ searchText: String, AndRememberText rememberText: Bool) {
        isFiltered = true
        filteredArticles = filterArray(articles, ForSearchText: searchText)
        
        if rememberText {
            lastSearchedItems.insert(searchText, at: 0)
        }
    }
}

extension HomePageManager {
    /**
     * Method to call the web service to get news articles. This method will show the activity indicator, call the web sevice & then update the model.
     */
    func getNewsArticles<Service: Gettable>(fromService service: Service, completionHandler:@escaping (Result<[NewsArticle]>) -> Void) where Service.AssociatedData == [NewsArticle] {
        
        service.getWithParameters([Constants.RequestParameters.Page : String(pageNumber)]) { [weak self] result in
            switch result {
            case .Success(let newsArticles):
                self?.articles += newsArticles
                // TODO: Make the page number an object
                self?.pageNumber += 1
                completionHandler(Result.Success(self!.articles))
                
            case .Failure(let error):
                // TODO: - Handle the error scenario
                completionHandler(Result.Failure(error))
            }
        }
    }
    
    
    /**
     * Method to filter the array based on the search text.
     * It filters based on "headline" property of the article.
     */
    func filterArray(_ array:[NewsArticle], ForSearchText searchText: String) -> [NewsArticle] {
        return array.filter { (article) -> Bool in
            return article.headline.localizedCaseInsensitiveContains(searchText)
        }
    }
    
}
