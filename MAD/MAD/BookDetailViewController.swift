//
//  BookDetailViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/30/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit

class BookDetailViewController : UIViewController {
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    @IBOutlet weak var descLabel:UILabel?
    @IBOutlet weak var BookCoverImage: UIImageView!
    
    @IBAction func DoneButton(_ sender: Any) {
       // _ = popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    var selectedBook : BookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = "The Underground Railroad"
        titleLabel?.sizeToFit()
        authorLabel?.text = "Colson Whitehead"
        descLabel?.text = "Description: " + "the best description"
        self.BookCoverImage.image = #imageLiteral(resourceName: "sampleCover")

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}
