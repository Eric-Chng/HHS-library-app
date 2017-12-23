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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkoutButton: UIButton!
    static var ISBN:String = "";
    var rawDescription: String = "[loading description]";
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var reserveButtonImage: UIImageView!
    @IBOutlet weak var BookCoverImage: UIImageView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = "Papercraft"

        titleLabel?.sizeToFit()
        authorLabel?.text = "Mandy Cooper"
        descBox?.attributedText = NSAttributedString(string: "The next planet was inhabited by a tippler. This was a very short visit, but it plunged the little prince into deep dejection. The fourth planet belonged to a businessman. This man was so much occupied that he did not even raise his head at the little prince's arrival.  The next planet was inhabited by a tippler. This was a very short visit, but it plunged the little prince into deep dejection. The fourth planet belonged to a businessman. This man was so much occupied that he did not even raise his head at the little prince's arrival.",  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
        rawDescription = (descBox?.attributedText.string)!;
        
        formatDescription()
        
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        
        checkoutButton.layer.cornerRadius=15
        checkoutButton.layer.masksToBounds=true
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04896), MKCoordinateSpanMake(0.0004, 0.0004)), animated: true)
        
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
                let itemsDictionary = /*googleBooksJSON["items"] as? NSArray?*/ String(describing: googleBooksJSON)
                if itemsDictionary != "[\"totalItems\": 0, \"kind\": books#volumes]"
                {
                    JSONAsString = itemsDictionary/*String(describing: itemsDictionary!![0])*/
                //print(JSONAsString)
                print("End of JSON")
                

                
                
                //Parses out the title
                let rangeTotitle: Range<String.Index> = JSONAsString.range(of: " title = ")!
                let distanceTotitle = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeTotitle.lowerBound))
                let titleIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle+9)
                let titleAndOn = JSONAsString.substring(from: titleIndex)
                let rangeToSemiColon: Range<String.Index> = titleAndOn.range(of: ";")!
                let distanceToSemiColon = Int(titleAndOn.distance(from: titleAndOn.startIndex, to: rangeToSemiColon.lowerBound))
                let finalIndex = titleAndOn.index(titleAndOn.startIndex, offsetBy: distanceToSemiColon)
                var finalTitle = titleAndOn.substring(to: finalIndex)
                if finalTitle.range(of: "\"") != nil
                {
                    let firstQuoteIndex = finalTitle.index(finalTitle.startIndex, offsetBy: 1)
                    finalTitle = finalTitle.substring(from: firstQuoteIndex)
                    let lastQuoteIndex = finalTitle.index(finalTitle.endIndex, offsetBy: -1)
                    finalTitle = finalTitle.substring(to: lastQuoteIndex)
                }
                //print(finalTitle)
                
                //Parses out the author
                let rangeToAuthors: Range<String.Index> = JSONAsString.range(of: "authors = ")!
                let distanceToAuthors = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToAuthors.lowerBound))
                let authorsIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToAuthors+33)
                let authorsAndOn = JSONAsString.substring(from: authorsIndex)
                //print("oh boy" + authorsAndOn)
                let rangeToQuote: Range<String.Index> = authorsAndOn.range(of: "\"")!
                let distanceToQuote = Int(authorsAndOn.distance(from: authorsAndOn.startIndex, to: rangeToQuote.lowerBound))
                let quoteIndex = authorsAndOn.index(authorsAndOn.startIndex, offsetBy: distanceToQuote)
                let finalAuthor = authorsAndOn.substring(to: quoteIndex)
                //print("The Author is \"" + finalAuthor + "\"")
                
                //Parses out the description
                let rangeToDescription: Range<String.Index> = JSONAsString.range(of: "description = ")!
                let distanceToDescription = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToDescription.lowerBound))
                let descriptionIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToDescription+15)
                let descriptionAndOn = JSONAsString.substring(from: descriptionIndex)
                //print("Description is: " + descriptionAndOn)
                let rangeToDescriptionQuote: Range<String.Index> = descriptionAndOn.range(of: "\"")!
                let distanceToDescriptionQuote = Int(descriptionAndOn.distance(from: descriptionAndOn.startIndex, to: rangeToDescriptionQuote.lowerBound))
                let descriptionQuoteIndex = descriptionAndOn.index(descriptionAndOn.startIndex, offsetBy: distanceToDescriptionQuote)
                let finalDescription = descriptionAndOn.substring(to: descriptionQuoteIndex)
                //print("Description is: " + finalDescription)

                
                DispatchQueue.main.async(execute: {() -> Void in
                    //Sets Title Label To Correct Value
                    self.titleLabel?.text = finalTitle;
                    self.authorLabel?.text = finalAuthor;
                    self.descBox?.text = finalDescription;

                })
            }
            else
            {
                DispatchQueue.main.async(execute: {() -> Void in
                    //Sets Title Label To Correct Value
                    self.titleLabel?.text = BookDetailViewController.ISBN;
                    self.authorLabel?.text = "not found";
                    self.descBox?.text = "not found";
                    
                })
            }
                

                //let distanceToTitle = Int(distanceTotitle.distance(from: distanceTotitle.startIndex, to: rangeTotitle.lowerBound))
                
                
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let x:Int? = 2 else {
                    print("Could not get todo title from JSON")
                    return
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
       task.resume()
 
        
            if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + BookDetailViewController.ISBN + "-L.jpg") {
            //imageView.contentMode = .scaleAspectFit
                self.downloadCoverImage(url: url)
        }
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
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.BookCoverImage.image = UIImage(data: data)
            }
        }
    }
    
    static func updateISBN(newISBN: String)
    {
        print("update happened")
        BookDetailViewController.ISBN = newISBN;
    }
    
    
}

