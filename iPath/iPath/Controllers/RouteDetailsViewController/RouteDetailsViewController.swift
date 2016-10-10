//
//  RouteDetailsViewController.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 10/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class RouteDetailsViewController: UIViewController {
    
    // MARK: - PUBLIC -
    
    public init(route: Route) {
        self.route = route
        super.init(nibName: "RouteDetailsViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -

    private let route: Route
    
}
