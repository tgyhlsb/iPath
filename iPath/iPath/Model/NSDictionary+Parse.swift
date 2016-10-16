//
//  NSDictionary+Parse.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    public func parse<T>(key: String, defaultValue: T) -> T {
        return self.object(forKey: key) as? T ?? defaultValue
    }
    
}
