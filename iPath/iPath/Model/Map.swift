//
//  Map.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class Map {
    
    // MARK: - PUBLIC -
    
    public let name: String
    public let places: [Place]
    
    public init(name: String, data: NSArray) {
        self.name = name
        self.places = data.map { Place(data: $0 as! NSDictionary) }
    }
    
    public func findPaths(from origin: Place, to destination: Place, count: Int) {
        guard let origin = self.rectrieve(place: origin, in: self.places),
            let destination = self.rectrieve(place: destination, in: self.places) else { return }
        
        var distances = [Int: Double]()
        var places = [Int: Place]()
        var previous = [Int: Int]()
        for place in self.places {
            distances[place.id] = DBL_MAX
            places[place.id] = place
        }
        distances[origin.id] = 0
        
        var unvisited = self.places
        var current: Place? = origin
        while current != nil {
            
            for link in current!.links ?? [] {
                let distance = distances[current!.id]! + link.distance
                if distance < distances[link.destination]! {
                    distances[link.destination] = distance
                    previous[link.destination] = current!.id
                }
            }
            
            if let index = unvisited.index(of: current!) {
                unvisited.remove(at: index) // Remove current from unvisited
            }
            
            if current == destination {
                break
            }
            current = self.minimum(distances, unvisited)
        }
        
        print(distances[destination.id])
        var iterator = previous[destination.id]
        while iterator != nil {
            print(iterator!)
            iterator = previous[iterator!]
        }
    }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -
    
    private func rectrieve(place: Place, in array: [Place]) -> Place? {
        for p in array {
            if p.id == place.id {
                return p
            }
        }
        return nil
    }
    
    private func minimum(_ distances: [Int: Double], _ places: [Place]) -> Place? {
        var minimum: Place? = nil
        var minimumDistance = DBL_MAX
        for place in places {
            guard let distance = distances[place.id] else { continue }
            if distance < minimumDistance {
                minimumDistance = distance
                minimum = place
            }
        }
        return minimum
    }
    

}
