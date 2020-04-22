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
  
  func setLocation() {
    let scbLocation = PublicLocation(title: "Siam Commercial Bank",
                                     locationName: "Headquarters",
                                     discipline: nil,
                                     coordinate: scbCoordinate)
    mapView.addAnnotation(scbLocation)
    mapView.centerViewOnMap(scbCoordinate, regionInMeter: regionInMeter)
  }
}

extension MKMapView {
  func centerViewOnMap(_ location: CLLocationCoordinate2D, regionInMeter: Double) {
    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
    setRegion(region, animated: true)
  }
}

extension ViewController: MKMapViewDelegate {
  
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
    mapView.setRegion(region, animated: true)
  }
}
