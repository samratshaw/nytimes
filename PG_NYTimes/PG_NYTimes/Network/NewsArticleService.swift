//
//  NewsArticleService.swift
//  PG_NYTimes
//
//  Created by Samrat on 23/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

struct NewsArticleService: Gettable {
    typealias AssociatedData = [NewsArticle]
    
    func getWithParameters(_ parameters: Dictionary<String, String>, completionHandler: @escaping (Result<AssociatedData>) -> Void) {
        
        // Get the request
        let request = getURLRequest(parameters)
        
        // Call the service
        dataTask(request: request, method: "GET") { (data, response, error) in
            // Make sure that there is no error.
            guard error == nil else {
                completionHandler(Result.Failure(error!))
                return
            }
            // Check if data is not nil
            guard let data = data else {
                completionHandler(Result.Success(Array<NewsArticle>()))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        
        // Parse the response
        let arrArticles = Array<NewsArticle>()
        
        completionHandler(Result.Success(arrArticles))
    }
    
    /**
     * Method to get the URLRequest
     */
    private func getURLRequest(_ parameters: Dictionary<String, String>) -> URLRequest {
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
     * Method to call the network.
     */
    private func dataTask( request: URLRequest, method: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        var request = request
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            completion(data, response, error)
        }.resume()
    }
}
