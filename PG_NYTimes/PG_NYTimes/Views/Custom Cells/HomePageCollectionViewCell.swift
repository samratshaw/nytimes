//
//  HomePageCollectionViewCell.swift
//  PG_NYTimes
//
//  Created by Samrat on 18/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import Foundation
import UIKit

class HomePageCollectionViewCell: BaseCustomCollectionViewCell {
    
    /****************************/
    // MARK: - Properties
    /****************************/
    
    // The title of the article
    @IBOutlet weak var lblTitle: UILabel!
    
    // The snippet of the article
    @IBOutlet weak var lblSnippet: UILabel!
    
    // The date of the article
    @IBOutlet weak var lblDate: UILabel!
    
    // The image associated with the article
    @IBOutlet weak var imgVw: UIImageView!
}
