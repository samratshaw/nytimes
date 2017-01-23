//
//  NewsArticle.swift
//  PG_NYTimes
//
//  Created by Samrat on 23/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 * This structure represents each NewsArticle that is parsed from the website.
 */
struct NewsArticle: BaseEntity {
    
    let id: String
    
    let headline: String
    
    let snippet: String
    
    let webUrl: String
    
    let publicationDate: String
    
    let imageUrl: String
    
}
