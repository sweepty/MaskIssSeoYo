//
//  StoreAnnotationView.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/18.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import Foundation
import MapKit

class StoreAnnotation: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let subtitle: String?
    let level: MaskRemainLevel
    let coordinate: CLLocationCoordinate2D
    
    init(store: Store) {
        self.id = store.code
        self.title = store.name
        self.subtitle = store.maskRemainLevel.rawValue
        self.level = store.maskRemainLevel
        self.coordinate = store.locationCoordinate
    }
}
