//
//  CustomAnnotation.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AFNetworking

class CustomAnnotation: MKPointAnnotation {
    
    let business: Business!
    let businessView: UIImageView!
    
    init(business: Business) {
        self.business = business
        
        businessView = UIImageView()
        
        if let url = business.imageURL {
            businessView.setImageWith(url)
        }
        else {
            businessView.image = #imageLiteral(resourceName: "iconmonstr-shop-1-240")
        }
    }
    
}
