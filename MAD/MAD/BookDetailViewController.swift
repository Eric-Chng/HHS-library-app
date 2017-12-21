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
                print("error calling GET on /todos/1")
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
                // now we have the todo
                // let's just print it to prove we can access it
               // print(googleBooksJSON)
            
                
                
                if (googleBooksJSON["items"] as? [String: Any]) != nil {
                    print("found")
                        // access individual value in dictionary
                    
                }
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = googleBooksJSON["item"] as? NSDictionary? else {
                    print("Could not get todo title from JSON")
                    return
                }
                print(String(describing: todoTitle))
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
       task.resume()
        
        if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + BookDetailViewController.ISBN + "-L.jpg") {
            //imageView.contentMode = .scaleAspectFit
            downloadCoverImage(url: url)
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
        ISBN = newISBN;
    }
    
    
}
