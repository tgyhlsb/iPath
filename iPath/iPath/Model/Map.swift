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
    public let places: [Int: Place]
    
    public init(name: String, data: NSArray) {
        self.name = name
        
        var places = [Int: Place]()
        for info in data {
            let place = Place(data: info as! NSDictionary)
            places[place.id] = place
        }
        self.places = places
    }
    
    public func distance(of path: [Place]) -> Double? {
        guard path.count >= 2 else { return nil }
        
        var distance = 0.0
        for (index, step) in path[0..<path.count-1].enumerated() {
            guard let place = self.places[step.id], let links = place.links else { return nil }
            let next = path[index+1]
            guard let link = links[next.id] else { return nil }
            distance += link.distance
        }
        return distance
    }
    
    public func path(from origin: Place, to destination: Place, exclude: [Place]) -> [Place]? {
        let excludeIds = exclude.map { $0.id }
        let places = Array(self.places.values.filter { !excludeIds.contains($0.id) })
        
        guard let origin = self.rectrieve(place: origin, in: places), let destination = self.rectrieve(place: destination, in: places) else { return nil }
        
        var distances = [Int: Double]()
        var previous = [Int: Int]()
        for (_, place) in self.places {
            distances[place.id] = DBL_MAX
        }
        distances[origin.id] = 0
        
        var unvisited = places
        var current: Place? = origin
        while current != nil {
            
            for link in current!.links!.values {
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
        
        var path = [destination]
        var iterator = previous[destination.id]
        while iterator != nil {
            guard let place = self.places[iterator!] else { return nil }
            path.append(place)
            iterator = previous[iterator!]
        }
        return path.reversed()
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
