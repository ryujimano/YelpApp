//
//  SearchViewController.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController:UIViewController?
    var listViewController:BusinessesViewController!
    var mapViewController:MapViewController!
    
    var searchBar:UISearchBar!
    
    var rightButton:UIBarButtonItem!
    var searchButton:UIBarButtonItem!
    
    var isList = true
    
    var lat:Double?
    var long:Double?
    var coordinates:String?
    
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        
        listViewController = storyboard?.instantiateViewController(withIdentifier: "listView") as! BusinessesViewController
        listViewController.height = Int((self.navigationController?.navigationBar.frame.height)!) + Int(UIApplication.shared.statusBarFrame.height)
        listViewController.searchView = self
        mapViewController = storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        mapViewController.searchView = self
        
        currentViewController = listViewController
        currentViewController?.view.translatesAutoresizingMaskIntoConstraints = true
        addChildViewController(currentViewController!)
        containerView.addSubview((currentViewController?.view)!)
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.barTintColor = .red
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        rightButton = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(self.rightBarButtonPressed))
        rightButton.tintColor = .white
        isList = true
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        searchBar.sizeToFit()
        
        searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(self.searchButtonClicked))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightBarButtonPressed() {
        if isList {
            let newViewController = mapViewController
            newViewController?.view.translatesAutoresizingMaskIntoConstraints = true
            transitionViewControllers(from: currentViewController!, to: newViewController!)
            currentViewController = newViewController
            rightButton.title = "List"
            isList = false
        }
        else {
            let newViewController = listViewController
            newViewController?.view.translatesAutoresizingMaskIntoConstraints = true
            transitionViewControllers(from: currentViewController!, to: newViewController!)
            currentViewController = newViewController
            rightButton.title = "Map"
            isList = true
        }
    }
    
    func transitionViewControllers(from oldViewController:UIViewController, to newViewController:UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        addChildViewController(newViewController)
        containerView.addSubview(newViewController.view)
        if isList {
            UIView.transition(from: oldViewController.view, to: newViewController.view, duration: 0.8, options: .transitionFlipFromRight) { (completed) in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            }
        }
        else {
            UIView.transition(from: oldViewController.view, to: newViewController.view, duration: 0.8, options: .transitionFlipFromLeft) { (completed) in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func searchButtonClicked() {
        MBProgressHUD.showAdded(to: view, animated: true)
        listViewController.offset = 0
        listViewController.term = searchBar.text!
        listViewController.getBusinesses(at: listViewController.offset, forTerm: listViewController.term)
        
    }
    
    func reloadMapView() {
        guard let mapView = mapViewController.mapView else {
            return
        }
        mapView.removeAnnotations(mapViewController.mapView.annotations)
        mapViewController.addAnnotations()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonClicked()
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = rightButton
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
