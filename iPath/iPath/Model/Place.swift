//
//  Place.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import Foundation

struct Place: Equatable {
    
    public struct Link {
        let destination: Int
        let distance: Double
        
        init(data: NSDictionary) {
            self.destination = data.parse(key: "id", defaultValue: 0)
            self.distance = data.parse(key: "distance", defaultValue: 0.0)
        }
    }
    
    public let id: Int
    public let latitude, longitude: Double
    public let name: String
    public let links: [Link]?
    
    public init(data: NSDictionary) {
        self.id = data.parse(key: "id", defaultValue: 0)
        self.latitude = data.parse(key: "latitude", defaultValue: 0)
        self.longitude = data.parse(key: "longitude", defaultValue: 0)
        self.name = data.parse(key: "name", defaultValue: "Unknown")
        
        if let linksData = data.object(forKey: "links") as? [NSDictionary] {
            self.links = linksData.map { Link(data: $0) }
        } else {
            self.links = nil
        }
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
}
