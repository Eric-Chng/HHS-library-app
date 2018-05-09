
//
//  CodeViewController.swift
//  ScalingCarousel
//
//  Created by Pete Smith on 29/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ScalingCarousel
import Koloda
import MapKit
import Popover

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
    
    var kolodaView: KolodaView!
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
        
        //addCarousel()
        addKoloda()
        self.hoursButton.layer.cornerRadius = 4
        self.hoursButton.layer.masksToBounds = true
        mapView.delegate = self
        self.tabBarController?.tabBar.isHidden = false
        hoursView.layer.cornerRadius = 25
        hoursView.layer.masksToBounds = true
        self.mapView.mapType = MKMapType.satellite;
        //kolodaView.dataSource = self
        //kolodaView.delegate = self
        
            navigationController?.navigationBar.prefersLargeTitles = true
        tomorrowLabel.alpha = 0;
        scrollView.delegate = self
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        //mapView.setRegion(MKCoordinateRegion(), animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeViewController.action), userInfo: nil,  repeats: true)
        
        
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04898), MKCoordinateSpanMake(0.01, 0.01)), animated: true)
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

    private func addKoloda() {
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        kolodaView = KolodaView(frame: frame)
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.translatesAutoresizingMaskIntoConstraints = false
        //scalingCarousel.backgroundColor = .white
        //scalingCarousel.register(CodeCell.self, forCellWithReuseIdentifier: "cell")
        
        innerScrollView.addSubview(kolodaView)
        //kolodaView.center = innerScrollView.convert(innerScrollView.center, from:innerScrollView.superview)

        // Constraints
        kolodaView.widthAnchor.constraint(equalTo: innerScrollView.widthAnchor, multiplier: 0.45).isActive = true
        //kolodaView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor)
        kolodaView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        kolodaView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor, constant: 0.5).isActive = true
        kolodaView.topAnchor.constraint(equalTo: innerScrollView.topAnchor, constant: 10).isActive = true
        self.waitForDownload()
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
        /*
        if(timeCounter == 8)
        {
            scalingCarousel.scrollToItem(at: IndexPath.init(row: 3, section: 0), at: UICollectionViewScrollPosition(rawValue: 2), animated: true)
            //self.innerScrollView.backgroundColor = UIColor(red: 160/255, green: 196/255, blue: 1, alpha: 1)

        }
 */
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
    @IBAction func hoursInfoButtonPressed(_ sender: Any)
    {
        if let url = URL(string: "https://www.hhs.fuhsd.org/library") {
            UIApplication.shared.open(url, options: [:])
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func rightSwipePressed(_ sender: Any)
    {
        self.kolodaView.swipe(SwipeResultDirection.right)
    }
    
    @IBAction func leftSwipePressed(_ sender: Any)
    {
        self.kolodaView.swipe(SwipeResultDirection.left)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookToPass = self.recommendationBookArr[bookSwipedID]
        if let destinationViewController = segue.destination as? BookDetailViewController {
            destinationViewController.selectedBook = bookToPass
        }
    }
    
    var bookSwipedID: Int = 0
    
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
    var coverTimer: Timer = Timer()
    let images = [#imageLiteral(resourceName: "sampleCover2"), #imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2"),#imageLiteral(resourceName: "sampleCover2")]
    
    var recommendationBookArr = [BookModel(ISBN: "9780684833392"), BookModel(ISBN: "9780804139021"), BookModel(ISBN: "9781400095957"), BookModel(ISBN: "9780393061703"), BookModel(ISBN: "9780679732761"), BookModel(ISBN: "9781451673265"), BookModel(ISBN: "9781848664173"), BookModel(ISBN: "9781101981085"), BookModel(ISBN: "9781786072108"), BookModel(ISBN: "9780993790904"), BookModel(ISBN: "9780141182773"), BookModel(ISBN: "9780810891951"), BookModel(ISBN:"9781594480003"), BookModel(ISBN:"9781555975098")]
    var cardsToCheck: [Int] = [0, 1, 2, 3, 4, 5, 6]
    var numCards: Int = 0
    var counter: Int = 0

    @IBOutlet weak var tomorrowLabel: UILabel!
    
}

extension HomeViewController: KolodaViewDataSource {
    
    
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return recommendationBookArr.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed.moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let image: UIImage? = recommendationBookArr[index].getImage()
        if(image?.isEqual(#imageLiteral(resourceName: "loadingImage")))!
        {
            return UIImageView(image: UIImage())
            //sleep(1)
            /*
            cardsToCheck.append(index)
            print("waiting")
            if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + recommendationBookArr[index].ISBN! + "-L.jpg")
            {
                print("testPoint3")

                //return UIImageView(image: self.downloadCoverImage(url: url))
            }
 */
        }
       // print("testPoint4")

        return UIImageView(image: recommendationBookArr[index].BookCoverImage.image)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL) -> UIImage {
        var returnedImage: UIImage = #imageLiteral(resourceName: "loadingImage")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    returnedImage = temp!
                    print("testPoint1")
                }
                
                
            }
        }
        print("testPoint2")
        return returnedImage
        
    }
    
    func waitForDownload()
    {
        coverTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeViewController.downloadCheck), userInfo: nil,  repeats: true)

    }
    
    @objc func downloadCheck()
    {
        //print("download check")
        if(counter<6)
        {
            let image = recommendationBookArr[counter].getImage()
            if(image.isEqual(#imageLiteral(resourceName: "loadingImage")))
            {
                
            }
            else
            {
                print("found:")
                print(counter)
                //cardsToCheck.remove(at: counter)
                let temp = counter + 1
                counter = temp
                //kolodaView.insertCardAtIndexRange(CountableRange(counter...counter))
                numCards = numCards + 1
            }
        }
        if(counter == 6)
        {
            print("All downloaded")
            self.kolodaView.reloadData()
            coverTimer.invalidate()
        }
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        //return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
        return OverlayView()
    }
}

extension HomeViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
        UIView.animate(withDuration: 1, animations: {self.tomorrowLabel.alpha = 1;})
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        let bookTitleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: 140, height: 22))
        bookTitleLabel.text = self.recommendationBookArr[index].title
        bookTitleLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
        bookTitleLabel.textAlignment = NSTextAlignment.center
        aView.addSubview(bookTitleLabel)
        let authorTitleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 29, width: 140, height: 18))
        authorTitleLabel.text = self.recommendationBookArr[index].author
        authorTitleLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 12)
        authorTitleLabel.textColor = UIColor.darkGray
        authorTitleLabel.textAlignment = NSTextAlignment.center
        aView.addSubview(authorTitleLabel)
        let options = [
            .type(.down),
            .cornerRadius(8),
            .animationIn(0.2),
            .animationOut(0.1),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.05)),
            .arrowSize(CGSize(width: 16.0, height: 10.0))
            //.border
            ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView: self.kolodaView)

    
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if(direction == SwipeResultDirection.right)
        {
            self.bookSwipedID = index
            self.performSegue(withIdentifier: "rightSwipeSegue", sender: self)
            //print(self.recommendationBookArr[index].title)
        }
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



