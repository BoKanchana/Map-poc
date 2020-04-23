//
//  PublicLocation.swift
//  Map-SCB
//
//  Created by KANCHANA PHAKDEEDORN on 22/4/2563 BE.
//  Copyright © 2563 KANCHANA PHAKDEEDORN. All rights reserved.
//

import Foundation
import MapKit

class PublicLocation: NSObject, MKAnnotation {
  let title: String?
  var distance: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(title: String?, locationName: String?, discipline: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.distance = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    super.init()
  }

  var subtitle: String? {
    return distance
  }
  
  var image: UIImage {
    return #imageLiteral(resourceName: "Flag")
  }
  
  func updateDistance(with distances: Double) {
    self.distance = distances.distanceInKilometers
  }
}
