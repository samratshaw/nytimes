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
    
    struct General {
        static let SearchResultsMaximumCount = 10
    }
}
