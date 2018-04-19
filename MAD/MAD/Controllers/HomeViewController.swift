//
//  FirstViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C, David McAllister All rights reserved.
//

/*
import UIKit
import MapKit
import ScalingCarousel

/*
class HomeCell: ScalingCarouselCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
*/

class Cell: ScalingCarouselCell {}

    
    class HomeViewController: UIViewController/*, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource */{
        
        
    
    
   
    //fileprivate var scalingCarousel: ScalingCarouselView!


    //@IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    var timer: Timer = Timer()
    var timeCounter: Int = 0
    let location = CLLocationCoordinate2DMake(37.33712,  -122.04898)
    let regionRadius: CLLocationDistance = 10
    
    @IBOutlet weak var hoursView: UIView!
    
    @IBOutlet weak var hoursButton: UILabel!
    
    @IBOutlet weak var bookCarousel: ScalingCarouselView!
    
    
    /*
    private func addCarousel() {
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        scalingCarousel = ScalingCarouselView(withFrame: frame, andInset: 20)
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        scalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        scalingCarousel.backgroundColor = .white
        
        scalingCarousel.register(HomeCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(scalingCarousel)
        
        // Constraints
        scalingCarousel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scalingCarousel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        scalingCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scalingCarousel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    }
    */
    
        var currentID: Int = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        //addCarousel()

        self.hoursButton.layer.cornerRadius = 12
        self.hoursButton.layer.masksToBounds = true
        mapView.delegate = self
        self.tabBarController?.tabBar.isHidden = false
        hoursView.layer.cornerRadius = 25
        hoursView.layer.masksToBounds = true
        self.mapView.mapType = MKMapType.satellite;
        self.bookCarousel.delegate = self
        
        self.bookCarousel.dataSource = self
        self.bookCarousel.translatesAutoresizingMaskIntoConstraints = false

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
        
        
       

        
        
    }
    
    @available(iOS, deprecated: 9.0)
    @IBAction func reviewTestButton(_ sender: Any) {
        let reviewController = self.storyboard?.instantiateViewController(withIdentifier: "reviewController") as! ReviewViewController
        reviewController.setBookModel(model: BookModel(ISBN: "9781594480003"))
        self.present(reviewController, animated: true, completion: nil)
    }
    
    
    @objc func action()
    {
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
            let fantasyAnnotationCords = CLLocationCoordinate2DMake(37.3372,  -122.04904)
            let fantasyAnnotation = MKPointAnnotation.init()
            fantasyAnnotation.coordinate = fantasyAnnotationCords
            fantasyAnnotation.title = "Fantasy"
            self.mapView.addAnnotation(fantasyAnnotation)
            
            let mysteryAnnotationCords = CLLocationCoordinate2DMake(37.3372,  -122.048819)
            let mysteryAnnotation = MKPointAnnotation.init()
            mysteryAnnotation.coordinate = mysteryAnnotationCords
            mysteryAnnotation.title = "Mystery"
            self.mapView.addAnnotation(mysteryAnnotation)
            
            let scifiAnnotationCords = CLLocationCoordinate2DMake(37.3371,  -122.048796)
            let scifiAnnotation = MKPointAnnotation.init()
            scifiAnnotation.coordinate = scifiAnnotationCords
            scifiAnnotation.title = "Sci-Fi"
            self.mapView.addAnnotation(scifiAnnotation)
            
            let referenceAnnotationCords = CLLocationCoordinate2DMake/*(37.3372,  -122.048796)*/(37.33715,  -122.04892)
            let referenceAnnotation = MKPointAnnotation.init()
            referenceAnnotation.coordinate = referenceAnnotationCords
            referenceAnnotation.title = "Reference"
            self.mapView.addAnnotation(referenceAnnotation)
            
            let computerAnnotationCords = CLLocationCoordinate2DMake/*(37.3372,  -122.048796)*/(37.33704,  -122.04887)
            let computerAnnotation = MKPointAnnotation.init()
            computerAnnotation.coordinate = computerAnnotationCords
            computerAnnotation.title = "Computer"
            self.mapView.addAnnotation(computerAnnotation)
            
            //self.mapView.addAnnotation(annotation)
            
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
    
    
    @IBAction func hoursButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string : "http://www.hhs.fuhsd.org/library")!, options: [:], completionHandler: { (status) in
            
        })
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = #imageLiteral(resourceName: "xButton")
            let temp = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: "temp")
            //temp.glyphImage = #imageLiteral(resourceName: "xButton")
            if(annotation.title!!.isEqual("Fantasy") == true)
            {
            temp.glyphImage = #imageLiteral(resourceName: "fantasySmall")
            temp.selectedGlyphImage = #imageLiteral(resourceName: "fantasyBig")
            temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
            }
            else if(annotation.title!!.isEqual("Mystery") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "mysterySmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "mysteryBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.blue
            }
            else if(annotation.title!!.isEqual("Sci-Fi") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "scifiSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "scifiBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                //temp.markerTintColor = UIColor.blue
            }
            else if(annotation.title!!.isEqual("Reference") == true)
            {
                print("Reference")
                temp.glyphImage = #imageLiteral(resourceName: "referenceSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "referenceBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.darkGray
            }
            else if(annotation.title!!.isEqual("Computer") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "computerSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "computerBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.cyan
            }
            //temp.glyphText = "Fantasy"
            //temp.title
            temp.titleVisibility = .adaptive
            // if you want a disclosure button, you'd might do something like:
            //
            let detailButton = UIButton(type: .infoLight)
            annotationView?.rightCalloutAccessoryView = detailButton
            return temp

        } else
        {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
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
            if overlay is LibraryOverlay {
                return LibraryOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "mapOverlay2"))
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    }



extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //print("requesting number of recommendations")
    return 10;
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //print("requesting cell")
    
    //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendationCell", for: indexPath)
    /*
    if let scalingCell = cell as? HomeRecommendationCollectionViewCell {
        scalingCell.mainView.backgroundColor = .red
    }
 */
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
    if let scalingCell = cell as? ScalingCarouselCell {
        scalingCell.mainView.backgroundColor = .red
    }
    
    cell.setNeedsLayout()
    cell.layoutIfNeeded()
    return cell;
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
{
    print(indexPath.row)
}

    
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //carousel.didScroll()
    
    guard let currentCenterIndex = bookCarousel.currentCenterCellIndex?.row else { return }
    
    //(bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).mainView.backgroundColor = UIColor.blue
    
    print((bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).cellID)
    //book.constant = (carouselBottomConstraint.constant == Constants.carouselShowConstant ? Constants.carouselHideConstant : Constants.carouselShowConstant)
    
    //self.bookCarousel.const
    if(self.currentID != (bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).cellID)
    {
        print("happened once")
        for x in (bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).constraints
        {
            print(x.firstAttribute)
            let temp = x.firstAttribute
            if(temp.rawValue == NSLayoutAttribute.height.rawValue)
            {
                bookCarousel.currentCenterCell?.removeConstraints((bookCarousel.currentCenterCell?.constraints)!)
                print("killing constraint")
            }
        }
        //(bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).removeConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
    let heightConstraint = NSLayoutConstraint(item: (bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell), attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 190)
    //view.addConstraints([heightConstraint])
    }

    self.currentID = (bookCarousel.currentCenterCell as! HomeRecommendationCollectionViewCell).cellID

    
    UIView.animate(withDuration: 0.5, animations: {
        self.view.layoutIfNeeded()
    })

    //output.text = String(describing: currentCenterIndex)
}



}
*/


//
//  CodeViewController.swift
//  ScalingCarousel
//
//  Created by Pete Smith on 29/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ScalingCarousel

import MapKit

class CodeCell: ScalingCarouselCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties (Private)
    fileprivate var scalingCarousel: ScalingCarouselView!
    @IBOutlet weak var mapView: MKMapView!
    var timer: Timer = Timer()
    var timeCounter: Int = 0
    let location = CLLocationCoordinate2DMake(37.33712,  -122.04898)
    let regionRadius: CLLocationDistance = 10
    
    @IBOutlet weak var innerScrollView: UIView!
    @IBOutlet weak var hoursView: UIView!
    
    @IBOutlet weak var hoursButton: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCarousel()
        self.hoursButton.layer.cornerRadius = 12
        self.hoursButton.layer.masksToBounds = true
        mapView.delegate = self
        self.tabBarController?.tabBar.isHidden = false
        hoursView.layer.cornerRadius = 25
        hoursView.layer.masksToBounds = true
        self.mapView.mapType = MKMapType.satellite;
        /*
         self.bookCarousel.delegate = self
         
         self.bookCarousel.dataSource = self
         self.bookCarousel.translatesAutoresizingMaskIntoConstraints = false
         */
        //navBar.title = "Home"
        //navigationItem.title="Home"
        //setupNavigationBarItems()
            navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view, typically from a nib.\
        
        
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        //mapView.setRegion(MKCoordinateRegion(), animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeViewController.action), userInfo: nil,  repeats: true)
        
        
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        //self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.0005, 0.0005)), animated: true)
        
        
        
        
        
    }
    
    @objc func action()
    {
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
            let fantasyAnnotationCords = CLLocationCoordinate2DMake(37.3372,  -122.04904)
            let fantasyAnnotation = MKPointAnnotation.init()
            fantasyAnnotation.coordinate = fantasyAnnotationCords
            fantasyAnnotation.title = "Fantasy"
            self.mapView.addAnnotation(fantasyAnnotation)
            
            let mysteryAnnotationCords = CLLocationCoordinate2DMake(37.3372,  -122.048819)
            let mysteryAnnotation = MKPointAnnotation.init()
            mysteryAnnotation.coordinate = mysteryAnnotationCords
            mysteryAnnotation.title = "Mystery"
            self.mapView.addAnnotation(mysteryAnnotation)
            
            let scifiAnnotationCords = CLLocationCoordinate2DMake(37.3371,  -122.048796)
            let scifiAnnotation = MKPointAnnotation.init()
            scifiAnnotation.coordinate = scifiAnnotationCords
            scifiAnnotation.title = "Sci-Fi"
            self.mapView.addAnnotation(scifiAnnotation)
            
            let referenceAnnotationCords = CLLocationCoordinate2DMake/*(37.3372,  -122.048796)*/(37.33715,  -122.04892)
            let referenceAnnotation = MKPointAnnotation.init()
            referenceAnnotation.coordinate = referenceAnnotationCords
            referenceAnnotation.title = "Reference"
            self.mapView.addAnnotation(referenceAnnotation)
            
            let computerAnnotationCords = CLLocationCoordinate2DMake/*(37.3372,  -122.048796)*/(37.33704,  -122.04887)
            let computerAnnotation = MKPointAnnotation.init()
            computerAnnotation.coordinate = computerAnnotationCords
            computerAnnotation.title = "Computer"
            self.mapView.addAnnotation(computerAnnotation)
            
            //self.mapView.addAnnotation(annotation)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    
    private func addCarousel() {
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        scalingCarousel = ScalingCarouselView(withFrame: frame, andInset: 100)
        scalingCarousel.dataSource = self
        scalingCarousel.delegate = self
        scalingCarousel.translatesAutoresizingMaskIntoConstraints = false
        scalingCarousel.backgroundColor = .white
        
        scalingCarousel.register(CodeCell.self, forCellWithReuseIdentifier: "cell")
        
        innerScrollView.addSubview(scalingCarousel)
        
        // Constraints
        scalingCarousel.widthAnchor.constraint(equalTo: innerScrollView.widthAnchor, multiplier: 1).isActive = true
        scalingCarousel.heightAnchor.constraint(equalToConstant: 260).isActive = true
        scalingCarousel.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor).isActive = true
        scalingCarousel.topAnchor.constraint(equalTo: innerScrollView.topAnchor, constant: 10).isActive = true
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .blue
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //scalingCarousel.didScroll()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = #imageLiteral(resourceName: "xButton")
            let temp = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: "temp")
            //temp.glyphImage = #imageLiteral(resourceName: "xButton")
            if(annotation.title!!.isEqual("Fantasy") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "fantasySmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "fantasyBig")
                temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
            }
            else if(annotation.title!!.isEqual("Mystery") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "mysterySmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "mysteryBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.blue
            }
            else if(annotation.title!!.isEqual("Sci-Fi") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "scifiSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "scifiBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                //temp.markerTintColor = UIColor.blue
            }
            else if(annotation.title!!.isEqual("Reference") == true)
            {
                print("Reference")
                temp.glyphImage = #imageLiteral(resourceName: "referenceSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "referenceBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.darkGray
            }
            else if(annotation.title!!.isEqual("Computer") == true)
            {
                temp.glyphImage = #imageLiteral(resourceName: "computerSmall")
                temp.selectedGlyphImage = #imageLiteral(resourceName: "computerBig")
                //temp.markerTintColor = UIColor.init(red: 0.92, green: 0.63, blue: 1.0, alpha: 1.0)
                temp.markerTintColor = UIColor.cyan
            }
            //temp.glyphText = "Fantasy"
            //temp.title
            temp.titleVisibility = .adaptive
            // if you want a disclosure button, you'd might do something like:
            //
            let detailButton = UIButton(type: .infoLight)
            annotationView?.rightCalloutAccessoryView = detailButton
            return temp
            
        } else
        {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
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
            if overlay is LibraryOverlay {
                return LibraryOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "mapOverlay2"))
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}





/*
//typealias CarouselDatasource = StoryboardViewController
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .red
        }
        
        return cell
    }
}

//typealias CarouselDelegate = StoryboardViewController
extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = bookCarousel.currentCenterCellIndex?.row else { return }
        
        //output.text = String(describing: currentCenterIndex)
    }
}

//private typealias ScalingCarouselFlowDelegate = StoryboardViewController
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
*/




/*
    extension HomeViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 8
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            if let scalingCell = cell as? ScalingCarouselCell {
                scalingCell.mainView.backgroundColor = .blue
            }
            
            return cell
        }
    }
    
    extension HomeViewController: UICollectionViewDelegate {
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            //scalingCarousel.didScroll()
        }
    }
    
    
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("requesting number of recommendations")
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("requesting cell")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendationCell", for: indexPath)
        if let scalingCell = cell as? HomeRecommendationCollectionViewCell {
            scalingCell.mainView.backgroundColor = .red
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = self.bookCarousel.currentCenterCellIndex?.row else { return }
        
        //output.text = String(describing: currentCenterIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
 
    


/*
extension DiscoverViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularBookArr.count
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        _ = UICollectionViewCell()
        if(collectionView.restorationIdentifier! == "facebookFeed")
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacebookReviewsCollectionViewCell", for: indexPath) as! FacebookReviewsCollectionViewCell
            
            if(self.reviewArr.count > indexPath.row)
            {
                cell.reviewModel = self.reviewArr[indexPath.row]
            }
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookThumbNailCell", for: indexPath) as! BookCoverCollectionViewCell
            let row = indexPath.row
            if(collectionView.restorationIdentifier! == "librarianRecommended")
            {
                //insert data for librarian recommended section
                if(librarianBookArr[row].BookCoverImage != nil)
                {
                    cell.coverImageView.image = librarianBookArr[row].BookCoverImage.image
                }
                cell.titleLabel.text = librarianBookArr[row].title
            }
            else if(collectionView.restorationIdentifier! == "popularTitles")
            {
                //insert data for popular titles section
                if(popularBookArr[row].BookCoverImage != nil)
                {
                    cell.coverImageView.image = popularBookArr[row].BookCoverImage.image
                }
                cell.titleLabel.text = popularBookArr[row].title
            }
            return cell
        }
        //return cell
    }

}

extension DiscoverViewController
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //code for collection view pressed
        var stopSegue: Bool = false
        if(collectionView.restorationIdentifier! == "librarianRecommended")
        {
            if(self.librarianBookArr.count > indexPath.item)
            {
                self.pressedItem = librarianBookArr[indexPath.item]
            }
        }
        else if(collectionView.restorationIdentifier! == "popularTitles")
        {
            if(self.popularBookArr.count > indexPath.item)
            {
                self.pressedItem = popularBookArr[indexPath.item]
            }
            
        }
        else if(collectionView.restorationIdentifier! == "facebookFeed")
        {
            stopSegue = true
            //self.p
            //self.pressedItem =
            if(self.reviewArr.count > indexPath.item && reviewArr[indexPath.item].bookModel.ISBN != nil)
            {
                stopSegue = false
                self.pressedItem = reviewArr[indexPath.item].bookModel
            }
            
        }
        if(stopSegue == false)
        {
            self.performSegue(withIdentifier: "collectionViewDetail", sender: self)
        }
        
    }

}

 */*/
