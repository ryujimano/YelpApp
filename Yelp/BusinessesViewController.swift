//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business] = []
    
    var isMoreDataLoading = false
    var isEnd = false
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var locationFetchCounter: Int = 0
    
    var offset = 0
    var term:String = "All"
    var location = ""
    
    var height: Int!
    var searchView:SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: searchView.view, animated: true)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        geocoder = CLGeocoder()
        
        locationFetchCounter = 0
        locationManager.startUpdatingLocation()
        
        tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 95
        
        self.automaticallyAdjustsScrollViewInsets = false
        
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
    
    override func viewWillLayoutSubviews() {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CGFloat(height), 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessView = storyboard?.instantiateViewController(withIdentifier: "businessView") as! BusinessViewController
        businessView.business = businesses[indexPath.row]
        searchView.navigationController?.show(businessView, sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold - 100 && tableView.isDragging && !isEnd {
                isMoreDataLoading = true
                
                MBProgressHUD.showAdded(to: searchView.view, animated: true)
                
                offset += businesses.count
                getBusinesses(at: offset, forTerm: term)
            }
        }
        searchView.searchBar.resignFirstResponder()
        searchView.navigationItem.rightBarButtonItem = searchView.rightButton
    }
    
    //MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationFetchCounter > 0 {
            return
        }
        
        locationFetchCounter += 1
        
        let lng = locations.last?.coordinate.longitude
        let lt = locations.last?.coordinate.latitude
        
        searchView.long = lng
        searchView.lat = lt

        let long = String(format: "%.4f", lng!)
        let lat = String(format: "%.4f", lt!)
        
        self.location = "\(lat), \(long)"
        searchView.coordinates = location
        
        self.locationManager.stopUpdatingLocation()
        
        getBusinesses(at: 0, forTerm: term)
        searchView.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func getBusinesses(at offset: Int, forTerm term: String) {
        Business.searchWithTerm(term: term, offset: offset, location: location, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = businesses, businesses.count != 0 {
                if offset == 0 {
                    self.businesses = businesses
                }
                else {
                    self.businesses += businesses
                }
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
                self.searchView.businesses = self.businesses
            }
            else {
                self.isEnd = true
            }
            self.tableView.reloadData()
            self.searchView.reloadMapView()
            MBProgressHUD.hide(for: self.searchView.view, animated: true)
            if self.tableView.alpha == 0 {
                self.tableView.alpha = 1
            }
            self.isMoreDataLoading = false
        })
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
