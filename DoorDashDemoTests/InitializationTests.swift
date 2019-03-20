//
//  InitializationTests.swift
//  DoorDashDemoTests
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import XCTest
@testable import DoorDashDemo

class InitializationTests: XCTestCase {

    func testRestaurantInitialization() {
        let restaurantJSON: [String: Any] = ["id": 82, "name": "Joe's Pizza", "description": "The best pizza in New York", "delivery_fee": 373, "cover_img_url": "https://cdn.doordash.com/media/restaurant/cover/joes_pizza.png", "asap_time": 37]
        
        guard let restaurantData = try? JSONSerialization.data(withJSONObject: restaurantJSON, options: []) else { assertionFailure("JSONSerialization data error"); return }
        guard let restaurant = try? JSONDecoder().decode(Restaurant.self, from: restaurantData) else { assertionFailure("JSONDecoder data error"); return }
//        let restaurant = Restaurant(json: restaurantJSON)
        
        XCTAssertNotNil(restaurant.id)
        XCTAssertNotNil(restaurant.name)
        XCTAssertNotNil(restaurant.description)
        XCTAssertNotNil(restaurant.deliveryFee)
        XCTAssertNotNil(restaurant.asapTime)
        XCTAssertNotNil(restaurant.coverImgURL)
    }
    
//    func testIncompleteRestaurantInitialization() {
//        let restaurantJSONWithoutName: [String: Any] = ["id": 82, "description": "The best pizza in New York", "delivery_fee": 373, "cover_img_url": "https://cdn.doordash.com/media/restaurant/cover/joes_pizza.png", "asap_time": 37]
//        
//        guard let restaurantData = try? JSONSerialization.data(withJSONObject: restaurantJSONWithoutName, options: []) else { assertionFailure("JSONSerialization data error"); return }
//        guard let restaurant = try? JSONDecoder().decode(Restaurant.self, from: restaurantData) else {  XCTAssertNil(restaurant) ; return }
//                let restaurant = Restaurant(json: restaurantJSON)
//        
//        XCTAssertNil(restaurant)
//    }

}
