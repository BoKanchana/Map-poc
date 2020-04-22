//
//  PublicLocationView.swift
//  Map-SCB
//
//  Created by KANCHANA PHAKDEEDORN on 22/4/2563 BE.
//  Copyright © 2563 KANCHANA PHAKDEEDORN. All rights reserved.
//

import Foundation
import MapKit

class PublicLocationView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let location = newValue as? PublicLocation else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      image = location.image
    }
  }
}

