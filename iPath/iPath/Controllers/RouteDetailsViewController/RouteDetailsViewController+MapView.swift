//
//  RouteDetailsViewController+MapView.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 17/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit
import MapKit

extension RouteDetailsViewController: MKMapViewDelegate {
    
    // MARK: - PUBLIC -
    
    // MARK: - INTERNAL -
    
    internal func zoom(for places: [Place], animated: Bool) {
        guard let region = self.region(from: places) else { return }
        self.mapView.setRegion(region, animated: animated)
    }
    
    internal func initializeMap(for route: Route) {
        self.mapView.add(self.overlay(from: route.places))
        self.mapView.addAnnotations(self.annotations(for: route))
        self.zoom(for: route.places, animated: false)
    }
    
    internal func setOverlay(for path: [Place]) {
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.add(self.overlay(from: path))
        self.zoom(for: path, animated: true)
    }
    
    // MARK: - PRIVATE -
    
    private func overlay(from places: [Place]) -> MKPolyline {
        let coordinates = places.map { place in
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
    
    private func region(from places: [Place]) -> MKCoordinateRegion? {
        guard let first = places.first else { return nil }
        var maxLat = first.latitude
        var maxLong = first.longitude
        var minLat = maxLat
        var minLong = maxLong
        for place in places {
            maxLat = max(maxLat, place.latitude)
            maxLong = max(maxLong, place.longitude)
            minLat = min(minLat, place.latitude)
            minLong = min(minLong, place.longitude)
        }
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLong - minLong)
        let center = CLLocationCoordinate2D(latitude: minLat + span.latitudeDelta/2.00, longitude: minLong + span.longitudeDelta/2.00)
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
