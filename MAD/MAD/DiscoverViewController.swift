//
//  DiscoverViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/25/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewController: UIViewController{
   
    
    
    @IBAction func searchButton(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "searchController") as! SearchTableViewController
        
        
        //self.navigationController?.push
        self.navigationController?.pushViewController(scanners, animated: true)
    }
    
    override func viewDidLoad() {
       
        //self.definesPresentationContext = NO;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
