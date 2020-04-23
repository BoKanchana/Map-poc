//
//  Map.swift
//  Map-poc
//
//  Created by KANCHANA PHAKDEEDORN on 23/4/2563 BE.
//  Copyright © 2563 KANCHANA PHAKDEEDORN. All rights reserved.
//

import Foundation
import MapKit

public extension MKMapView {
  func centerViewOnMap(_ location: CLLocationCoordinate2D, regionInMeter: Double) {
    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
    setRegion(region, animated: true)
  }
}

public extension Double {
  var distanceInKilometers: String? {
    let formatter = NumberFormatter()
    let meters = NSNumber(value: self / 1000)
    formatter.maximumFractionDigits = 2
    
    return formatter.string(from: meters)
  }
}


