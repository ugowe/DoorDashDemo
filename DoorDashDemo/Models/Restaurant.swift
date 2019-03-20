//
//  Restaurant.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit

struct Restaurant: Decodable {
    
    struct PopularItem: Decodable {
        let name: String
        let imageURL: URL
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case imageURL = "img_url"
        }
    }
    
    struct Menu: Decodable {
        let popularItems: [PopularItem]
        
        enum CodingKeys: String, CodingKey {
            case popularItems = "popular_items"
        }
    }
    
    var id: Int
    let name: String
    let description: String
    let deliveryFee: Int
    let asapTime: Int
    let coverImgURL: URL
    let menus: [Menu]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case deliveryFee = "delivery_fee"
        case coverImgURL = "cover_img_url"
        case asapTime = "asap_time"
        case menus = "menus"
    }
}
