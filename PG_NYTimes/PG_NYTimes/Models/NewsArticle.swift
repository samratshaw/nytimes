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
    
    /***********************************/
    // MARK: - Properties
    /***********************************/
    
    let id: String
    
    let headline: String
    
    let snippet: String
    
    let webUrl: String
    
    let publicationDate: String
    
    let imageUrl: String
}

extension NewsArticle {
    
    /***********************************/
    // MARK: - Initialization
    /***********************************/
    
    /**
     * The initializater of the docs.
     */
    init?(_ docs:[String:Any]) {
        
        // Make sure that the "docs" is a valid dictionary containing keys.
        guard docs.keys.count > 0 else {
            return nil
        }
        
        // Set the id of the article
        id = docs["_id"] as! String
        
        // Set the headline
        let dictHeadline = docs["headline"] as! [String:Any]
        headline = dictHeadline["main"] as! String
        
        // Set the snippet
        snippet = docs["snippet"] as! String
        
        // Set the web url.
        webUrl = docs["web_url"] as! String
        
        // Set the image associated with the article
        let arrMultimedia = docs["multimedia"] as! [[String:Any]]
        
        // Since the articles always have 2 objects, and we are taking the 2nd object(largest image)
        if arrMultimedia.count > 2 {
            imageUrl = arrMultimedia[1]["url"] as! String
        } else {
            imageUrl = ""
        }
        
        // The publication date of the article
        publicationDate = docs["pub_date"] as! String
    }
}
