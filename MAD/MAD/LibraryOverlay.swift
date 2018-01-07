//
//  LibraryOverlay.swift
//  
//
//  Created by David McAllister on 1/1/18.
//

import UIKit
import MapKit

class LibraryOverlay: NSObject, MKOverlay {
    
    var boundingMapRect: MKMapRect
    var image: UIImage = #imageLiteral(resourceName: "mapOverlay")
    var coordinate: CLLocationCoordinate2D
    
    override init()
    {
        let x = MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.3373,  -122.04924))
        print("Bigs: " + String(describing: MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.33712,  -122.04898))))
        let y = MKMapSize(width: 400, height: 400)
        let z = MKMapRect(origin: x, size: y)
        boundingMapRect = z
        coordinate = CLLocationCoordinate2DMake(37.33712,  -122.04898)
        print("going big")
    }
    

}
