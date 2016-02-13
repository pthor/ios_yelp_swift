//
//  SettingPickerTableViewCell.swift
//  Yelp
//
//  Created by Paul Thormahlen on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SettingPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerData = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles",]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
