//
//  ViewController.swift
//  Map-poc
//
//  Created by KANCHANA PHAKDEEDORN on 22/4/2563 BE.
//  Copyright © 2563 KANCHANA PHAKDEEDORN. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  let regionInMeter: Double = 20000
  let scbCoordinate = CLLocationCoordinate2D(latitude: 13.8253414, longitude: 100.5668163)

  override func viewDidLoad() {
    super.viewDidLoad()
    checkLocationServices()
    setLocation()
    
  }
  
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setupLocationManager()
      checkLocationAuthorization()
    }
  }
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      mapView.showsUserLocation = true
      locationManager.startUpdatingLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    default:
      break
    }
  }
  
  func getDirection() {
    guard let location = locationManager.location?.coordinate else { return }
    let request = generateDirectionRequest(from: location, to: scbCoordinate)
    let direction = MKDirections(request: request)
    
    direction.calculate { [weak self] (response, error) in
      guard let response = response else { return }
      for route in response.routes {
        self?.mapView.addOverlay(route.polyline)
        self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
      }
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
  
  func setLocation() {
    let scbLocation = PublicLocation(title: "Siam Commercial Bank",
                                     locationName: "Headquarters",
                                     discipline: nil,
                                     coordinate: scbCoordinate)
    mapView.register(PublicLocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    mapView.addAnnotation(scbLocation)
    mapView.centerViewOnMap(scbCoordinate, regionInMeter: regionInMeter)
    getDirection()
  }
}

extension MKMapView {
  func centerViewOnMap(_ location: CLLocationCoordinate2D, regionInMeter: Double) {
    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
    setRegion(region, animated: true)
  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .blue
    renderer.alpha = 0.5
    renderer.lineWidth = 4
    return renderer
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
    mapView.setRegion(region, animated: true)
  }
}
