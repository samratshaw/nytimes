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
    
    // The array containing the filtered results
    var arrFilteredArticles: Array<NewsArticle> = []
    
    // Keep track whether the datasource is filtered or not.
    var isFiltered: Bool = false
    
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
}
/****************************/
// MARK: - ViewController Extension: UICollectionViewDataSource
/****************************/
extension HomePageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isInitialDataLoaded ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltered ? arrFilteredArticles.count : articles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomePageCollectionViewCellIdentifier, for: indexPath) as! HomePageCollectionViewCell
        
        let article = getArticleForCollectionCellAtIndexPath(indexPath)
        
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
        let selectedArticle = isFiltered ? arrFilteredArticles[indexPath.row] : articles[indexPath.row]
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
            if !activityIndicator.isAnimating && !isFiltered {
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
        // Only show the table if there are any previous searched items.
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
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.characters.count)! > 0 {
            let searchText = searchBar.text!
            lastSearchedItems.insert(searchText, at: 0)
            performSearchForText(searchText)
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard & also the table view if it shown
        searchBar.text = ""
        isFiltered = false
        removeSearchBarAsFirstResponderAndHideTableView()
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
        let selectedSearchText = lastSearchedItems[indexPath.row]
        performSearchForText(selectedSearchText)
    }
}

/****************************/
// MARK: - Private Extension
/****************************/
extension HomePageViewController {
    
    /**
     * Method to resign the first responder from search bar & hide the tableview.
     */
    func removeSearchBarAsFirstResponderAndHideTableView() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        if !isTableViewHidden {
            isTableViewHidden = true
        }
        collectionView.reloadData()
    }
    
    /**
     * Method to call the web service to get news articles. This method will show the activity indicator, call the web sevice & then update the model.
     */
    func getNewsArticles<Service: Gettable>(fromService service: Service) where Service.AssociatedData == [NewsArticle] {
        
        // Start the loading indicator
        activityIndicator.startAnimating()
        
        service.getWithParameters([Constants.RequestParameters.Page : String(pageNumber)]) { [weak self] result in
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
                // TODO: - Handle the error scenario
                print(error)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    /**
     * Method to filter the array based on the search text. 
     * It filters based on "headline" property of the article.
     */
    func filterArray(_ array:[NewsArticle], ForSearchText searchText: String) -> [NewsArticle] {
        return array.filter { (article) -> Bool in
            return article.headline.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    /**
     * Method to get the article that needs to be dsiplayed.
     * Checks if the the data needs to be filtered or not.
     */
    func getArticleForCollectionCellAtIndexPath(_ indexPath:IndexPath) -> NewsArticle {
        let article: NewsArticle
        if isFiltered {
            article = arrFilteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        return article
    }
    
    /**
     * Method to perform the search depending on user's input
     */
    func performSearchForText(_ searchText: String) {
        arrFilteredArticles = filterArray(articles, ForSearchText: searchText)
        isFiltered = true
        searchBar.text = searchText
        removeSearchBarAsFirstResponderAndHideTableView()
    }
}
/****************************/
