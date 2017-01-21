//
//  HomePageViewController.swift
//  PG_NYTimes
//
//  Created by Samrat on 16/1/17.
//  Copyright © 2017 SMRT. All rights reserved.
//

import UIKit
import SafariServices

class HomePageViewController: BaseViewController {

    /****************************/
    // MARK: - Properties
    /****************************/
    
    // The view for displaying the news articles
    @IBOutlet weak var collectionView: UICollectionView!
    
    // View allowing the user to search the news articles
    @IBOutlet weak var searchBar: UISearchBar!
    
    // View for showing the previous searches of the user.
    @IBOutlet weak var tableView: UITableView!
    
    // Array for keeping track of the last searched items
    var lastSearchedItems: Array<String> = []
    
    // Track whether the tableview is displayed or not
    var isTableViewHidden: Bool  =  false {
        didSet {
            if isTableViewHidden {
                tableView.isHidden = true
                collectionView.isHidden = false
            } else {
                tableView.isHidden = false
                collectionView.isHidden = true
            }
        }
    }
    
    // TODO: - Remove after integrating the web service.
    var titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    /****************************/
    // MARK: - View Lifecycle
    /****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "New York Times Clone"
        isTableViewHidden = true
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
        /*let newsDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier :Constants.StoryboardIds.NewsDetailsViewController) as! NewsDetailsViewController
        
        navigationController?.pushViewController(newsDetailsViewController, animated: true)*/
        
        // TODO: - Replace the hard coded url with actual url provided by the API
        let safariViewController = SFSafariViewController(url: NSURL(string: "https://www.nytimes.com/2016/12/20/business/dealbook/iguanafix-an-argentine-start-up-raises-16-million.html") as! URL, entersReaderIfAvailable:true)
        safariViewController.delegate = self
        
        // hide navigation bar and present safari view controller
        self.present(safariViewController, animated: true) { 
            
        }
    }
}

/****************************/
// MARK: - Extension: SFSafariViewControllerDelegate
/****************************/
extension HomePageViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) { 
            
        }
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
        
        let scrollViewBottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if scrollViewBottomEdge >= scrollView.contentSize.height {
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
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // TODO: - Make sure that the user has last searched results before displaying the tableview
        
        // Display the table view
        if isTableViewHidden {
            isTableViewHidden = false
        }
        
        // Reload the contents of tableview
        tableView.reloadData()
        
        return true
    }
    
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
        lastSearchedItems.insert(searchBar.text!, at: 0)
        
        searchBar.text = ""
        removeSearchBarAsFirstResponderAndHideTableView()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard & also the table view if it shown
        searchBar.text = ""
        removeSearchBarAsFirstResponderAndHideTableView()
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

/****************************/
// MARK: - Extension: UITableViewDataSource
/****************************/
extension HomePageViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastSearchedItems.count > 10 ? Constants.General.SearchResultsMaximumCount : lastSearchedItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomePageSearchResultsTableViewCellIdentifier, for:indexPath)
        cell.textLabel?.text = lastSearchedItems[indexPath.row]
        return cell
    }
}

/****************************/
// MARK: - Extension: UITableViewDelegate
/****************************/
extension HomePageViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // Filter the collection view, search bar based on the selection & also hide the tableview
        // TODO: - Add logic for handling the selection of the tableview
        removeSearchBarAsFirstResponderAndHideTableView()
    }
}

/****************************/
// MARK: - Private Extension
/****************************/
private extension HomePageViewController {
    
    /**
     Method to resign the first responder from search bar & hide the tableview.
     */
    func removeSearchBarAsFirstResponderAndHideTableView() {
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        if !isTableViewHidden {
            isTableViewHidden = true
        }
    }
}

/****************************/
