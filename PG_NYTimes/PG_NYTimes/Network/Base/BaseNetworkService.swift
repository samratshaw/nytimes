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
 * Enum to call a get request
 */
protocol Gettable {
    associatedtype AssociatedData
    
    func getWithParameters(_ parameters: Dictionary<String,String>, completionHandler: @escaping (Result<AssociatedData>) -> Void)
}

