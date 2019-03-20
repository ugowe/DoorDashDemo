//
//  Constants.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct API {
        static let apiEndpoint = "https://api.doordash.com"
        static let restaurantPath = "v1/store_search/"
    }
    
    struct Segues {
        static let showExploreVCSegue = "showExploreVCSegue"
        static let showRestaurantVCSegue = "showRestaurantVCSegue"
    }
    
    struct Assets {
        static let navAddress = "nav-address"
    }
    
    struct Colors {
        static let doorDashRed = #colorLiteral(red: 1, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    }
    
}
