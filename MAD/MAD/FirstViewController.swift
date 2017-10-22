//
//  FirstViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C, David McAllister, Varun Tandon All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navBar.title = "Home"
        //navigationItem.title="Home"
        setupNavigationBarItems()
    navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.\
        //eric cheng
    }
    
    private func setupNavigationBarItems()
    {
        navigationItem.title = "Home"
        
    }
    
    
    @IBOutlet weak var UIScrollView: UIScrollView!
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

