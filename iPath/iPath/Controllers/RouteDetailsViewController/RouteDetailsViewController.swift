//
//  RouteDetailsViewController.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 10/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailsViewController: UIViewController {
    
    // MARK: - PUBLIC -
    
    public init(route: Route) {
        self.route = route
        super.init(nibName: "RouteDetailsViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - INTERNAL -
    
    internal var activePath: [Place]?
    
    // MARK: - PRIVATE -

    private let route: Route
    private var paths: [[Place]]!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segementedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Route"
        self.mapView.delegate = self
        
        self.initialize(for: self.route)
        self.processOtherPath(for: self.route)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.selectPath(at: 0)
    }
    
    private func initialize(for route: Route) {
        self.paths = [route.places]
        self.initializeMap(for: route)
        self.initializeTableView()
        self.updateSegementedControl(for: [route.places], map: route.map, animated: false)
    }
    
    // MARK: Helpers
    
    private func processOtherPath(for route: Route) {
        var places = route.places
        places.remove(route.start)
        places.remove(route.end)
        
        if let alternativePath = route.map.findPaths(from: route.start, to: route.end, exclude: places) {
            self.paths.append(alternativePath)
            self.updateSegementedControl(for: self.paths, map: route.map, animated: false)
        }
    }
    
    private func updateSegementedControl(for paths: [[Place]], map: Map, animated: Bool) {
        self.segementedControl.removeAllSegments()
        for (index, path) in paths.enumerated() {
            let distance = map.distance(of: path)
            let title = distance != nil ? "\(distance! * 10) m" : "Unknown distance"
            self.segementedControl.insertSegment(withTitle: title, at: index, animated: animated)
        }
        self.segementedControl.sizeToFit()
    }
    
    private func selectPath(at index: Int) {
        self.activePath = self.paths[index]
        self.segementedControl.selectedSegmentIndex = index
        self.reloadTableView()
        self.setOverlay(for: self.activePath!)
    }
    
    // MARK: Handlers

    @IBAction func segmentedControlHandler(_ sender: UISegmentedControl) {
        self.selectPath(at: sender.selectedSegmentIndex)
    }
}
