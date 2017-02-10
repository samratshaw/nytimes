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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // The manager for this view controller consisting the business logic
    var manager: HomePageManager = HomePageManager()
    
    // Track the first load
    var isInitialDataLoaded: Bool = false
    
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
    /****************************/
    // MARK: - View Lifecycle
    /****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get articles
        fetchNewsArticles()
        
        // Initial Setup
        title = "New York Times Clone"
        isTableViewHidden = true
        searchBar.showsCancelButton = true
    }
}
/****************************/
// MARK: - ViewController Extension: UICollectionViewDataSource
/****************************/
extension HomePageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isInitialDataLoaded ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.getArticlesToDisplay().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomePageCollectionViewCellIdentifier, for: indexPath) as! HomePageCollectionViewCell
        
        let article = manager.getArticlesToDisplay()[indexPath.row]
        
        cell.lblTitle.text = article.headline
        cell.lblSnippet.text = article.snippet
        cell.lblDate.text = article.publicationDate
        cell.imgVw.image = UIImage.init(named: Constants.Images.DefaultImage)
        
        if !article.imageUrl.isEmpty {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL.init(string: article.imageUrl)!)
                DispatchQueue.main.async {
                    cell.imgVw.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
}
/****************************/
// MARK: - Extension: UICollectionViewDelegate
/****************************/
extension HomePageViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = manager.getArticlesToDisplay()[indexPath.row]
        let safariViewController = SFSafariViewController(url: NSURL(string: selectedArticle.webUrl) as! URL, entersReaderIfAvailable:true)
        safariViewController.delegate = self
        
        // Present the SFSafariViewController
        self.present(safariViewController, animated: true)
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
// MARK: - Extension: SFSafariViewControllerDelegate
/****************************/
extension HomePageViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
        }
    }
}
/****************************/
// MARK: - Extension: UIScrollViewDelegate
/****************************/
extension HomePageViewController: UIScrollViewDelegate {
    
    // Used scrollview delegate instead of "willDisplayCell" since the collection view was not loading as expected when we reached the bottom of the collection. Comparatively this performed better.
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let scrollViewBottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if scrollViewBottomEdge >= scrollView.contentSize.height {
            
            // Only call the service when another call is not being made. The activity indicator will be shown when a service is being called. Thus using the same instead of declaring another bool. Also added the filtring aspect.
            if !activityIndicator.isAnimating && !manager.isFiltered {
                fetchNewsArticles()
            }
        }
    }
}
/****************************/
// MARK: - Extension: UISearchBarDelegate
/****************************/
extension HomePageViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Only show the table if there are any previous searched items.
        if manager.getLastSearchedItems().count > 0 {
            // Display the table view
            if isTableViewHidden {
                isTableViewHidden = false
            }
            tableView.reloadData()
        }
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.characters.count)! > 0 {
            let searchText = searchBar.text!
            performSearchForText(searchText, AndRememberText: true)
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard & also the table view if it is shown
        searchBar.text = ""
        manager.isFiltered = false
        removeSearchBarAsFirstResponderAndHideTableView()
    }
}
/****************************/
// MARK: - Extension: UITableViewDataSource
/****************************/
extension HomePageViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lastSearchedCount = manager.getLastSearchedItems().count
        return (lastSearchedCount > Constants.General.SearchResultsMaximumCount)
            ? Constants.General.SearchResultsMaximumCount
            : lastSearchedCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomePageSearchResultsTableViewCellIdentifier, for:indexPath)
        cell.textLabel?.text = manager.getLastSearchedItems()[indexPath.row]
        return cell
    }
}
/****************************/
// MARK: - Extension: UITableViewDelegate
/****************************/
extension HomePageViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let selectedSearchText = manager.getLastSearchedItems()[indexPath.row]
        performSearchForText(selectedSearchText, AndRememberText: false)
    }
}

/****************************/
// MARK: - Private Extension
/****************************/
extension HomePageViewController {

    func removeSearchBarAsFirstResponderAndHideTableView() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        if !isTableViewHidden {
            isTableViewHidden = true
        }
        collectionView.reloadData()
    }
    
    func fetchNewsArticles() {
        // Start the loading indicator
        activityIndicator.startAnimating()
        manager.fetchNewsArticles { [weak self] (result) in
            self?.isInitialDataLoaded = true
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    /**
     * Method to perform the search depending on user's input
     */
    func performSearchForText(_ searchText: String, AndRememberText rememberText: Bool) {
        manager.performSearchForText(searchText, AndRememberText: rememberText)
        searchBar.text = searchText
        removeSearchBarAsFirstResponderAndHideTableView()
    }
}
/****************************/
