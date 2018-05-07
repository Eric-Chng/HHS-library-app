
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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
       // navigationController?.navigationBar.barTintColor = UIColor(red: 160/255, green: 196/255, blue: 1, alpha: 1)
        //160, 196, 255
        // Do any additional setup after loading the view, typically from a nib.\
        
        scrollView.delegate = self
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        //mapView.setRegion(MKCoordinateRegion(), animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeViewController.action), userInfo: nil,  repeats: true)
        
        
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        //self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.0005, 0.0005)), animated: true)
        setUpProfileButton()
        
        imageView.setImage(#imageLiteral(resourceName: "user"), for: UIControlState.selected)
        imageView.setImage(#imageLiteral(resourceName: "user"), for: UIControlState.normal)

        
    }
    
    
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }

    
    @IBAction func profileButtonClicked()
    {
        self.performSegue(withIdentifier: "profileSegue", sender: self)
        
        
        
    }
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    var imageView = UIButton()
    
    func setUpProfileButton()
    {
        //let imageView = UIImageView(image: #imageLiteral(resourceName: "user"))
        //imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //profileButton.width = 400
        //profileButton.siz
        //profileButton.height = 200
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        navigationBar.alpha = 0.5
        navigationBar.isTranslucent = true
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        imageView.addTarget(self, action: #selector(self.profileButtonClicked), for: .touchUpInside)
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            //print(delta/heightDifferenceBetweenStates)
            return delta / heightDifferenceBetweenStates
            
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale+coeff*0.15, y: scale+coeff*0.15)
            //fix this
            .translatedBy(x: xTranslation-coeff*2, y: yTranslation+coeff*3)
    }
    
    @objc func action()
    {
        timeCounter = timeCounter + 1
        if(timeCounter == 8)
        {
            scalingCarousel.scrollToItem(at: IndexPath.init(row: 3, section: 0), at: UICollectionViewScrollPosition(rawValue: 2), animated: true)
            //self.innerScrollView.backgroundColor = UIColor(red: 160/255, green: 196/255, blue: 1, alpha: 1)

        }
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
            let imageView = UIImageView(image: #imageLiteral(resourceName: "sampleCover"))
            imageView.frame = CGRect(x: 8, y: 0, width: scalingCell.mainView.frame.width-16, height: scalingCell.mainView.frame.height)
            scalingCell.mainView.backgroundColor = UIColor.clear
            scalingCell.mainView.addSubview(imageView)
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = true;
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //scalingCarousel.didScroll()
    }
}
extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        <#code#>
    }
 */
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
 */
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



