//
//  Reusable.swift
//  NasaFeed
//
//  Created by Tanguy Hélesbeux on 26/09/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

public protocol Reusable {
    
    static var reusableIdentifier: String { get }
    
}

public extension Reusable {
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
}

public extension UITableView {
    
    public func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }
    
}
