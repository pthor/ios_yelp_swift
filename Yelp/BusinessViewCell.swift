
//
//  BusinessViewCell.swift
//  Yelp
//
//  Created by Paul Thormahlen on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var longPressGesture:UILongPressGestureRecognizer?
    
    var business: Business!{
        didSet{
            nameLabel.text = business.name
            if(business.imageURL != nil){
                thumbImageView.setImageWithURL(business.imageURL!)
            }
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: "onSelfLongpressDetected:")
        self.addGestureRecognizer(self.longPressGesture!)
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
    }
    
    func onSelfLongpressDetected(sender: UILongPressGestureRecognizer){
        print("Long Press on \(business.name)")
    }
}
