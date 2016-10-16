//
//  NSArray+Remove.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 17/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import Foundation


extension Array where Element: Equatable {
    
    public mutating func remove(_ element: Element) {
        if let index = self.index(of: element) {
            self.remove(at: index)
        }
    }
    
}
