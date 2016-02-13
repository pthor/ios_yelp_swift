//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    let searchBar = UISearchBar()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapOnTableView(sender: AnyObject) {
        searchBar.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaraunts"
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        searchWithFilters("Thai")

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text{
            if (searchText.isEmpty){
                print("Search Text is empty so no search for you")
            }
            else{
                print("hello?")
               searchWithFilters(searchText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    
    func searchWithFilters(searchText:String){
        Business.searchWithTerm(searchText, sort: .Distance, categories: [], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessViewCell", forIndexPath: indexPath) as! BusinessViewCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        //TODO fix default search term if searchbar text is empty as this searches for nada
        let searchText = searchBar.text ?? "Restaraunts"
        let categories = filters["categories"] as? [String]
        //TODO can distance filter be implemented
        
        let searchDeals = filters["deals"] as! Bool
        //var searchDeals = (filters["deals"] != nil && filters["deals"] == true) ? true : false
        print("filters[deals] \(filters["deals"]) ")
        print("searchDeals \(searchDeals)")
        
        //TODO add distance logic
        Business.searchWithTerm(searchText, sort: .Distance, categories: categories, deals: searchDeals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }


}
