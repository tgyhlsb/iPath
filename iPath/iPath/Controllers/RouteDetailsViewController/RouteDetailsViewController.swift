//
//  RouteDetailsViewController.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 10/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailsViewController: UIViewController, MKMapViewDelegate {
    
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
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.title(from: self.route)
    }
    
    // MARK: Helpers
    
    private func title(from route: Route) -> String {
        return "\(route.places.count) places"
    }
}
