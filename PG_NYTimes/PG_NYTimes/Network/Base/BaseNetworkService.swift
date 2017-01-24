//
//  BaseNetworkService.swift
//  PG_NYTimes
//
//  Created by Samrat on 23/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * Enum representing the result of a web service call.
 */
enum Result<T> {
    case Success(T)
    case Failure(Error)
}

/**
 * Enum representing the various HTTPMethods
 */
enum HTTPMethod: String {
    case GET, PUT, POST, DELETE
}

/**
 * Enum to call a get request
 */
protocol Gettable {
    
    associatedtype AssociatedData
    
    /**
     * Method to call a get service.
     * parameters: The list of parameters that will be sent along with the request as query string.
     * completionHandler: The handler that will handle after the service return.
     */
    func getWithParameters(_ parameters: Dictionary<String,String>, completionHandler: @escaping (Result<AssociatedData>) -> Void)
}

