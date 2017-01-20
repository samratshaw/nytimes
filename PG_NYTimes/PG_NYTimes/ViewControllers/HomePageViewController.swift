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
    
    // TODO: - Remove after integrating the web service.
    var titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    /****************************/
    // MARK: - View Lifecycle
    /****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New York Times Clone"
        
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
        
        //cell.lblTitle.text = titles[indexPath.row]
        //cell.backgroundColor = UIColor.blue
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
}

/****************************/
// MARK: - Extension: UICollectionViewDelegateFlowLayout
/****************************/

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    // This was implemented to make sure that the cells resize correctly as per the different screen sizes.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:CGFloat(Constants.CellHeight.HomePageCollectionViewCellHeight))
    }
}

/****************************/
// MARK: - Extension: UIScrollViewDelegate
/****************************/
extension HomePageViewController: UIScrollViewDelegate {
    
    // Used scrollview delegate instead of "willDisplayCell" since the collection view was not loading as expected when we reached the bottom of the collection. Comparatively this performed better.
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if bottomEdge >= scrollView.contentSize.height {
            // TODO: - Need to call the webservice here & show the activity indicator
            
            // TODO: - Remove after integrating the web service.
            titles.append("10")
            titles.append("11")
            titles.append("12")
            titles.append("13")
            titles.append("14")
            titles.append("15")
            
            
            collectionView.reloadData()
        }
    }
}

/****************************/
// MARK: - Extension: UISearchBarDelegate
/****************************/
extension HomePageViewController: UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - Add the Filtering logic here
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
