//
//  ExploreTableViewController.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExploreTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var locationCoordinate: CLLocationCoordinate2D?
    var restaurantArray: [Restaurant] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedRestaurant: Restaurant?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTableView()
        self.fetchRestaurantArray()
    }
    
    // MARK: - Private Methods
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.doorDashRed]
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        self.tabBarController?.navigationItem.title = "DoorDash"
        
        self.tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: RestaurantTableViewCell.nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: RestaurantTableViewCell.cellIdentifier)
    }
    
    private func fetchRestaurantArray() {
        guard let locationCoordinate = locationCoordinate
            else { assertionFailure("Location coordinate is nil"); return }
        
        APIClient.shared.fetchRestaurantData(for: locationCoordinate) { (restaurants, error) in
            self.restaurantArray = restaurants
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.showRestaurantVCSegue {
            guard let restaurantVC = segue.destination as? RestaurantViewController else {
                    assertionFailure("Error segue to ExploreTableViewController")
                    return
            }
            
            restaurantVC.restaurant = self.selectedRestaurant
        }
    }

}

// MARK: TableView Delegate Methods

extension ExploreTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurantArray[indexPath.row]
        self.selectedRestaurant = restaurant
        
        self.performSegue(withIdentifier: Constants.Segues.showRestaurantVCSegue, sender: self)
    }
}

// MARK: TableView DataSource Methods

extension ExploreTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(self.restaurantArray.count)
        return self.restaurantArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.cellIdentifier) as! RestaurantTableViewCell
        let restaurant = restaurantArray[indexPath.row]
        
        cell.restaurantNameLabel.text = restaurant.name
        cell.descriptionLabel.text = restaurant.description
        
        let deliveryFeeText = restaurant.deliveryFee == 0 ? "Free Delivery" : "$\(restaurant.deliveryFee) delivery"
        cell.deliveryFeeLabel.text = deliveryFeeText
        let deliveryTimeText = "\(restaurant.asapTime) min"
        cell.deliveryTimeLabel.text = deliveryTimeText
        
        Helpers.downloadRestaurantImage(url: restaurant.coverImgURL) { (coverImage) in
            DispatchQueue.main.async {
                cell.coverImageView.image = coverImage
            }
        }
        
        return cell
    }
    
}
