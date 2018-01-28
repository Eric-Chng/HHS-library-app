//
//  LibraryOverlayView.swift
//  MAD
//
//  Created by David McAllister on 1/1/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import MapKit

class LibraryOverlayView: MKOverlayRenderer {
    
    var overlayImage: UIImage
    
    init(overlay:MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        guard let overlay = self.overlay as? LibraryOverlay else {
            //print("scuffed")
            return
        }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        //print("BoundingRect: " + String(describing: overlay.boundingMapRect))
        UIGraphicsPushContext(context)
        
        overlay.image.draw(in: rect)
        UIGraphicsPopContext()
        
        
        
        
        /*
        guard let imageReference = #imageLiteral(resourceName: "mapOverlay").cgImage else {
            print("Didn't work")
            return
            
        }
        //print(imageReference)
        //print("MapRect: " + String(describing: mapRect))
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
         */
    }

}

