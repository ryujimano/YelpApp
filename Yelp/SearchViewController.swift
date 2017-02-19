//
//  SearchViewController.swift
//  Yelp
//
//  Created by Ryuji Mano on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController:UIViewController?
    
    var searchBar:UISearchBar!
    
    var rightButton:UIBarButtonItem!
    
    var isList = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentViewController = storyboard?.instantiateViewController(withIdentifier: "listView")
        currentViewController?.view.translatesAutoresizingMaskIntoConstraints = true
        addChildViewController(currentViewController!)
        containerView.addSubview((currentViewController?.view)!)

        
        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.barTintColor = .red
        
        searchBar = UISearchBar()
        
        navigationItem.titleView = searchBar
        
        rightButton = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(self.rightBarButtonPressed))
        rightButton.tintColor = .white
        isList = true
        
        navigationItem.rightBarButtonItem = rightButton
        
        searchBar.sizeToFit()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightBarButtonPressed() {
        if isList {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: "mapView")
            newViewController?.view.translatesAutoresizingMaskIntoConstraints = true
            transitionViewControllers(from: currentViewController!, to: newViewController!)
            currentViewController = newViewController
            rightButton.title = "List"
            isList = false
        }
        else {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: "listView")
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
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: { 
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        }) { (completed) in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMove(toParentViewController: self)
        }
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
