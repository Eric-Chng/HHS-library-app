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
    var ID: CLong?
    var name: String?
    var ISBN: String?
    var authorID: CLong?
    var desc: String?
    var BookCoverImage: UIImageView!
    var title: String?
    var JSONParsed: Bool = false
    var author: String?
    //var timer: Timer = Timer()

    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //constructor
    
    init(ID: CLong, name: String, author: CLong, desc: String) {
        self.ID = ID
        self.name = name
        self.authorID = author
        self.desc = desc
        
    }
    
    init(ISBN: String)
    {
        self.ISBN = ISBN
    }
    
    init(JSON: String)
    {
        super.init()
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
    
    
    //prints object's current state
    
    override var description: String
    {
        return "Name: \(name ?? "Rien trouvé"), Description: \(desc)" //, Author: \(author)  - will have to extract and store for easier access?
    }
    
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
            finalTitle = finalTitle.substring(from: firstQuoteIndex)
            let lastQuoteIndex = finalTitle.index(finalTitle.endIndex, offsetBy: -1)
            finalTitle = finalTitle.substring(to: lastQuoteIndex)
            
        }
        self.title = finalTitle
            //print("The Title is found to be: " + finalTitle)
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
            self.author = finalAuthor
            //print("The Author is \"" + finalAuthor + "\"")
            //print("Title: \"" + finalTitle + "\" by " + finalAuthor)
            
            let tempIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle + distanceToSemiColon)
            
            var tempString = JSONAsString.substring(to: tempIndex)
            var finalISBN = "Incomplete Google Books Listing"
            //Parses out ISBN
            if let rangeToISBN: Range<String.Index> = tempString.range(of: "type = \"ISBN_13\"")
            {
                let distanceToISBN = Int(tempString.distance(from: tempString.startIndex, to: rangeToISBN.lowerBound))
                //print(distanceToISBN)
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
                //print(distanceToISBN)
                let thumbnailIndex = tempString.index(tempString.startIndex, offsetBy: distanceToThumbnail+14)
                let thumbnailAndOn = tempString.substring(from: thumbnailIndex)
                
                let rangeToEndQuote: Range<String.Index> = thumbnailAndOn.range(of: ";")!
                let distanceToEndQuote = Int(thumbnailAndOn.distance(from: thumbnailAndOn.startIndex, to: rangeToEndQuote.lowerBound))
                let endQuoteIndex = thumbnailAndOn.index(thumbnailAndOn.startIndex, offsetBy: distanceToEndQuote-1)
                finalThumbnail = thumbnailAndOn.substring(to: endQuoteIndex)
                //finalISBN = ISBNAndOn.substring(to: colonIndex)
                //print("ISBN_13: " + finalISBN)
                print("Thumbnail URL: " + finalThumbnail)
                
                
            }
            }
    }
        
    }//end of ParseJSON
}
