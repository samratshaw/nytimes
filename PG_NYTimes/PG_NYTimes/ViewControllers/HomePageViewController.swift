//
//  HomePageViewController.swift
//  PG_NYTimes
//
//  Created by Samrat on 16/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import UIKit

class HomePageViewController: BaseViewController {

    /****************************/
    // MARK: - Properties
    /****************************/
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
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
extension HomePageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: - Need to map it to the data count
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Need to map it to the data count
        return titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Need to map it to the data properties
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomePageCollectionViewCellIdentifier, for: indexPath) as! HomePageCollectionViewCell
        
        cell.lblTitle.text = titles[indexPath.row]
        cell.backgroundColor = UIColor.blue
        return cell
    }
}

/****************************/
// MARK: - Extension: UICollectionViewDelegate
/****************************/

extension HomePageViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: - Add information about the news item that was selected.
        let newsDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier :Constants.StoryboardIds.NewsDetailsViewController) as! NewsDetailsViewController
        
        navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == (titles.count-1) {
            // TODO: - Show the activity indicator here & call the service for the next set of data.
            if titles.count < 14 {
                titles.append("10")
                titles.append("11")
                titles.append("12")
                titles.append("13")
                titles.append("14")
                titles.append("15")
                collectionView.reloadSections([0])
                //collectionView.reloadData()
                //collectionView.layoutIfNeeded()
            }
        }
    }
}

/****************************/
// MARK: - Extension: UICollectionViewDelegateFlowLayout
/****************************/
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:CGFloat(Constants.CellHeight.HomePageCollectionViewCellHeight))
    }
}
/****************************/
// MARK: - Extension: UICollectionViewDelegateFlowLayout
/****************************/
extension HomePageViewController: UISearchBarDelegate {
    
}
