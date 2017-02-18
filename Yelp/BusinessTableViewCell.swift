//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var businessView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var business: Business! {
        didSet {
            businessView.setImageWith(business.imageURL!)
            businessNameLabel.text = business.name
            distanceLabel.text = business.distance
            ratingsView.setImageWith(business.ratingImageURL!)
            reviewsLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            tagsLabel.text = business.categories
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        businessView.layer.cornerRadius = 5
        businessView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
