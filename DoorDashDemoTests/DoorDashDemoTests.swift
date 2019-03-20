//
//  DoorDashDemoTests.swift
//  DoorDashDemoTests
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import XCTest
import CoreLocation
@testable import DoorDashDemo

class DoorDashDemoTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testAPIClientWithResult() {
        let future = expectation(description: "Should receive a number of restaurants")
        let coordinate = CLLocationCoordinate2D(latitude: 40.697440, longitude: -73.979440)
        
        _ = APIClient.shared.fetchRestaurantData(for: coordinate, completion: { (restaurants, error) in
            XCTAssertTrue(restaurants.count > 0, "There should be more than 0 restaurants")
            future.fulfill()
        })
        waitForExpectations(timeout: 7, handler: nil)
    }

    func testAPIClientWithNoResult() {
        let future = expectation(description: "Should receive 0 restaurants")
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        _ = APIClient.shared.fetchRestaurantData(for: coordinate, completion: { (restaurants, error) in
            XCTAssertTrue(restaurants.count == 0, "There should be no restaurants")
            future.fulfill()
        })
        waitForExpectations(timeout: 7, handler: nil)
    }


}
