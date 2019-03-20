//
//  RestaurantViewController.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 3/6/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var descriptionNameLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var popularItemImageView: UIImageView!
    
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRestaurantVC(restuarant: self.restaurant)
    }
    
    private func setupRestaurantVC(restuarant: Restaurant?){
        guard let restaurant = self.restaurant else { return }
        
        self.restaurantNameLabel.text = restaurant.name
        self.descriptionNameLabel.text = restaurant.description
        
        let deliveryFeeText = restaurant.deliveryFee == 0 ? "Free Delivery" : "$\(restaurant.deliveryFee) delivery"
        self.deliveryFeeLabel.text = deliveryFeeText
        
        Helpers.downloadRestaurantImage(url: restaurant.coverImgURL) { (coverImage) in
            DispatchQueue.main.async {
                self.restaurantImageView.image = coverImage
            }
        }
        
        Helpers.downloadRestaurantImage(url: restaurant.menus[0].popularItems[1].imageURL) { (coverImage) in
            DispatchQueue.main.async {
                self.popularItemImageView.image = coverImage
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
