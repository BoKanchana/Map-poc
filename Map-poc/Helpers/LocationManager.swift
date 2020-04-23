//
//  LocationManager.swift
//  Map-poc
//
//  Created by KANCHANA PHAKDEEDORN on 23/4/2563 BE.
//  Copyright © 2563 KANCHANA PHAKDEEDORN. All rights reserved.
//

import Foundation
import MapKit

public class LocationManager: NSObject, CLLocationManagerDelegate {
  private var locationManager = CLLocationManager()
  
  func checkLocationIsAuthorization() -> Bool {
    if CLLocationManager.locationServicesEnabled() {
      setupLocationManager()
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        return true
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      default:
        break
      }
    }
    locationManager.requestWhenInUseAuthorization()
    return false
  }
  
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func getDirectionFromCurrentLocation(to destination: CLLocationCoordinate2D, completion: @escaping ([MKRoute]) -> Void) {
    guard let location = locationManager.location?.coordinate else { return }
    let request = generateDirectionRequest(from: location, to: destination)
    let direction = MKDirections(request: request)
    direction.calculate { (response, error) in
      guard let response = response else { return }
      completion(response.routes)
    }
  }
  
  func generateDirectionRequest(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> MKDirections.Request {
    let start = MKPlacemark(coordinate: coordinate1)
    let destination = MKPlacemark(coordinate: coordinate2)
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: start)
    request.destination = MKMapItem(placemark: destination)
    request.transportType = .automobile
    request.requestsAlternateRoutes = true
    
    return request
  }
}
