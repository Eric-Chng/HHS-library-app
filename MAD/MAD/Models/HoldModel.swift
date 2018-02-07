//
//  AuthorModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 11/8/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation

class HoldModel: NSObject {
    
    ///properties
    var ID: String?
    var userID: String?
    var ISBN: String?
    var startTimestamp: String?
    var ready: Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct this shit
    
    init(ID: String, userID: String, ISBN: String, startTimestamp: String, ready:Int) {
        self.ID = ID
        self.userID = userID
        self.ISBN = ISBN
        self.startTimestamp = startTimestamp
        self.ready = ready
        
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(ID), User ID: \(userID), ISBN: \(ISBN)"
        
    }
    
    
}

