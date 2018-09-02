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
            return
        }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        UIGraphicsPushContext(context)
        
        overlay.image.draw(in: rect)
        UIGraphicsPopContext()
    }

}

