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
        id = docs[Constants.ResponseParameters.GetArticlesId] as! String
        
        // Set the headline
        let dictHeadline = docs[Constants.ResponseParameters.GetArticlesHeadline] as! [String:Any]
        headline = dictHeadline[Constants.ResponseParameters.GetArticlesHeadlineMain] as! String
        
        // Set the snippet
        snippet = docs[Constants.ResponseParameters.GetArticlesSnippet] as! String
        
        // Set the web url.
        webUrl = docs[Constants.ResponseParameters.GetArticlesWebUrl] as! String
        
        // Set the image associated with the article
        let arrMultimedia = docs[Constants.ResponseParameters.GetArticlesMultimedia] as! [[String:Any]]
        
        // Since the articles always have 2 objects, and we are taking the 2nd object(largest image)
        if arrMultimedia.count > 0 {
            imageUrl = Constants.URLs.ImageBaseURL + (arrMultimedia.first![Constants.ResponseParameters.GetArticlesMultimediaUrl] as! String)
        } else {
            imageUrl = ""
        }
        
        // The publication date of the article
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.General.ServerDateFormat
        if let date = dateFormatter.date(from: docs[Constants.ResponseParameters.GetArticlesPublicationDate] as! String) {
            dateFormatter.dateFormat = Constants.General.DisplayDateFormat
            publicationDate = dateFormatter.string(from: date)
        } else {
            publicationDate = ""
        }
    }
}

// Important for testing
extension NewsArticle: Equatable {}
    
    func ==(lhs: NewsArticle, rhs: NewsArticle) -> Bool {
        
        let areEqual =  lhs.id == rhs.id &&
                        lhs.headline == rhs.headline &&
                        lhs.snippet == rhs.snippet &&
                        lhs.imageUrl == rhs.imageUrl &&
                        lhs.webUrl == rhs.webUrl &&
                        lhs.publicationDate == rhs.publicationDate
        
        return areEqual
    }
