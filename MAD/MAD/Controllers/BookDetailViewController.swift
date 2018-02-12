//
//  BookDetailViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/30/17.
//  Copyright © 2017 Eric C. All rights reserved.
//http://covers.openlibrary.org/b/isbn/9780385533225-L.jpg

import Foundation
import UIKit
import MapKit
import Lottie
//import Alamofire //error disappears at build time
//import ObjectMapper


class BookDetailViewController : UIViewController, DownloadProtocol {
    
    
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var descBox: UITextView!
    var imageURL: String = ""
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkoutButton: UIButton!
    var foundGoogleImage: Bool = false;
    static var ISBN:String = "";
    var rawDescription: String = "[loading description]";
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var reserveButtonImage: UIImageView!
    @IBOutlet weak var BookCoverImage: UIImageView!
        @IBOutlet weak var genreImage: UIImageView! = UIImageView(image: #imageLiteral(resourceName: "drama"))
    @IBOutlet weak var statusImage: UIImageView! = UIImageView(image: #imageLiteral(resourceName: "greencheck.png"))
    @IBOutlet weak var descriptionLabel: UILabel!
    var userInteractionCommitted: Bool = false
    var timer: Timer = Timer.init()
    var loadTimer: Timer? = Timer.init()
    var fromScanner: Bool = false
    var smallCoverImageCounter: Int = 0;
    var loadedRating: Bool = false
    @IBAction func DoneButton(_ sender: Any) {
       // _ = popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func expandDescription(_ sender: Any) {
        print("Uptime: " + String(Int(ProcessInfo.processInfo.systemUptime)))
        //descBox?.attributedText = NSAttributedString(string: rawDescription,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
        //descBox.sizeToFit();
    }
    
    var selectedBook : BookModel?
    
    var fromSB: segues?
    
    enum segues {
        case fromMyBooksViewController
        case fromDiscoverViewController
        case fromCheckoutViewController
    }
    
    @IBAction func reserveButton(_ sender: Any) {
        if(self.checkoutButton.currentTitle! == "Hold")
        {
        self.performSegue(withIdentifier: "reserveSegue", sender: self)
        }
    }
    
    func itemsDownloaded(items: NSArray, from: String) {
        
        var counter: Int = 0
        for x in items
        {
            print(x)
            counter = counter + 1
        }
        if(items.count > 0)
        {
            self.checkoutButton.setTitle("Hold", for: UIControlState.normal)
            
        }
        else
        {
            self.checkoutButton.setTitle("Unavailable", for: UIControlState.normal)
            UIView.animate(withDuration: 1.0) {
                self.checkoutButton.alpha = 0.8
                self.checkoutButton.backgroundColor = UIColor.lightGray
            }
        }
        
        
    }
    
    @objc func load()
    {
        if(selectedBook!.title != "")
        {
        self.descBox!.attributedText = NSAttributedString(string: selectedBook!.desc!,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
            var heightConstant = CGFloat(160)
            if(self.descBox.contentSize.height<160)
            {
                
                heightConstant = self.descBox.contentSize.height
                

            }
            else
            {
                heightConstant = 160
            }
            let heightConstraint = NSLayoutConstraint(item: self.descBox, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: heightConstant)
            if(self.descBox.contentSize.height != 36)
            {
            self.descBox.addConstraints([heightConstraint])
            }
        self.titleLabel?.text = selectedBook!.title
        self.authorLabel?.text = selectedBook!.author
            
            if(loadedRating == false)
            {
                
                var counter: Int = 0
                let x = ratingView.frame

                let ratingAsInt = Int(selectedBook!.rating) + 1
                self.ratingLabel.text = String(describing: (selectedBook?.rating)!) + " out of 5 stars"
                if((selectedBook?.rating)! < 0)
                {
                    self.ratingLabel.text = "No ratings found"

                }
                for view in self.ratingView.subviews {
                    view.removeFromSuperview()
                }
  
                while(counter<ratingAsInt)
                {
                    loadedRating = true

                    counter = counter + 1;
                    let frame = CGRect(x: -x.width/2.7+(x.width/4)*CGFloat(counter), y: 0, width: x.width/2, height: x.height*1.4)
                    let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
                    animationView.contentMode = .scaleToFill
                    animationView.frame = frame
                    //animationView.backgroundColor = UIColor.white

                    ratingView.addSubview(animationView)
                    //animationView.loopAnimation = true
                    //animationView.play(fromProgress: 0, toProgress: 5.0, withCompletion: nil)
                    animationView.play()
                }
                
                counter = 0
                
                while(counter<5)
                {
                    counter = counter + 1;
                    //let frame = CGRect(x: -x.width/2.7+(x.width/4)*CGFloat(counter), y: 0, width: x.width/2, height: x.height*1.4)
                    //let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
                    let frame = CGRect(x: x.width/4*CGFloat(counter)-x.width/5, y: x.height/2.3, width: x.width/6, height: x.height/2)
                    
                    //animationView.contentMode = .scaleToFill
                    let emptyStarView = UIImageView(image: #imageLiteral(resourceName: "emptyStar"))
                    emptyStarView.contentMode = .scaleToFill
                    emptyStarView.frame = frame
                    //animationView.frame = frame
                    if(counter>ratingAsInt)
                    {
                    ratingView.addSubview(emptyStarView)
                    }
                    //animationView.loopAnimation = true
                    //animationView.play(fromProgress: 0, toProgress: 5.0, withCompletion: nil)
                    //animationView.play()
                }
                
            }
        }
        if(selectedBook!.BookCoverImage != nil)
        {
            self.BookCoverImage.image = selectedBook!.BookCoverImage.image
            if self.navigationItem.titleView is UIImageView {
                (self.navigationItem.titleView as! UIImageView).image = self.BookCoverImage.image
                self.navigationItem.titleView?.alpha = 0.05
                
                if(self.titleLabel  != nil && self.titleLabel?.text != nil && self.titleLabel?.text != "Loading" && self.BookCoverImage != nil && self.BookCoverImage.image?.isEqual(#imageLiteral(resourceName: "loadingImage")) == false)
                {
                    if(selectedBook!.rating > -0.1)
                    {
                self.loadTimer?.invalidate()
                        self.checkAvailability()
                    }
                    else
                    {
                        self.loadTimer?.invalidate()
                        self.checkAvailability()

                    }
                    
                }
                else
                {
                }
                
            }
        }
    }
    
    func checkAvailability()
    {
        let idSearch = IdSearchBook()
        idSearch.delegate = self
        idSearch.downloadItems(inputID: (self.selectedBook?.ISBN)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is HoldViewController {
            (segue.destination as! HoldViewController).setBookModel(model: self.selectedBook!)
            //destinationViewController.selectedBook = bookToPass
        }
        
        
    //_ = popViewController(animated: true)
        //self.navigationController?.popViewController(animated: true)
    
    }
    
    
    @objc func action()
    {

        
       
        
        
        if(scrollView.contentOffset.y > 100 && (self.navigationItem.titleView?.alpha)! == CGFloat(0.0) && smallCoverImageCounter == 0)
        {
            self.smallCoverImageCounter = 10
            self.userInteractionCommitted = true
        }
        else if(scrollView.contentOffset.y < 100)
        {
            self.smallCoverImageCounter = 0
            self.navigationItem.titleView?.alpha = 0.05

        }
       
        if(self.smallCoverImageCounter>0)
        {
            smallCoverImageCounter = smallCoverImageCounter - 1
            if(self.userInteractionCommitted)
            {
            self.navigationItem.titleView?.alpha = CGFloat(1-CGFloat(smallCoverImageCounter)/20)
            }
        }
        else if(scrollView.contentOffset.y < 100)
        {
            
            var tempAlpha = (self.navigationItem.titleView?.alpha)! - 0.4
            if(tempAlpha<0)
            {
                tempAlpha = 0
            }
            self.navigationItem.titleView?.alpha = tempAlpha
            
        }
        
        if(self.userInteractionCommitted == false)
        {
            let temp = UIView.init()
            temp.frame = CGRect(x: 0, y: 0, width: 500, height: 100)
            temp.backgroundColor = UIColor.white
            self.navigationItem.titleView?.addSubview(temp)
            
            self.smallCoverImageCounter = 0
            self.navigationItem.titleView?.alpha = 0
            
        }
        else
        {
            for subview in (self.navigationItem.titleView?.subviews)!
            {
                subview.removeFromSuperview()
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkoutButton.setTitle("Checking Availability...", for: UIControlState.normal)

        self.navigationController?.navigationBar.isTranslucent = false
        //self.checkoutButton.image
        //self.checkoutButton.backgroundImage(for: <#T##UIControlState#>)
        self.checkoutButton.layer.cornerRadius = 10
        self.checkoutButton.titleLabel?.text = "Hold"
        self.checkoutButton.imageView?.layer.masksToBounds = true
        
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        //self.navigationController
        UIApplication.shared.statusBarStyle = .lightContent

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = ""
        
        titleLabel?.text = "Loading..."
        BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
        checkoutButton.imageView?.image = #imageLiteral(resourceName: "reserveicon7.png")
        //genreImage.image = #imageLiteral(resourceName: "drama")
        //statusImage.image = #imageLiteral(resourceName: "greencheck.png")
        
        titleLabel?.sizeToFit()
        authorLabel?.text = "Loading..."
        descBox?.attributedText = NSAttributedString(string: "Loading from database for ISBN-13 Value: " + BookDetailViewController.ISBN + "...",  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
        rawDescription = (descBox?.attributedText.string)!;
        
        formatDescription()
        
        
        let x = ratingView.frame
        
        let overlay = LibraryOverlay()
        self.mapView.add(overlay)
        self.mapView.delegate = self 
        
        var counter: Int = 0
        
        while(counter<5)
        {
            counter = counter + 1;
            //let frame = CGRect(x: -x.width/2.7+(x.width/4)*CGFloat(counter), y: 0, width: x.width/2, height: x.height*1.4)
            //let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            let frame = CGRect(x: x.width/4*CGFloat(counter)-x.width/5, y: x.height/2.3, width: x.width/6, height: x.height/2)

            //animationView.contentMode = .scaleToFill
            let emptyStarView = UIImageView(image: #imageLiteral(resourceName: "emptyStar"))
            emptyStarView.contentMode = .scaleToFill
            emptyStarView.frame = frame
            //animationView.frame = frame
            
            ratingView.addSubview(emptyStarView)
            //animationView.loopAnimation = true
            //animationView.play(fromProgress: 0, toProgress: 5.0, withCompletion: nil)
            //animationView.play()
        }
        
        
        
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        
        BookCoverImage.layer.cornerRadius=10
        BookCoverImage.layer.masksToBounds = true
        
        //checkoutButton.layer.cornerRadius=15
        checkoutButton.layer.masksToBounds=true
        
        
        
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04896), MKCoordinateSpanMake(0.0006, 0.0006)), animated: true)
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector:
            #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        if(self.selectedBook != nil)
        {
            if(fromScanner == false)
            {
            self.descBox!.attributedText = NSAttributedString(string: selectedBook!.desc!,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
                //self.descBox!.sizeToFit()
                var heightConstant = CGFloat(160)
                if(self.descBox.contentSize.height<160)
                {
                    heightConstant = self.descBox.contentSize.height
                }
                else
                {
                    heightConstant = 160
                }
                let heightConstraint = NSLayoutConstraint(item: self.descBox, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: heightConstant)
                self.descBox.addConstraints([heightConstraint])
            
                self.checkAvailability()
                
            self.titleLabel?.text = selectedBook!.title
            self.authorLabel?.text = selectedBook!.author
                
                var counter: Int = 0
                let x = ratingView.frame
                
                let ratingAsInt = Int(selectedBook!.rating) + 1
                self.ratingLabel.text = String(describing: (selectedBook?.rating)!) + " out of 5 stars"
                if((selectedBook?.rating)! < 0)
                {
                    self.ratingLabel.text = "No ratings found"
                    
                }
                for view in self.ratingView.subviews {
                    view.removeFromSuperview()
                }
                
                while(counter<ratingAsInt)
                {
                    loadedRating = true
                    
                    counter = counter + 1;
                    let frame = CGRect(x: -x.width/2.7+(x.width/4)*CGFloat(counter), y: 0, width: x.width/2, height: x.height*1.4)
                    let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
                    animationView.contentMode = .scaleToFill
                    animationView.frame = frame
                    //animationView.backgroundColor = UIColor.white
                    
                    ratingView.addSubview(animationView)
                    //animationView.loopAnimation = true
                    //animationView.play(fromProgress: 0, toProgress: 5.0, withCompletion: nil)
                    animationView.play()
                }
                
                counter = 0
                
                while(counter<5)
                {
                    counter = counter + 1;
                    //let frame = CGRect(x: -x.width/2.7+(x.width/4)*CGFloat(counter), y: 0, width: x.width/2, height: x.height*1.4)
                    //let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
                    let frame = CGRect(x: x.width/4*CGFloat(counter)-x.width/5, y: x.height/2.3, width: x.width/6, height: x.height/2)
                    
                    //animationView.contentMode = .scaleToFill
                    let emptyStarView = UIImageView(image: #imageLiteral(resourceName: "emptyStar"))
                    emptyStarView.contentMode = .scaleToFill
                    emptyStarView.frame = frame
                    //animationView.frame = frame
                    if(counter>ratingAsInt)
                    {
                        ratingView.addSubview(emptyStarView)
                    }
                    //animationView.loopAnimation = true
                    //animationView.play(fromProgress: 0, toProgress: 5.0, withCompletion: nil)
                    //animationView.play()
                }
            }
            else
            {
                self.descBox!.attributedText = NSAttributedString(string: "Loading",  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
                self.titleLabel?.text = "Loading"
                self.authorLabel?.text = "Loading"
            }


            if(selectedBook?.BookCoverImage != nil)
            {
            self.BookCoverImage.image = selectedBook!.BookCoverImage.image
                let tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 38))
                tempImageView.image = selectedBook!.BookCoverImage.image
                self.navigationItem.titleView = tempImageView
                self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 10, height: 38)
                self.navigationItem.titleView?.alpha = 0.0

                //self.navigationItem.titleView.image
                //let tempFrame = self.navigationItem.titleView?.frame
                //    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))

                //self.navigationItem.titleView?.frame = CGRect(x: (tempFrame?.minX)!, y: (tempFrame?.minY)!, width: 10, height: (tempFrame?.height)!)
                self.navigationItem.titleView?.contentMode = .scaleToFill
                let widthConstraint = NSLayoutConstraint(item: self.navigationItem.titleView as Any, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
                let heightConstraint = NSLayoutConstraint(item: self.navigationItem.titleView as Any, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35)

                self.navigationItem.titleView?.addConstraints([widthConstraint, heightConstraint])
                self.navigationItem.titleView?.layer.cornerRadius = 2
                self.navigationItem.titleView?.layer.masksToBounds = true

                
                
            }
            else
            {
                self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                let tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 38))
                tempImageView.image = self.BookCoverImage.image
                self.navigationItem.titleView = tempImageView
                self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 10, height: 38)
                self.navigationItem.titleView?.alpha = 0.0
                
                //self.navigationItem.titleView.image
                //let tempFrame = self.navigationItem.titleView?.frame
                //    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
                
                //self.navigationItem.titleView?.frame = CGRect(x: (tempFrame?.minX)!, y: (tempFrame?.minY)!, width: 10, height: (tempFrame?.height)!)
                self.navigationItem.titleView?.contentMode = .scaleToFill
                let widthConstraint = NSLayoutConstraint(item: self.navigationItem.titleView as Any, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
                let heightConstraint = NSLayoutConstraint(item: self.navigationItem.titleView as Any, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35)
                
                self.navigationItem.titleView?.addConstraints([widthConstraint, heightConstraint])
                self.navigationItem.titleView?.layer.cornerRadius = 2
                self.navigationItem.titleView?.layer.masksToBounds = true
                if(fromScanner)
                {
                loadTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector:
                    #selector(SearchTableViewController.load), userInfo: nil,  repeats: true)
                    RunLoop.main.add(loadTimer!, forMode: RunLoopMode.commonModes)
                
                }
                
                
            }
            
            
        }
        else
        {
        
        
        let todoEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=isbn+" + BookDetailViewController.ISBN
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
       
        
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling with Google Books GET call with ISBN: " + BookDetailViewController.ISBN)
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let googleBooksJSON = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    as? [String: Any]
                    else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                
                
                
                
                
                //Converts JSON into a String
                
                var JSONAsString = "describing =                       \"could not be found\" authors = \"not found\" title = not found"
                let itemsDictionary =  String(describing: googleBooksJSON)
                
                //object.method(arg, arg1, arg2)
                if itemsDictionary != "[\"totalItems\": 0, \"kind\": books#volumes]"
                {
                    JSONAsString = itemsDictionary/*String(describing: itemsDictionary!![0])*/
                

                    var finalTitle = "Not found: " + BookDetailViewController.ISBN
                //Parses out the title
                if let rangeTotitle: Range<String.Index> = JSONAsString.range(of: " title = ")
                {
                let distanceTotitle = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeTotitle.lowerBound))
                let titleIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle+9)
                let titleAndOn = JSONAsString.substring(from: titleIndex)
                let rangeToSemiColon: Range<String.Index> = titleAndOn.range(of: ";")!
                let distanceToSemiColon = Int(titleAndOn.distance(from: titleAndOn.startIndex, to: rangeToSemiColon.lowerBound))
                let finalIndex = titleAndOn.index(titleAndOn.startIndex, offsetBy: distanceToSemiColon)
                finalTitle = titleAndOn.substring(to: finalIndex)
                if finalTitle.range(of: "\"") != nil
                {
                    let firstQuoteIndex = finalTitle.index(finalTitle.startIndex, offsetBy: 1)
                    finalTitle = finalTitle.substring(from: firstQuoteIndex)
                    let lastQuoteIndex = finalTitle.index(finalTitle.endIndex, offsetBy: -1)
                    finalTitle = finalTitle.substring(to: lastQuoteIndex)
                }
                    }
                    var finalAuthor = "Not available"
                //Parses out the author
                if let rangeToAuthors: Range<String.Index> = JSONAsString.range(of: "authors = ")
                {
                let distanceToAuthors = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToAuthors.lowerBound))
                let authorsIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToAuthors+33)
                let authorsAndOn = JSONAsString.substring(from: authorsIndex)
                let rangeToQuote: Range<String.Index> = authorsAndOn.range(of: "\"")!
                let distanceToQuote = Int(authorsAndOn.distance(from: authorsAndOn.startIndex, to: rangeToQuote.lowerBound))
                let quoteIndex = authorsAndOn.index(authorsAndOn.startIndex, offsetBy: distanceToQuote)
                finalAuthor = authorsAndOn.substring(to: quoteIndex)
                    }
                    var finalDescription = "Not available";
                    
                    
                    
                //Parses out the description
                if let rangeToDescription: Range<String.Index> = JSONAsString.range(of: "description = ")
                {
                let distanceToDescription = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToDescription.lowerBound))
                let descriptionIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToDescription+15)
                let descriptionAndOn = JSONAsString.substring(from: descriptionIndex)
                    let rangeToDescriptionQuote: Range<String.Index> = descriptionAndOn.range(of: ";")!
                let distanceToDescriptionQuote = Int(descriptionAndOn.distance(from: descriptionAndOn.startIndex, to: rangeToDescriptionQuote.lowerBound))-1
                let descriptionQuoteIndex = descriptionAndOn.index(descriptionAndOn.startIndex, offsetBy: distanceToDescriptionQuote)
                    finalDescription = descriptionAndOn.substring(to: descriptionQuoteIndex)
                    finalDescription = finalDescription.replacingOccurrences(of: "\\U2019", with: "\'")
                    var ignored:String = "";
                    while let rangeToBackslash: Range<String.Index> = finalDescription.range(of: "\\")
                    {
                        var isQuote:Bool = false;
                    let distanceToBackslash = Int(finalDescription.distance(from: finalDescription.startIndex, to: rangeToBackslash.lowerBound))
                    let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash)
                    var finalDescription2: String = finalDescription.substring(from: backslashIndex)
                    
                     
                   let temp1 = finalDescription.substring(to: backslashIndex)
                        if(finalDescription2.substring(to: finalDescription2.index(finalDescription2.startIndex, offsetBy: 2))=="\\\"")
                        {
                            let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash+1)
                            isQuote = true;
                            finalDescription = finalDescription.substring(from: backslashIndex)
                            ignored = ignored + temp1;
                        }
                    
                        if(isQuote == false)
                        {
                    let backslashIndex2 = finalDescription2.index(finalDescription2.startIndex, offsetBy: 6)
                    let temp2 = finalDescription2.substring(from: backslashIndex2)
                    finalDescription = temp1 + temp2
                        }
                    }
                    finalDescription = ignored + finalDescription;
                    //self.performSegue(withIdentifier: "reserveSegue", sender: self)


                    }
                    //var y:Character = Character(code)
                    
                  
                    //❄️
                    //UTF8Decoder.decode(test)
                    
                    
                    //var code:String = "Pok\u{00E9}mon"
                    
                
                DispatchQueue.main.async(execute: {() -> Void in
                    //Sets Title Label To Correct Value
                    self.titleLabel?.text = finalTitle;
                    self.authorLabel?.text = finalAuthor;
                    self.descBox?.text = finalDescription;
                    
                    //self.formatJSONDescription()

                    


                })
            }
            else
            {
                DispatchQueue.main.async(execute: {() -> Void in
                    //Sets Title Label To Correct Value
                    self.titleLabel?.text = BookDetailViewController.ISBN;
                    self.authorLabel?.text = "not found";
                    self.descBox?.text = "not found";
                    self.descBox.sizeToFit()

                    
                })
            }

                //let distanceToTitle = Int(distanceTotitle.distance(from: distanceTotitle.startIndex, to: rangeTotitle.lowerBound))
                
                
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
       task.resume()
    }
 
        
            //if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + BookDetailViewController.ISBN + "-L.jpg") {
            //imageView.contentMode = .scaleAspectFit
                //self.downloadCoverImage(url: url)
        //}
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func formatDescription()
    {
        var addDots:Bool = false;

        while/* (descBox?.contentSize.height)!>CGFloat(180)*/ descBox!.attributedText.length>356 {
            addDots = true;
            
            let subRange = NSMakeRange(0,(descBox?.attributedText.length)!-5)
            descBox?.attributedText = descBox?.attributedText.attributedSubstring(from: subRange)
        }
        if(addDots)
        {
            let stringVersion = descBox?.attributedText.string
            let stringIndex = descBox?.attributedText.string.range(of: " ", options: .backwards)?.lowerBound
            
            let finalString = stringVersion?.substring(to: stringIndex!);
            descBox?.attributedText=NSAttributedString(string: finalString!+"... (more)",attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ]);
        }
        descBox.sizeToFit();
    }
    
    func formatJSONDescription()
    {
        
        var addDots:Bool = false;
        /*DispatchQueue.main.async(execute: {() -> Void in

            while (self.descBox?.contentSize.height)!>CGFloat(170)
            /*self.descBox!.attributedText.length>365 */{

            addDots = true;
            
                    let subRange = NSMakeRange(0,(self.descBox?.attributedText.length)!-5)
                    self.descBox?.attributedText = self.descBox?.attributedText.attributedSubstring(from: subRange)
                }
                
        })*/
        //{//
            DispatchQueue.main.async(execute: {() -> Void in

                let stringVersion = self.descBox?.attributedText.string
                let stringIndex = self.descBox?.attributedText.string.range(of: " ", options: .backwards)?.lowerBound
            //let finalString = stringVersion?.substring(to: stringIndex!); <- readd if removing scrolling description
                let finalString = stringVersion; self.descBox?.attributedText=NSAttributedString(string: finalString!+"\n(tap for more details)",attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ]);
            })
        //}//
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL) {
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                self.BookCoverImage.image = temp
                    found = true;
                }
                else
                {
                    if(self.foundGoogleImage == false)
                    {
                    print("Image not found")
                    self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                    }
                }
                print(String(describing: temp?.size.height))
                
            }
        }
        if(found == false)
        {
        if let googleURL = URL(string: self.imageURL) {
            print("Using GBooks Image")
            self.getDataFromUrl(url: googleURL) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                DispatchQueue.main.async() {
                    let temp: UIImage? = UIImage(data: data)
                    if(temp != nil && Double((temp?.size.height)!)>20.0)
                    {
                        self.BookCoverImage.image = temp
                        self.foundGoogleImage = true
                    }
                    else
                    {
                        //self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                    }
                    print(String(describing: temp?.size.height))
                    
                }
            }
        }
    }
    }
    
    @IBAction func unwindToDetail(segue:UIStoryboardSegue) {
        
    }

    
    func googleBooksImageURL(newURL: String)
    {
        self.imageURL = newURL
    }
    
    static func updateISBN(newISBN: String)
    {
        BookDetailViewController.ISBN = newISBN;
    }
    
    
}

extension BookDetailViewController: MKMapViewDelegate
{
    
    
    
    
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

