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
    var ID: CLong?
    var name: String?
    var authorID: CLong?
    var desc: String?
    
    
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
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Description: \(desc)" //, Author: \(author)  - will have to extract and store for easier access?
        
    }
    
    
}
