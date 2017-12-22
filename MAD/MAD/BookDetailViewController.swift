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
        
        let todoEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + BookDetailViewController.ISBN
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
                
                
                
                //subtitleAndOn now finds beginning of title, some titles do not have quotation marks
                let itemsDictionary = googleBooksJSON["items"] as? NSArray?
                let JSONAsString = String(describing: itemsDictionary!![0])
                let rangeToSubtitle: Range<String.Index> = JSONAsString.range(of: " title")!
                
                let distanceToSubtitle = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToSubtitle.lowerBound))
               
                let subtitleIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToSubtitle+6)
                let subTitleAndOn = JSONAsString.substring(from: subtitleIndex)
                print(subTitleAndOn)
                let rangeToTitle: Range<String.Index> = subTitleAndOn.range(of: "title = \"")!
                let distanceToTitle = Int(subTitleAndOn.distance(from: subTitleAndOn.startIndex, to: rangeToTitle.lowerBound))
                let titleIndex = subTitleAndOn.index(subTitleAndOn.startIndex, offsetBy: distanceToTitle+9)
                let titleAndOn = subTitleAndOn.substring(from: titleIndex)
                let rangeToEndQuote: Range<String.Index> = titleAndOn.range(of: "\"")!
                let distanceToEndQuote = Int(titleAndOn.distance(from: titleAndOn.startIndex, to: rangeToEndQuote.lowerBound))
                let finalIndex = titleAndOn.index(titleAndOn.startIndex, offsetBy: distanceToEndQuote)
                let finalTitle = titleAndOn.substring(to: finalIndex)
                
                
                DispatchQueue.main.async(execute: {() -> Void in
                    //Sets Title Label To Correct Value
                    self.titleLabel?.text = finalTitle;

                })
                

                //let distanceToTitle = Int(distanceToSubtitle.distance(from: distanceToSubtitle.startIndex, to: rangeToSubtitle.lowerBound))
                
                
                
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

