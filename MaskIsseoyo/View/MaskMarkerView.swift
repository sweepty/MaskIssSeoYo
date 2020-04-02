//
//  MaskMarkerView.swift
//  MaskIsseoyo
//
//  Created by Seungyeon Lee on 2020/03/19.
//  Copyright © 2020 Seungyeon Lee. All rights reserved.
//

import MapKit

class MaskMarkerView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Set to show all annotations
        displayPriority = .required
        animatesWhenAdded = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let mask = newValue as? StoreAnnotation {
                markerTintColor = mask.level.color
                glyphText = mask.subtitle
                
            }
        }
    }
}
