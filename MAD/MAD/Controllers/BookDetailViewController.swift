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
//import Alamofire //error disappears at build time
//import ObjectMapper


class BookDetailViewController : UIViewController {
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    
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
    var timer: Timer = Timer.init()
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
    
    @IBAction func reserveButton(_ sender: Any) {
        print("touched")
        self.performSegue(withIdentifier: "reserveSegue", sender: self)
        
        
        
    }
    
    
    @objc func action()
    {
        
        if(selectedBook?.BookCoverImage != nil)
        {
            if(Double((selectedBook?.BookCoverImage.image?.size.height)!)>20.0 && selectedBook?.title != "")
            {
                self.BookCoverImage.image = selectedBook!.BookCoverImage.image
                self.titleLabel?.text = selectedBook!.title
                self.authorLabel?.text = selectedBook!.author
                self.descBox!.attributedText = NSAttributedString(string: selectedBook!.desc!,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
                //timer.invalidate()
                //timer = nil
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Book Info"
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
        
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        
        BookCoverImage.layer.cornerRadius=10
        BookCoverImage.layer.masksToBounds = true
        
        checkoutButton.layer.cornerRadius=15
        checkoutButton.layer.masksToBounds=true
        
        descriptionButton.layer.cornerRadius=15
    descriptionButton.layer.masksToBounds=true
        
        descriptionLabel.layer.cornerRadius=10
        descriptionLabel.layer.masksToBounds=true
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04896), MKCoordinateSpanMake(0.0004, 0.0004)), animated: true)
        
        if(self.selectedBook != nil)
        {
            //print("Book was passed")
            //print("Book info...")
            //selectedBook!.printInfo()
            //print(String(describing: selectedBook))
            self.descBox!.attributedText = NSAttributedString(string: selectedBook!.desc!,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
            self.titleLabel?.text = selectedBook!.title
            self.authorLabel?.text = selectedBook!.author
            print(String(describing: selectedBook?.BookCoverImage))
            //self.BookCoverImage = selectedBook!.BookCoverImage

            if(selectedBook?.BookCoverImage != nil)
            {
            self.BookCoverImage.image = selectedBook!.BookCoverImage.image
            }
            else{
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
                
            
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
                //print("Google Books JSON: " + String(describing: googleBooksJSON))
                
                
                
                
                
                
                //Converts JSON into a String
                
                var JSONAsString = "describing =                       \"could not be found\" authors = \"not found\" title = not found"
                let itemsDictionary =  String(describing: googleBooksJSON)
                if itemsDictionary != "[\"totalItems\": 0, \"kind\": books#volumes]"
                {
                    JSONAsString = itemsDictionary/*String(describing: itemsDictionary!![0])*/
                //print(JSONAsString)
                //print("End of JSON")
                

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
                //print(finalTitle)
                    var finalAuthor = "Not available"
                //Parses out the author
                if let rangeToAuthors: Range<String.Index> = JSONAsString.range(of: "authors = ")
                {
                let distanceToAuthors = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToAuthors.lowerBound))
                let authorsIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToAuthors+33)
                let authorsAndOn = JSONAsString.substring(from: authorsIndex)
                //print("oh boy" + authorsAndOn)
                let rangeToQuote: Range<String.Index> = authorsAndOn.range(of: "\"")!
                let distanceToQuote = Int(authorsAndOn.distance(from: authorsAndOn.startIndex, to: rangeToQuote.lowerBound))
                let quoteIndex = authorsAndOn.index(authorsAndOn.startIndex, offsetBy: distanceToQuote)
                finalAuthor = authorsAndOn.substring(to: quoteIndex)
                //print("The Author is \"" + finalAuthor + "\"")
                    }
                    var finalDescription = "Not available";
                    
                    
                    
                //Parses out the description
                if let rangeToDescription: Range<String.Index> = JSONAsString.range(of: "description = ")
                {
                let distanceToDescription = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToDescription.lowerBound))
                let descriptionIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToDescription+15)
                let descriptionAndOn = JSONAsString.substring(from: descriptionIndex)
                //print("Description is: " + descriptionAndOn)
                    let rangeToDescriptionQuote: Range<String.Index> = descriptionAndOn.range(of: ";")!
                let distanceToDescriptionQuote = Int(descriptionAndOn.distance(from: descriptionAndOn.startIndex, to: rangeToDescriptionQuote.lowerBound))-1
                let descriptionQuoteIndex = descriptionAndOn.index(descriptionAndOn.startIndex, offsetBy: distanceToDescriptionQuote)
                    finalDescription = descriptionAndOn.substring(to: descriptionQuoteIndex)
                //print("Description is: " + finalDescription)
                    finalDescription = finalDescription.replacingOccurrences(of: "\\U2019", with: "\'")
                    var ignored:String = "";
                    while let rangeToBackslash: Range<String.Index> = finalDescription.range(of: "\\")
                    {
                        var isQuote:Bool = false;
                    let distanceToBackslash = Int(finalDescription.distance(from: finalDescription.startIndex, to: rangeToBackslash.lowerBound))
                    let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash)
                        //print("finalDesc1: " + finalDescription)
                    var finalDescription2: String = finalDescription.substring(from: backslashIndex)
                    
                     
                    //print("finalDesc: " + finalDescription2)
                    //finalDescription2 = "0301";
                   let temp1 = finalDescription.substring(to: backslashIndex)
                        //print("Test: " + finalDescription2.substring(to: finalDescription2.index(finalDescription2.startIndex, offsetBy: 2)))
                        if(finalDescription2.substring(to: finalDescription2.index(finalDescription2.startIndex, offsetBy: 2))=="\\\"")
                        {
                            //print("found to be a quote")
                            let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash+1)
                            isQuote = true;
                            finalDescription = finalDescription.substring(from: backslashIndex)
                            ignored = ignored + temp1;
                        }
                    
                        if(isQuote == false)
                        {
                            //print("final" + temp1)
                            //print("made it to indexing")
                    let backslashIndex2 = finalDescription2.index(finalDescription2.startIndex, offsetBy: 6)
                            //print("made it past indexing")
                    let temp2 = finalDescription2.substring(from: backslashIndex2)
                            //print("made it past substringing")
                    finalDescription = temp1 + temp2
                            //print("got finalDescription: " + finalDescription)
                        }
                    }
                    finalDescription = ignored + finalDescription;
                    //self.performSegue(withIdentifier: "reserveSegue", sender: self)

                    //print(finalDescription)
                    //print(rangeToBackslash2)
                    }
                    //print(code)
                    //var y:Character = Character(code)
                    
                  
                    //❄️
                    //UTF8Decoder.decode(test)
                    
                    
                    //var code:String = "Pok\u{00E9}mon"
                    //print("Code: " + String(y))
                    
                
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
        print("Download Started")
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
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
                print("Download Finished")
                DispatchQueue.main.async() {
                    let temp: UIImage? = UIImage(data: data)
                    if(temp != nil && Double((temp?.size.height)!)>20.0)
                    {
                        print("Doing it")
                        self.BookCoverImage.image = temp
                        self.foundGoogleImage = true
                    }
                    else
                    {
                        print("Image not found 2")
                        //self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                    }
                    print(String(describing: temp?.size.height))
                    
                }
            }
        }
    }
    }
    
    func googleBooksImageURL(newURL: String)
    {
        self.imageURL = newURL
    }
    
    static func updateISBN(newISBN: String)
    {
        print("update happened")
        BookDetailViewController.ISBN = newISBN;
    }
    
    
}

