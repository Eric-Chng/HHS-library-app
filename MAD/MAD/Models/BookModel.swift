//
//  BookModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/30/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
//import ObjectMapper

class BookModel: NSObject {
    
    //properties
    var name: String?
    var ISBN: String?
    var authorID: CLong?
    var desc: String! = "No description found"
    var BookCoverImage: UIImageView! 
    var title: String?
    var JSONParsed: Bool = false
    var author: String?
    var googleImageURL: String?
    var foundGoogleImage: Bool = false;
    var rating: Double = -3.0 //not found if negative
    var bookCount: Int? //COPIES OF BOOK AVAILABLE. WE SHOULD INITIALIZE WHEN USING IT
    var bookTotal: Int?
    var setTitle: Bool = true
    
    //var timer: Timer = Timer()
    
    
    
    //empty constructor
    
    override init()
    {
    }
    
    func getImage() -> UIImage
    {
        if(self.BookCoverImage != nil && self.BookCoverImage.image != nil)
        {
            return self.BookCoverImage.image!
        }
        else
        {
            return #imageLiteral(resourceName: "loadingImage")
        }
    }
    
    //constructor
    
    @available(iOS, deprecated: 9.0)
    init(ISBN: String, name: String, author: String, desc: String) {
        super.init()
        self.setTitle = false
        DispatchQueue.main.async {
            self.BookCoverImage = UIImageView.init(image: #imageLiteral(resourceName: "loadingImage"))
            //self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
        }
        
        self.ISBN = ISBN
        //self.name = name
        self.title = name
        
        
        self.author = author
        self.desc = desc
        downloadData(ISBN: ISBN)
    }
    
    @available(iOS, deprecated: 9.0)
    init(ISBN: String)
    {
        self.ISBN = ISBN
        super.init()
        downloadData(ISBN: ISBN)
        
    }
    
    @available(iOS, deprecated: 9.0)
    func downloadData(ISBN: String)
    {
        DispatchQueue.main.async {
            self.BookCoverImage = UIImageView.init(image: #imageLiteral(resourceName: "loadingImage"))
        }
        
        var JSONAsString: String = ""
        
        
        let todoEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=isbn+" + ISBN/* + "&key=AIzaSyCvF4JpS257MnToHz9nv7339wwchjWSB-w" */+ "&key=AIzaSyBCy__wwGef5LX93ipVp1Ca5ovoLpMqjqw"
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
                print("error calling with Google Books GET call with ISBN: " + ISBN)
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
                            //Converts JSON into a String
                            DispatchQueue.main.async(execute: {() -> Void in
                            })
                }
                JSONAsString =  String(describing: googleBooksJSON)
                self.parseJSON(JSONAsString: JSONAsString)
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        self.name = self.title
        task.resume()
    }
    
    @available(iOS, deprecated: 9.0)
    init(JSON: String)
    {
        super.init()
        DispatchQueue.main.async {
            self.BookCoverImage = UIImageView.init(image: #imageLiteral(resourceName: "loadingImage"))
            
            
        }
        
        

        self.parseJSON(JSONAsString: JSON)
    }
    
    
    
    
    func printInfo()
    {
        
        print("Title: " + self.title!)
        print("Author: " + self.author!)
        if(ISBN != nil)
        {
            print("ISBN: " + self.author!)
        }
        print("Description: " + self.author!)
        print("[description end]")
        
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
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    self.BookCoverImage.image = temp
                    found = true;
                    print("Image downloaded")
                }
                else
                {
                    if(self.foundGoogleImage == false)
                    {
                        print("Image not found")
                        self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                    }
                }
                
            }
        }
        if(found == false)
        {
            if let googleURL = URL(string: self.googleImageURL!) {
                self.getDataFromUrl(url: googleURL) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        let temp: UIImage? = UIImage(data: data)
                        if(temp != nil && Double((temp?.size.height)!)>20.0)
                        {
                            self.BookCoverImage.image = temp
                            self.foundGoogleImage = true
                        }
                    }
                }
            }
        }
    }
    
    override var description: String
    {
        return "Title: \(String(describing: name)), by \(String(describing: authorID) ), ISBN: \(String(describing: ISBN))"
    }
    
    @available(iOS, deprecated: 9.0)
    func parseJSON(JSONAsString: String)
    {

        if let rangeTotitle: Range<String.Index> = JSONAsString.range(of: " title = ")
        {
            var finalTitle = "Not found"
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
                finalTitle = String(finalTitle[firstQuoteIndex...])   //finalTitle.substring(from: firstQuoteIndex)
                let lastQuoteIndex = finalTitle.index(finalTitle.endIndex, offsetBy: -2)
                finalTitle = String(finalTitle[...lastQuoteIndex]) //finalTitle.substring(to: lastQuoteIndex)
                
            }
            if(self.setTitle == true)
            {
            self.title = finalTitle
            }
            var finalAuthor = "Not available"
            //Parses out the author
            if let rangeToAuthors: Range<String.Index> = JSONAsString.range(of: "authors = ")
            {
                let distanceToAuthors = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToAuthors.lowerBound))
                let authorsIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToAuthors+33)
                let temp = JSONAsString[authorsIndex...]
                let authorsAndOn = String(temp)
                let rangeToQuote: Range<String.Index> = authorsAndOn.range(of: "\"")!
                let distanceToQuote = Int(authorsAndOn.distance(from: authorsAndOn.startIndex, to: rangeToQuote.lowerBound))-1
                let quoteIndex = authorsAndOn.index(authorsAndOn.startIndex, offsetBy: distanceToQuote)
                
                //finalAuthor = authorsAndOn.substring(to: quoteIndex)
                let substring1 = authorsAndOn[...quoteIndex]
                finalAuthor = String(substring1)
                if(self.setTitle == true)
                {
                self.author = finalAuthor
                }
                
                let tempIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle + distanceToSemiColon)
                
                
                let tempString = String(JSONAsString[...tempIndex])
                var finalISBN = "Incomplete Google Books Listing"
                if let rangeToISBN: Range<String.Index> = tempString.range(of: "type = \"ISBN_13\"")
                {
                    let distanceToISBN = Int(tempString.distance(from: tempString.startIndex, to: rangeToISBN.lowerBound))
                    let ISBNIndex = tempString.index(tempString.startIndex, offsetBy: distanceToISBN-31)
                    let ISBNAndOn = tempString.substring(from: ISBNIndex)
                    let rangeToColon: Range<String.Index> = ISBNAndOn.range(of: ";")!
                    let distanceToColon = Int(ISBNAndOn.distance(from: ISBNAndOn.startIndex, to: rangeToColon.lowerBound))
                    let colonIndex = ISBNAndOn.index(ISBNAndOn.startIndex, offsetBy: distanceToColon)
                    finalISBN = ISBNAndOn.substring(to: colonIndex)
                    
                    
                }
                self.ISBN = finalISBN
                
                var finalThumbnail: String = ""
                if let rangeToThumbnail: Range<String.Index> = tempString.range(of: " thumbnail = ")
                {
                    let distanceToThumbnail = Int(tempString.distance(from: tempString.startIndex, to: rangeToThumbnail.lowerBound))
                    let thumbnailIndex = tempString.index(tempString.startIndex, offsetBy: distanceToThumbnail+14)
                    let thumbnailAndOn = tempString.substring(from: thumbnailIndex)
                    
                    let rangeToEndQuote: Range<String.Index> = thumbnailAndOn.range(of: ";")!
                    let distanceToEndQuote = Int(thumbnailAndOn.distance(from: thumbnailAndOn.startIndex, to: rangeToEndQuote.lowerBound))
                    let endQuoteIndex = thumbnailAndOn.index(thumbnailAndOn.startIndex, offsetBy: distanceToEndQuote-1)
                    finalThumbnail = /*String(thumbnailAndOn[...endQuoteIndex])*/thumbnailAndOn.substring(to: endQuoteIndex)
                    self.googleImageURL = finalThumbnail
                    if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + self.ISBN! + "-L.jpg")
                    {
                        
                        self.downloadCoverImage(url: url)
                    }
                    var finalDescription = "Not available";
                    
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
                        
                        if let rangeToRating: Range<String.Index> = JSONAsString.range(of: "averageRating")
                        {
                        let distanceToRating = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToRating.lowerBound))
                        let ratingIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToRating+17)
                        let ratingAndOn = JSONAsString.substring(from: ratingIndex)
                        let ratingEndIndex = ratingAndOn.index(ratingAndOn.startIndex, offsetBy: 2)
                        let tempo = ratingAndOn[...ratingEndIndex]
                        let temper = String(tempo)
                            //print("Rating: " + temper)
                        if let ratingAsDouble = Double(temper)
                        {
                            //print("As double: " + String(describing: ratingAsDouble))
                            rating = ratingAsDouble
                            }
                            
                            
                            

                        }
                        
                        
                        var ignored:String = "";
                        while let rangeToBackslash: Range<String.Index> = finalDescription.range(of: "\\")
                        {
                            var isQuote:Bool = false;
                            let distanceToBackslash = Int(finalDescription.distance(from: finalDescription.startIndex, to: rangeToBackslash.lowerBound))
                            let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash)
                            let finalDescription2: String = String(finalDescription[backslashIndex...])//finalDescription.substring(from: backslashIndex)
                            
                            /*finalDescription2.substring(to: finalDescription2.index(finalDescription2.startIndex, offsetBy: 2))*/
                            
                            var temp1 = String(finalDescription[...backslashIndex])//finalDescription.substring(to: backslashIndex)
                            //if(String(finalDescription2[...finalDescription2.index(finalDescription2.startIndex, offsetBy: 2)]) == "\\\"")
                            if(finalDescription2.count>2)
                            {
                            if(finalDescription2.substring(to: finalDescription2.index(finalDescription2.startIndex, offsetBy: 2)) == "\\\"")
                            {
                                let backslashIndex = finalDescription.index(finalDescription.startIndex, offsetBy: distanceToBackslash)
                                isQuote = true;
                                finalDescription = String(finalDescription[backslashIndex...]) //finalDescription.substring(from: backslashIndex)
                                ignored = ignored + temp1;
                            }
                        }
                            
                            
                            if(isQuote == false)
                            {
                                var temp2 = finalDescription2
                                if(finalDescription2.count>7)
                                {
                                let backslashIndex2 = finalDescription2.index(finalDescription2.startIndex, offsetBy: 8)
                                temp2 = String(finalDescription2[backslashIndex2...]) //finalDescription2.substring(from: backslashIndex2)
                                if(temp1.count > 1)
                                {
                                    let m = temp1.index(temp1.endIndex, offsetBy: -2)
                                    temp1 = String(temp1[...m])
                                }
                                else
                                {
                                    temp1 = ""
                                }
                                }
                                finalDescription = temp1 + temp2
                            }
                            else
                            {
                                if(ignored.count >  1)
                                {
                                    
                                    let temporaryIndex = ignored.index(ignored.endIndex, offsetBy: -2)
                                    ignored = String(ignored[...temporaryIndex])
                                    if(self.title == "Hello Hello")
                                    {
                                    }
                                    ignored = ignored + "\""
                                }
                                let twoCharacterIndex = finalDescription.index(finalDescription.startIndex, offsetBy: 2)
                                finalDescription = String(finalDescription[twoCharacterIndex...])
                            }
                        }
                        finalDescription = ignored + finalDescription;
                        self.desc = finalDescription
                        
                    }
                }
            }
            
        }//end of ParseJSON
        
        
        
    }
    
}
