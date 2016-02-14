//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Paul Thormahlen on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit



@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController:FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate  {
    
    enum FilterSection: Int{
        case Deals = 0
        case Distance = 1
        case SortBy = 2
        case Category = 3
    }

    @IBOutlet weak var tableView: UITableView!
    
    var categorySwitchSates = [Int:Bool]()
    var sortSwitchSates = [0:false,1:false,2:false]
    var distanceSwitchSates = [0:false,1:false,2:false,3:false,4:false]

    var offeringDealsSelected = false
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String]()
        for (row,isSelected) in categorySwitchSates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        for (row,isSelected) in distanceSwitchSates {
            if isSelected {
                filters["distance"] = distances[row]["code"]!
            }
        }

        for (row,isSelected) in sortSwitchSates {
            if isSelected {
                filters["sort_by"] = sortings[row]["code"]!
            }
        }
        
        
        print("offeringDealsSelected \(offeringDealsSelected)")
        filters["deals"]  = offeringDealsSelected
        
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
 
        print("Cell is for deals or Categories")
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchTableViewCell
            
        if indexPath.section == FilterSection.Deals.rawValue{
                print("Cell is for deals")
                cell.SwitchLabel.text = "Offering Deals"
                cell.onSwitch.on = offeringDealsSelected
        }
        else if indexPath.section == FilterSection.Distance.rawValue {
            cell.SwitchLabel.text = distances[indexPath.row]["name"]
            cell.onSwitch.on = distanceSwitchSates[indexPath.row] ?? false
        }
        else if indexPath.section == FilterSection.SortBy.rawValue {
            cell.SwitchLabel.text = sortings[indexPath.row]["name"]
            cell.onSwitch.on = sortSwitchSates[indexPath.row] ?? false
        }
        else{
            print("Cell is for Category")
            if indexPath.row > 5{
                //show footer cell or add a button cell idk
                //cell.hidden = true
            }
            cell.SwitchLabel.text = categories[indexPath.row]["name"]
            cell.onSwitch.on = categorySwitchSates[indexPath.row] ?? false
        }
        cell.delegate = self
        return cell
    
 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 1
        switch section{
            case FilterSection.Category.rawValue:
                numRows = categories.count
        case FilterSection.Distance.rawValue:
                numRows = distances.count
        case FilterSection.SortBy.rawValue:
            numRows = sortings.count
        case FilterSection.Deals.rawValue:
               numRows =   1
        default:
             numRows = 1
        }
        
        
        return numRows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > FilterSection.Deals.rawValue ?  30 : 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle:String?
        switch section{
        case FilterSection.Distance.rawValue:
                headerTitle = "Distance"
        case FilterSection.SortBy.rawValue:
            headerTitle = "Sort By"
        case FilterSection.Category.rawValue:
            headerTitle = "Categories"
        case FilterSection.Deals.rawValue:
            headerTitle = nil
        default:
            headerTitle = nil
        }
        
        return headerTitle
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        //TODO refactor to switch
        let indexPath = tableView.indexPathForCell(switchCell)!
        if indexPath.section == FilterSection.Category.rawValue{
            categorySwitchSates[indexPath.row] = switchCell.onSwitch.on
        }
        else if indexPath.section == FilterSection.Distance.rawValue {
            turnOffOtherSwitchesInSection(indexPath, switchs_states: distanceSwitchSates, except_row: indexPath.row)
            distanceSwitchSates[indexPath.row] = switchCell.onSwitch.on
        }
        else if indexPath.section == FilterSection.SortBy.rawValue {
            print("FilterSection.SortBy changed at row \(indexPath.row)")
            turnOffOtherSwitchesInSection(indexPath, switchs_states: sortSwitchSates, except_row: indexPath.row)
            sortSwitchSates[indexPath.row] = switchCell.onSwitch.on
        }
        else if indexPath.section == FilterSection.Deals.rawValue{
            offeringDealsSelected = true
        }
        
    }
    
    //turn of the other swithes.  There is a better option that using switches like this for single choice, I'm sure
    func turnOffOtherSwitchesInSection(indexPath:NSIndexPath, switchs_states:[Int:Bool], except_row: Int){
        for (row,isSelected) in switchs_states {
            if(isSelected && row != except_row){
                let sortCellNSINdexPath = NSIndexPath(forRow:row, inSection: indexPath.section)
                let otherSwitchCell = tableView.cellForRowAtIndexPath(sortCellNSINdexPath) as! SwitchTableViewCell
                otherSwitchCell.onSwitch.on = false
            }
        }
    
    }
    
    let sortings = [["name" : "Best Match", "code": "0"],
                    ["name" : "Distance", "code": "1"],
                    ["name" : "HighestRated", "code": "2"]]
        
    let distances = [["name" : "Auto", "code": ""],
                    ["name" : "0.3 miles", "code": "0.3"],
                    ["name" : "1 mile", "code": "1"],
                    ["name" : "5 miles", "code": "5"],
                    ["name" : "10 miles", "code": "10"]]
    
    let categories = [["name" : "Afghan", "code": "afghani"],
        ["name" : "African", "code": "african"],
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "American, Traditional", "code": "tradamerican"],
        ["name" : "Arabian", "code": "arabian"],
        ["name" : "Argentine", "code": "argentine"],
        ["name" : "Armenian", "code": "armenian"],
        ["name" : "Asian Fusion", "code": "asianfusion"],
        ["name" : "Asturian", "code": "asturian"],
        ["name" : "Australian", "code": "australian"],
        ["name" : "Austrian", "code": "austrian"],
        ["name" : "Baguettes", "code": "baguettes"],
        ["name" : "Bangladeshi", "code": "bangladeshi"],
        ["name" : "Barbeque", "code": "bbq"],
        ["name" : "Basque", "code": "basque"],
        ["name" : "Bavarian", "code": "bavarian"],
        ["name" : "Beer Garden", "code": "beergarden"],
        ["name" : "Beer Hall", "code": "beerhall"],
        ["name" : "Beisl", "code": "beisl"],
        ["name" : "Belgian", "code": "belgian"],
        ["name" : "Bistros", "code": "bistros"],
        ["name" : "Black Sea", "code": "blacksea"],
        ["name" : "Brasseries", "code": "brasseries"],
        ["name" : "Brazilian", "code": "brazilian"],
        ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
        ["name" : "British", "code": "british"],
        ["name" : "Buffets", "code": "buffets"],
        ["name" : "Bulgarian", "code": "bulgarian"],
        ["name" : "Burgers", "code": "burgers"],
        ["name" : "Burmese", "code": "burmese"],
        ["name" : "Cafes", "code": "cafes"],
        ["name" : "Cafeteria", "code": "cafeteria"],
        ["name" : "Cajun/Creole", "code": "cajun"],
        ["name" : "Cambodian", "code": "cambodian"],
        ["name" : "Canadian", "code": "New)"],
        ["name" : "Canteen", "code": "canteen"],
        ["name" : "Caribbean", "code": "caribbean"],
        ["name" : "Catalan", "code": "catalan"],
        ["name" : "Chech", "code": "chech"],
        ["name" : "Cheesesteaks", "code": "cheesesteaks"],
        ["name" : "Chicken Shop", "code": "chickenshop"],
        ["name" : "Chicken Wings", "code": "chicken_wings"],
        ["name" : "Chilean", "code": "chilean"],
        ["name" : "Chinese", "code": "chinese"],
        ["name" : "Comfort Food", "code": "comfortfood"],
        ["name" : "Corsican", "code": "corsican"],
        ["name" : "Creperies", "code": "creperies"],
        ["name" : "Cuban", "code": "cuban"],
        ["name" : "Curry Sausage", "code": "currysausage"],
        ["name" : "Cypriot", "code": "cypriot"],
        ["name" : "Czech", "code": "czech"],
        ["name" : "Czech/Slovakian", "code": "czechslovakian"],
        ["name" : "Danish", "code": "danish"],
        ["name" : "Delis", "code": "delis"],
        ["name" : "Diners", "code": "diners"],
        ["name" : "Dumplings", "code": "dumplings"],
        ["name" : "Eastern European", "code": "eastern_european"],
        ["name" : "Ethiopian", "code": "ethiopian"],
        ["name" : "Fast Food", "code": "hotdogs"],
        ["name" : "Filipino", "code": "filipino"],
        ["name" : "Fish & Chips", "code": "fishnchips"],
        ["name" : "Fondue", "code": "fondue"],
        ["name" : "Food Court", "code": "food_court"],
        ["name" : "Food Stands", "code": "foodstands"],
        ["name" : "French", "code": "french"],
        ["name" : "French Southwest", "code": "sud_ouest"],
        ["name" : "Galician", "code": "galician"],
        ["name" : "Gastropubs", "code": "gastropubs"],
        ["name" : "Georgian", "code": "georgian"],
        ["name" : "German", "code": "german"],
        ["name" : "Giblets", "code": "giblets"],
        ["name" : "Gluten-Free", "code": "gluten_free"],
        ["name" : "Greek", "code": "greek"],
        ["name" : "Halal", "code": "halal"],
        ["name" : "Hawaiian", "code": "hawaiian"],
        ["name" : "Heuriger", "code": "heuriger"],
        ["name" : "Himalayan/Nepalese", "code": "himalayan"],
        ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
        ["name" : "Hot Dogs", "code": "hotdog"],
        ["name" : "Hot Pot", "code": "hotpot"],
        ["name" : "Hungarian", "code": "hungarian"],
        ["name" : "Iberian", "code": "iberian"],
        ["name" : "Indian", "code": "indpak"],
        ["name" : "Indonesian", "code": "indonesian"],
        ["name" : "International", "code": "international"],
        ["name" : "Irish", "code": "irish"],
        ["name" : "Island Pub", "code": "island_pub"],
        ["name" : "Israeli", "code": "israeli"],
        ["name" : "Italian", "code": "italian"],
        ["name" : "Japanese", "code": "japanese"],
        ["name" : "Jewish", "code": "jewish"],
        ["name" : "Kebab", "code": "kebab"],
        ["name" : "Korean", "code": "korean"],
        ["name" : "Kosher", "code": "kosher"],
        ["name" : "Kurdish", "code": "kurdish"],
        ["name" : "Laos", "code": "laos"],
        ["name" : "Laotian", "code": "laotian"],
        ["name" : "Latin American", "code": "latin"],
        ["name" : "Live/Raw Food", "code": "raw_food"],
        ["name" : "Lyonnais", "code": "lyonnais"],
        ["name" : "Malaysian", "code": "malaysian"],
        ["name" : "Meatballs", "code": "meatballs"],
        ["name" : "Mediterranean", "code": "mediterranean"],
        ["name" : "Mexican", "code": "mexican"],
        ["name" : "Middle Eastern", "code": "mideastern"],
        ["name" : "Milk Bars", "code": "milkbars"],
        ["name" : "Modern Australian", "code": "modern_australian"],
        ["name" : "Modern European", "code": "modern_european"],
        ["name" : "Mongolian", "code": "mongolian"],
        ["name" : "Moroccan", "code": "moroccan"],
        ["name" : "New Zealand", "code": "newzealand"],
        ["name" : "Night Food", "code": "nightfood"],
        ["name" : "Norcinerie", "code": "norcinerie"],
        ["name" : "Open Sandwiches", "code": "opensandwiches"],
        ["name" : "Oriental", "code": "oriental"],
        ["name" : "Pakistani", "code": "pakistani"],
        ["name" : "Parent Cafes", "code": "eltern_cafes"],
        ["name" : "Parma", "code": "parma"],
        ["name" : "Persian/Iranian", "code": "persian"],
        ["name" : "Peruvian", "code": "peruvian"],
        ["name" : "Pita", "code": "pita"],
        ["name" : "Pizza", "code": "pizza"],
        ["name" : "Polish", "code": "polish"],
        ["name" : "Portuguese", "code": "portuguese"],
        ["name" : "Potatoes", "code": "potatoes"],
        ["name" : "Poutineries", "code": "poutineries"],
        ["name" : "Pub Food", "code": "pubfood"],
        ["name" : "Rice", "code": "riceshop"],
        ["name" : "Romanian", "code": "romanian"],
        ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
        ["name" : "Rumanian", "code": "rumanian"],
        ["name" : "Russian", "code": "russian"],
        ["name" : "Salad", "code": "salad"],
        ["name" : "Sandwiches", "code": "sandwiches"],
        ["name" : "Scandinavian", "code": "scandinavian"],
        ["name" : "Scottish", "code": "scottish"],
        ["name" : "Seafood", "code": "seafood"],
        ["name" : "Serbo Croatian", "code": "serbocroatian"],
        ["name" : "Signature Cuisine", "code": "signature_cuisine"],
        ["name" : "Singaporean", "code": "singaporean"],
        ["name" : "Slovakian", "code": "slovakian"],
        ["name" : "Soul Food", "code": "soulfood"],
        ["name" : "Soup", "code": "soup"],
        ["name" : "Southern", "code": "southern"],
        ["name" : "Spanish", "code": "spanish"],
        ["name" : "Steakhouses", "code": "steak"],
        ["name" : "Sushi Bars", "code": "sushi"],
        ["name" : "Swabian", "code": "swabian"],
        ["name" : "Swedish", "code": "swedish"],
        ["name" : "Swiss Food", "code": "swissfood"],
        ["name" : "Tabernas", "code": "tabernas"],
        ["name" : "Taiwanese", "code": "taiwanese"],
        ["name" : "Tapas Bars", "code": "tapas"],
        ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
        ["name" : "Tex-Mex", "code": "tex-mex"],
        ["name" : "Thai", "code": "thai"],
        ["name" : "Traditional Norwegian", "code": "norwegian"],
        ["name" : "Traditional Swedish", "code": "traditional_swedish"],
        ["name" : "Trattorie", "code": "trattorie"],
        ["name" : "Turkish", "code": "turkish"],
        ["name" : "Ukrainian", "code": "ukrainian"],
        ["name" : "Uzbek", "code": "uzbek"],
        ["name" : "Vegan", "code": "vegan"],
        ["name" : "Vegetarian", "code": "vegetarian"],
        ["name" : "Venison", "code": "venison"],
        ["name" : "Vietnamese", "code": "vietnamese"],
        ["name" : "Wok", "code": "wok"],
        ["name" : "Wraps", "code": "wraps"],
        ["name" : "Yugoslav", "code": "yugoslav"]]

}
