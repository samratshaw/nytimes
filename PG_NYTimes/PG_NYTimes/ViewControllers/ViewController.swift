//
//  ViewController.swift
//  PG_NYTimes
//
//  Created by Samrat on 16/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    /****************************/
    // MARK: - Properties
    /****************************/
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /****************************/
    // MARK: - View Lifecycle
    /****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customizeSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /****************************/
    // MARK: - Helpers
    /****************************/
    func customizeSearchBar() {
        searchBar.showsCancelButton = true
    }
}

/****************************/
// MARK: - ViewController Extension: UICollectionViewDataSource
/****************************/
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: - Need to map it to the data count
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Need to map it to the data count
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Need to map it to the data properties
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomePageCollectionViewCellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}

/****************************/
// MARK: - Extension: UICollectionViewDelegate
/****************************/
extension ViewController: UICollectionViewDelegate {
    
}

/****************************/
// MARK: - Extension: UICollectionViewDelegateFlowLayout
/****************************/
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width - 20, height:CGFloat(Constants.CellHeight.HomePageCollectionViewCellHeight))
    }
}
/****************************/
// MARK: - Extension: UICollectionViewDelegateFlowLayout
/****************************/
extension ViewController: UISearchBarDelegate {
    
}
