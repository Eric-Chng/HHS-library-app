//
//  FirstViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C, David McAllister, Varun Tandon All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    //@IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    var timer: Timer = Timer()
    var timeCounter: Int = 0
    let location = CLLocationCoordinate2DMake(37.33712,  -122.04898)
    let regionRadius: CLLocationDistance = 10
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.mapType = MKMapType.satellite;
        if UserDefaults.standard.object(forKey: "FirstLogin") == nil
        {
        UserDefaults.standard.set("false", forKey: "FirstLogin")
            self.performSegue(withIdentifier: "LaunchHelp", sender: self)

        }

        //navBar.title = "Home"
        //navigationItem.title="Home"
        setupNavigationBarItems()
    navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.\
        
        
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        //mapView.setRegion(MKCoordinateRegion(), animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeViewController.action), userInfo: nil,  repeats: true)
        
    
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        //self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.0005, 0.0005)), animated: true)
        
        
       // MKOverlayView(
       // var vertex: UnsafePointer<MKMapPoint> = [x]
        //vertex.
        let point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.3373,  -122.04925))
        let point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.33694,  -122.04925))
        let point3 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.33694,  -122.0487))
        let point4 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(37.3373,  -122.0487))
        /*vertex.append(CLLocationCoordinate2DMake(37.3373,  -122.0492))
        vertex.append(CLLocationCoordinate2DMake(37.3369,  -122.0492))
        vertex.append(CLLocationCoordinate2DMake(37.3369,  -122.0478))
        vertex.append(CLLocationCoordinate2DMake(37.3373,  -122.0478))
         */
        //mapView.addOverlay(MKPolygon)
        
        //MKOverlayView(MKPolygon)
       // mapView.add(MKPolygon)
        //mapView.add()
        //let m = MKOverlayView(
        
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        //mapView.setRegion(coordinateRegion, animated: true)
        let diskOverlay: MKCircle = MKCircle(center: location, radius: 10)
        let squareOverlay: MKPolygon = MKPolygon(points: [point1, point2, point3, point4], count: 4)

        //mapView.add(diskOverlay)
        //mapView.add(squareOverlay)

        
        
    }
    
    
    
    @objc func action()
    {
        //print("hello")
        timeCounter = timeCounter + 1
        if(timeCounter == 10)
        {
            //let duration = NSTimeIntervl
            MKMapView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33708,  -122.04896), MKCoordinateSpanMake(0.0005, 0.0005)), animated: true)
                }, completion: nil)
            
            
         // mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.0004, 0.00045)), animated: true)
        }
        if(timeCounter == 25)
        {
            MKMapView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.mapView.mapType = MKMapType.standard;
                

            }, completion: nil)
            
        }
        if(timeCounter == 26)
        {
            let overlay = LibraryOverlay()
            self.mapView.add(overlay)
        }
        if(timeCounter == 35)
        {
            MKMapView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33708,  -122.04896), MKCoordinateSpanMake(0.0005, 0.0005)), animated: true)
            }, completion: nil)
        }
    }
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    
    
    private func setupNavigationBarItems()
    {
        navigationItem.title = "Home"
        
    }
    
    
    @IBOutlet weak var UIScrollView: UIScrollView!
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   

}

extension HomeViewController: MKMapViewDelegate
{
    
    
    /*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("made it here")
        if overlay is LibraryOverlay {
            return LibraryOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "mapOverlay"))
        }
        return MKOverlayRenderer()
    }
 */
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blue
            circleRenderer.alpha = 0.05
            return circleRenderer
        }
        else if let overlay = overlay as? MKPolygon {
            let circleRenderer = MKPolygonRenderer(polygon: overlay)
            circleRenderer.fillColor = UIColor.red
            circleRenderer.alpha = 0.05
            return circleRenderer
        }
        else {
            //print("hellos")
            if overlay is LibraryOverlay {
                //print("bigs")
                return LibraryOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "mapOverlay"))
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    
    
    
    
    
    
}

