//
//  Route.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 09/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class Route {
    
    // MARK: - PUBLIC -
    
    public struct Place {
        let id: Int
        let latitude, longitude: Double
        let name: String
        
        internal init(data: NSDictionary) {
            self.id = Place.parse(data, key: "id", defaultValue: 0)
            self.latitude = Place.parse(data, key: "latitude", defaultValue: 0)
            self.longitude = Place.parse(data, key: "longitude", defaultValue: 0)
            self.name = Place.parse(data, key: "name", defaultValue: "Unknown")
        }
        
        static func parse<T>(_ data: NSDictionary, key: String, defaultValue: T) -> T {
            return data.object(forKey: key) as? T ?? defaultValue
        }
    }
    
    public let places: [Place]
    
    // MARK: - INTERNAL -
    
    internal init(json: NSArray) {
        self.places = json.map { Place(data: $0 as! NSDictionary) }
    }
    
    // MARK: - PRIVATE -

}
