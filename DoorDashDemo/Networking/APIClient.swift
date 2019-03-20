//
//  APIClient.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 2/17/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class APIClient {
    
    // MARK: Singleton
    
    static let shared = APIClient()
    private init() {}
    
    // MARK: - Properties
    
    typealias JSONDictionary = [String: Any]
    typealias RestaurantDataCompletionBlock = ([Restaurant], String) -> Void
    
    var restaurants: [Restaurant] = []
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    // MARK: - Methods
    
    func fetchRestaurantData(for coordinate: CLLocationCoordinate2D, completion: @escaping RestaurantDataCompletionBlock) {
        
        dataTask?.cancel()
        
        guard let url = URL(string: Constants.API.apiEndpoint) else { return }
        let restaurantURL = url.appendingPathComponent(Constants.API.restaurantPath)
        guard let urlComponents = NSURLComponents(url: restaurantURL, resolvingAgainstBaseURL: true) else { return }
        
        let latitudeQueryItem = URLQueryItem(name: "lat", value: String(coordinate.latitude))
        let longitudeQueryItem = URLQueryItem(name: "lng", value: String(coordinate.longitude))
        urlComponents.queryItems = [latitudeQueryItem, longitudeQueryItem]
        guard let urlComponentsURL = urlComponents.url else { return }
        
        dataTask = defaultSession.dataTask(with: urlComponentsURL) { (data, response, error) in
            defer { self.dataTask = nil }
            
            if let error = error {
                self.errorMessage += "DataTask error: \(error.localizedDescription)"
            } else if let data = data {
                self.deserializeRestaurantData(data)
                
                completion(self.restaurants, self.errorMessage)
            }
        }
        
        dataTask?.resume()
    }
    
    private func deserializeRestaurantData(_ data: Data) {
        var response: [Restaurant]?
        
        do {
            response = try JSONDecoder().decode([Restaurant].self, from: data)
        } catch let parseError as NSError {
            errorMessage += "JSONDecoder error: \(parseError.localizedDescription)"
            return
        }
        
        guard let restaurantArray = response else {
            errorMessage += "Restaurant dictionary does not contain results\n"
            return
        }
        
        self.restaurants = restaurantArray
    }
}
