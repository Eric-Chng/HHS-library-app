//
//  BookModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/30/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation

class BookModel: NSObject {
    
    //properties
    
    var name: String?
    var author: String?
    var desc: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(name: String, author: String, desc: String) {
        
        self.name = name
        self.author = author
        self.desc = desc
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Author: \(author), Description: \(desc)"
        
    }
    
    
}
