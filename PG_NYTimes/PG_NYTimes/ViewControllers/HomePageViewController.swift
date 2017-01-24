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
    
    // The service class attached with this controller
    var service: NewsArticleService = NewsArticleService()
    
    // Array for keeping track of the last searched items
    var lastSearchedItems: Array<String> = []
    
    // Array containing the articles
    var articles: Array<NewsArticle> = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // The page that was last loaded
    var pageNumber: CUnsignedShort = 0
    
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
    
    var isInitialDataLoaded: Bool = false
    
    /****************************/
    // MARK: - View Lifecycle
    /****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Call the service
        getNewsArticles(fromService: service)
        
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
    private func customizeSearchBar() {
        searchBar.showsCancelButton = true
    }
    
    func getNewsArticles<Service: Gettable>(fromService service: Service) where Service.AssociatedData == [NewsArticle] {
        
        // Start the loading indicator
        activityIndicator.startAnimating()
        
        service.getWithParameters(["page":String(pageNumber)]) { [weak self] result in
            switch result {
            case .Success(let newsArticles):
                DispatchQueue.main.async {
                    print(newsArticles)
                    self?.isInitialDataLoaded = true
                    self?.articles += newsArticles
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case .Failure(let error):
                print(error)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

/****************************/
// MARK: - ViewController Extension: UICollectionViewDataSource
/****************************/
extension HomePageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: - Need to map it to the data count
        return isInitialDataLoaded ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Need to map it to the data count
        return articles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomePageCollectionViewCellIdentifier, for: indexPath) as! HomePageCollectionViewCell
        
        cell.lblTitle.text = articles[indexPath.row].headline
        cell.lblSnippet.text = articles[indexPath.row].snippet
        cell.lblDate.text = articles[indexPath.row].publicationDate
        
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
        let url = articles[indexPath.row].webUrl
        let safariViewController = SFSafariViewController(url: NSURL(string: url) as! URL, entersReaderIfAvailable:true)
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
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let scrollViewBottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if scrollViewBottomEdge >= scrollView.contentSize.height {
            
            // Only call the service when another call is not being made. The activity indicator will be shown when a service is being called. Thus using the same instead of declaring another bool.  
            if !activityIndicator.isAnimating {
                pageNumber += 1
                getNewsArticles(fromService: service)
            }
        }
    }
}

/****************************/
// MARK: - Extension: UISearchBarDelegate
/****************************/
extension HomePageViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // TODO: - Make sure that the user has last searched results before displaying the tableview
        
        if lastSearchedItems.count > 0 {
            // Display the table view
            if isTableViewHidden {
                isTableViewHidden = false
            }
            
            // Reload the contents of tableview
            tableView.reloadData()
        }
        
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
