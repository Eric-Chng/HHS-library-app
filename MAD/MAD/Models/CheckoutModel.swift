//
//  CheckoutModel.swift
//  MAD
//
//  Created by NonAdmin Eric on 2/6/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import Foundation
import UIKit
class CheckoutModel: NSObject {
    
    //properties
    var transactionID: String?
    var ISBN: String?
    var userID: String?
    var startTimestamp: String?
    var endTimestamp: String?

    override init() {
        
    }
    //constructor
    
    init(transactionID: String, ISBN: String, userID: String, startTimestamp: String, endTimestamp: String) {
        
        self.ISBN = ISBN
        self.transactionID = transactionID
        self.userID = userID
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        
    }
}
