//
//  RestaurantTableViewCell.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    // MARK: - Properties
    
    static let cellIdentifier = "RestaurantTableViewCell"
    static let nibName = "RestaurantTableViewCell"
    let imageCornerRadius: CGFloat = 5.0
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.layer.cornerRadius = imageCornerRadius
        coverImageView.layer.masksToBounds = true
    }
    
}
