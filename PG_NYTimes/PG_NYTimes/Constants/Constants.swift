//
//  Constants.swift
//  PG_NYTimes
//
//  Created by Samrat on 16/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation

/**
 This struct holds all the global constants of the project.
 */
struct Constants {
    
    struct CellIdentifiers {
        static let HomePageCollectionViewCellIdentifier = "homePageCollectionViewCellIdentifier"
        static let HomePageSearchResultsTableViewCellIdentifier = "homePageSearchResultsTableViewCellIdentifier"
    }
    
    struct CellHeight {
        static let HomePageCollectionViewCellHeight = 268
    }
    
    struct StoryboardIds {
        static let NewsDetailsViewController = "newsDetailsViewController"
    }
    
    struct Notifications {
    }
    
    struct URLs {
        static let BaseURL = "https://api.nytimes.com/svc/search/v2/articlesearch.json"
        static let GetArticles = URLs.BaseURL + "?api-key=1c71cb656b4041ef9b2f49a194b79571&q=singapore&sort=newest"
    }
    
    struct General {
        static let SearchResultsMaximumCount = 10
    }
}
