//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Paul Thormahlen on 2/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate{
    optional func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var SwitchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: "switchValueChange", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    func switchValueChange(){
        print("switch value changed")
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }

}
