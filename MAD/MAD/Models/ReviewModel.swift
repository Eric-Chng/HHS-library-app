//
//  AuthorModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 11/8/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation

class ReviewModel: NSObject {
    
    ///properties
    var ID: String?
    var userID: String?
    var ISBN: String?
    var rating: Int?
    var text: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct
    
    init(ID: String, userID: String, ISBN: String, rating: Int, text:String) {
        self.ID = ID
        self.userID = userID
        self.ISBN = ISBN
        self.rating = rating
        self.text = text
        
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(String(describing: ID)), User ID: \(String(describing: userID)), ISBN: \(String(describing: ISBN)), Rating: \(String(describing: rating))"
        
    }
    
    
}


