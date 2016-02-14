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
        Business.searchWithTerm(searchText, sort: .Distance, categories: [], deals: false, mile_radius: nil) { (businesses: [Business]!, error: NSError!) -> Void in
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
        
        var searchText = "Restaraunts"
        if searchBar.text != nil {
            if !searchBar.text!.isEmpty{
                searchText = searchBar.text!
            }
        }
        
        let categories = filters["categories"] as? [String]
        //TODO can distance filter be implemented
        
        let searchDeals = filters["deals"] as! Bool
        //var searchDeals = (filters["deals"] != nil && filters["deals"] == true) ? true : false
        print("filters[deals] \(filters["deals"]) ")
        print("searchDeals \(searchDeals)")
        print("distance: \(filters["distance"])")
        print("sort_by: \(filters["sort_by"])")
        
        let sort_by = formatSortBy(filters["sort_by"] as! String?)
        
        let mile_radius:Double? = (filters["distance"] != nil) ? Double(filters["distance"] as! String) : nil
        
        Business.searchWithTerm(searchText, sort: sort_by , categories: categories, deals: searchDeals, mile_radius: mile_radius) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    private func formatSortBy(sorty_by: String?) -> YelpSortMode{
        
        var sort_int: Int
        if sorty_by == nil || sorty_by == ""{
            sort_int = YelpSortMode.Distance.rawValue
        }else{
            sort_int = Int(sorty_by!)!
        }
        
        switch sort_int{
        
        case YelpSortMode.BestMatched.rawValue:
            return YelpSortMode.BestMatched
        case  YelpSortMode.HighestRated.rawValue:
            return YelpSortMode.HighestRated
        default:
            return YelpSortMode.Distance
            
        }
    }


}
