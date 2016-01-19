//
//  MapSearchResultsTableViewController.swift
//  PubFeed
//
//  Created by Edward Suczewski on 1/19/16.
//  Copyright © 2016 Mike Gilroy. All rights reserved.
//

//import UIKit
//
//class MapSearchResultsTableViewController: UITableViewController {
//    
//    var mapItems: [MKMapItem] = []
//    
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mapItems.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("mapItemCell", forIndexPath: indexPath)
//        if let name = mapItems[indexPath.row].name {
//            cell.textLabel?.text = name
//        }
//        return cell
//    }
//    
//    func search(searchTerm: String) {
//        
//        if let searchText = searchController.searchBar.text {
//            let searchTerm = searchText.lowercaseString
//            let request = MKLocalSearchRequest()
//            request.naturalLanguageQuery = searchTerm
//            let search = MKLocalSearch(request: request)
//            search.startWithCompletionHandler { (response, error) in
//                if let response = response {
//                    self.mapItems = response.mapItems
//                    
//                }
//            }
//        }
//        
//    }
//    
//    
//    // MAP SEARCH -- CURRENTLY IN PROGRESS
//    func setUpSearchController() {
//        //instantiate resultsVC
//        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mapSearchResults")
//        //set up searchController
//        searchController = UISearchController(searchResultsController: resultsController)
//        definesPresentationContext = true
//        //set up searchUpdater
//        let searchUpdater = searchController.searchResultsUpdater
//        searchUpdater?.updateSearchResultsForSearchController(searchController)
//        //define appearance for the searchController
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.searchBarStyle = .Minimal
//        searchController.searchBar.placeholder = "search in another location"
//        let searchBarTextField = searchController.searchBar.valueForKey("searchField") as? UITextField
//        searchBarTextField?.textColor = UIColor.whiteColor()
//        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.titleView = searchController.searchBar
//    }
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        searchController.searchBar.text
//    }
//
//    
//    
//    
//}
