//
//  NewsArticleService.swift
//  PG_NYTimes
//
//  Created by Samrat on 23/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct NewsArticleService: Gettable {
    // Set the associated datatype
    typealias AssociatedData = [NewsArticle]
    
    /****************************/
    // MARK: - Protocol Implementation
    /****************************/
    func getWithParameters(_ parameters: Dictionary<String, String>, completionHandler: @escaping (Result<AssociatedData>) -> Void) {
        
        // Get the request
        let request = getURLRequest(parameters)
        
        // Call the service
        dataTask(request: request, method: HTTPMethod.GET.rawValue) { (data, response, error) in
            // Make sure that there is no error.
            guard error == nil else {
                completionHandler(Result.Failure(error!))
                return
            }
            // Check if data is not nil
            guard let data = data else {
                // TODO: - Handle this error scenario
                completionHandler(Result.Success(Array<NewsArticle>()))
                return
            }
            
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                completionHandler(Result.Success(self.parseResponse(parsedData)))
            } catch let error as NSError {
                // TODO: - Handle this error scenario
                print(error)
                completionHandler(Result.Success(Array<NewsArticle>()))
            }
        }
    }
}
/****************************/
// MARK: - Helpers
/****************************/
extension NewsArticleService {
    /**
     * Method to parse the data to models.
     * Returns an array containing NewsArticle models.
     */
    func parseResponse(_ response: [String:Any]) -> [NewsArticle] {
        let response = (response["response"] as? [String:Any])
        let docs = response?["docs"] as? Array<[String:Any]>

        var arrArticles = [NewsArticle]()
        // Now loop throught the array & create the models
        for dict in docs! {
            
            if let article = NewsArticle.init(dict) {
                // Only added if the article is not nil
                arrArticles.append(article)
            }
        }
        return arrArticles
    }
    
    /**
     * Method to get the URLRequest for getting the news articles.
     */
    func getURLRequest(_ parameters: Dictionary<String, String>) -> URLRequest {
        // URL for the request
        var url = Constants.URLs.GetArticles
        
        // Parse the dictionary to get the parameters
        for (key,value) in parameters {
            url += "&\(key)=\(value)"
        }
        // Create the request
        return URLRequest(url: URL(string: url)!)
    }
    
    /**
     * Method to call the network async.
     */
    func dataTask( request: URLRequest, method: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        var request = request
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            completion(data, response, error)
        }.resume()
    }
}
