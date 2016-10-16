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
    
    public init(route: Route, backend: BackendManager) {
        self.route = route
        self.backend = backend
        super.init(nibName: "RouteDetailsViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -

    private let route: Route
    private let backend: BackendManager
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.initialize(for: self.route)
        
        self.backend.fetchMap(name: "map1.json") { (result) in
            switch result {
            case .failure(let err): NSLog(err)
            case .success(let map): self.processOtherRoutes(in: map)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.zoom(to: self.route, animated: animated)
    }
    
    private func initialize(for route: Route) {
        self.title = self.title(from: route)
        self.mapView.add(self.overlay(from: route))
        self.mapView.addAnnotations(self.annotations(for: route))
    }
    
    // MARK: Helpers
    
    private func title(from route: Route) -> String {
        return "\(route.places.count) places"
    }
    
    private func processOtherRoutes(in map: Map) {
        map.findPaths(from: self.route.start, to: self.route.end, count: 0)
    }
    
    // MARK: - MapView
    
    private func zoom(to route: Route, animated: Bool) {
        guard let region = self.region(from: route) else { return }
        self.mapView.setRegion(region, animated: animated)
    }
    
    private func overlay(from route: Route) -> MKPolyline {
        let coordinates = route.places.map { place in
            return CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        }
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    private func annotations(for route: Route) -> [MKAnnotation] {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: route.start.latitude, longitude: route.start.longitude)
        startAnnotation.title = route.start.name
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = CLLocationCoordinate2D(latitude: route.end.latitude, longitude: route.end.longitude)
        endAnnotation.title = route.end.name
        
        return [startAnnotation, endAnnotation]
    }
    
    private func region(from route: Route) -> MKCoordinateRegion? {
        guard let first = route.places.first else { return nil }
        var maxLat = first.latitude
        var maxLong = first.longitude
        var minLat = maxLat
        var minLong = maxLong
        for place in route.places {
            maxLat = max(maxLat, place.latitude)
            maxLong = max(maxLong, place.longitude)
            minLat = min(minLat, place.latitude)
            minLong = min(minLong, place.longitude)
        }
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLong - minLong)
        let center = CLLocationCoordinate2D(latitude: minLat + span.latitudeDelta, longitude: minLong + span.longitudeDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3
        renderer.strokeColor = UIColor.red
        renderer.lineCap = .round
        return renderer
    }
}
