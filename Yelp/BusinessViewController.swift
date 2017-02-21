//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking
import CoreLocation

class BusinessViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = business.name
        distanceLabel.text = business.distance
        if let url = business.ratingImageURL {
            ratingsView.setImageWith(url)
        }
        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        categoriesLabel.text = business.categories
        addressLabel.text = business.address
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        goToLocation(location: CLLocation(latitude: business.latitude!, longitude: business.longitude!))
        addAnnotation(location: CLLocation(latitude: business.latitude!, longitude: business.longitude!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addAnnotation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
