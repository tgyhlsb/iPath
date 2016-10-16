//
//  Route.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 09/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class Route: Equatable {
    
    // MARK: - PUBLIC -
    
    public let map: Map
    public let token: String
    public let places: [Place]
    public let distance: Double
    
    public var start: Place {
        return self.places.first!
    }
    
    public var end: Place {
        return self.places.last!
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: Route, rhs: Route) -> Bool {
        return lhs.token == rhs.token
    }
    
    // MARK: - INTERNAL -
    
    internal init?(map: Map, token: String, json: NSArray) {
        guard json.count >= 2 else { return nil }
        self.map = map
        self.token = token
        
        var places = [Place]()
        for data in json {
            guard let info = data as? NSDictionary else { return nil }
            let id = info.parse(key: "id", defaultValue: 0)
            guard let place = map.places[id] else { return nil }
            places.append(place)
        }
        self.places = places
        
        guard let distance = map.distance(of: self.places) else { return nil }
        self.distance = distance
    }
    
    // MARK: - PRIVATE -

}
