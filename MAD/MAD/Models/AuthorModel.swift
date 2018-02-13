//
//  AuthorModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 11/8/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation

class AuthorModel: NSObject {
    
    ///properties
    var ID: CLong?
    var name: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct
    
    init(ID: CLong, name: String) {
        self.ID = ID
        self.name = name

        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(String(describing: name))"
        
    }
    
    
}
