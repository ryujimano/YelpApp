//
//  MapViewController.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AFNetworking

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var annotationView: AnnotationView!
    var gestureRecognizer: UIGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var rotationRecognizer: UIRotationGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    var viewTapGestureRecognizer: UITapGestureRecognizer!
    
    var searchView:SearchViewController!
    var locationManager: CLLocationManager!
    
    var lat:Double?
    var long:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addAnnotations()
        
        annotationView.alpha = 0
        view.addSubview(annotationView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        
        gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.delegate = self
        
        panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.delegate = self
        
        pinchGestureRecognizer = UIPinchGestureRecognizer()
        pinchGestureRecognizer.delegate = self
        
        rotationRecognizer = UIRotationGestureRecognizer()
        rotationRecognizer.delegate = self
        
        longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.delegate = self
        
        viewTapGestureRecognizer = UITapGestureRecognizer()
        viewTapGestureRecognizer.delegate = self
        
        gestureRecognizer.addTarget(self, action: #selector(self.mapviewTapped))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        panGestureRecognizer.addTarget(self, action: #selector(self.mapviewDragged))
        mapView.addGestureRecognizer(panGestureRecognizer)
        
        pinchGestureRecognizer.addTarget(self, action: #selector(self.mapviewDragged))
        mapView.addGestureRecognizer(pinchGestureRecognizer)
        
        rotationRecognizer.addTarget(self, action: #selector(self.mapviewDragged))
        mapView.addGestureRecognizer(rotationRecognizer)
        
        longPressRecognizer.addTarget(self, action: #selector(self.mapviewDragged))
        mapView.addGestureRecognizer(longPressRecognizer)
        
        viewTapGestureRecognizer.addTarget(self, action: #selector(self.viewTapped))
        annotationView.addGestureRecognizer(viewTapGestureRecognizer)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        
        var centerLoc:CLLocation!

        if let lat = searchView.lat, let long = searchView.long {
            centerLoc = CLLocation(latitude: lat, longitude: long)
            goToLocation(location: centerLoc)
            self.lat = lat
            self.long = long
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnotations() {
        for business in searchView.businesses {
            addAnotation(forBusiness: business)
        }
    }
    
    func addAnotation(forBusiness business: Business) {
        let annotation = CustomAnnotation(business: business)
        guard let lat = business.latitude, let long = business.longitude else {
            return
        }
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        let ann = annotation as! CustomAnnotation
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: ann, reuseIdentifier: identifier)
        }
        else {
            annotationView?.annotation = ann
        }
        
        annotationView!.image = ann.businessView.image
        ann.businessView.frame.size.height = 50
        ann.businessView.frame.size.width = 50
        annotationView!.frame = ann.businessView.frame
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let ann = view.annotation as! CustomAnnotation
        annotationView.nameLabel.text = ann.business.name
        annotationView.distanceLabel.text = ann.business.distance
        annotationView.reviewsView.setImageWith(ann.business.ratingImageURL!)
        annotationView.reviewsLabel.text = "\(ann.business.reviewCount!) Reviews"
        annotationView.addressLabel.text = ann.business.address
        annotationView.categoriesLabel.text = ann.business.categories
        annotationView.id = searchView.businesses.index(of: ann.business)!
        
        var x = view.frame.origin.x - 90
        let y = view.frame.origin.y
        if x < 0 {
            x = 0
        }
        else if x + 240 > self.view.frame.width {
            x = self.view.frame.width - 240
        }
        annotationView.frame = CGRect(x: x, y: y - 83, width: 240, height: 80)
        annotationView.layer.cornerRadius = 5
        annotationView.alpha = 1
    }
    
    @objc func mapviewTapped() {
        searchView.searchBar.resignFirstResponder()
        annotationView.alpha = 0
        searchView.navigationItem.rightBarButtonItem = searchView.rightButton
    }
    
    @objc func mapviewDragged() {
        searchView.searchBar.resignFirstResponder()
        annotationView.alpha = 0
        searchView.navigationItem.rightBarButtonItem = searchView.rightButton
    }
    
    @objc func viewTapped() {
        let businessView = storyboard?.instantiateViewController(withIdentifier: "businessView") as! BusinessViewController
        businessView.business = searchView.businesses[annotationView.id]
        searchView.navigationController?.show(businessView, sender: viewTapGestureRecognizer)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            
            self.lat = location.coordinate.latitude
            self.long = location.coordinate.longitude
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
