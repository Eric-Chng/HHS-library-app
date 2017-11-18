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
        
        titleLabel?.text = "Alexander and the Terrible, Horrible, No Good, Very Bad Day"

        titleLabel?.sizeToFit()

        authorLabel?.text = "Colson Whitehead"
        descLabel?.text = "Description: " + "the best description"
        //self.BookCoverImage.image = #imageLiteral(resourceName: "sampleCover")
        //BookCoverImage.clipsToBounds
        
        
        /*
         Root Stack View.Leading = Superview.LeadingMargin
         Root Stack View.Trailing = Superview.TrailingMargin
         Root Stack View.Top = Top Layout Guide.Bottom + 20.0
         Bottom Layout Guide.Top = Root Stack View.Bottom + 20.0
         Image View.Height = Image View.Width
         First Name Text Field.Width = Middle Name Text Field.Width
         First Name Text Field.Width = Last Name Text Field.Width

         */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}
