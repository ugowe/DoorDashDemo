//
//  Helpers.swift
//  DoorDashDemo
//
//  Created by Joseph Ugowe on 3/6/19.
//  Copyright © 2019 Joseph Ugowe. All rights reserved.
//

import Foundation
import UIKit

struct Helpers {
    
    static func downloadRestaurantImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let imageData = data else { print("Issue parsing imageData"); return }
                
                if let image = UIImage(data: imageData){
                    completion(image)
                }
            }
            }.resume()
    }
}
