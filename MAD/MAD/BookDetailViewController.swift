//
//  BookDetailViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/30/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class BookDetailViewController : UIViewController {
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var authorLabel:UILabel?
    
    @IBOutlet weak var descBox: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var rawDescription: String = "[loading description]";
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var reserveButtonImage: UIImageView!
    @IBOutlet weak var BookCoverImage: UIImageView!
    @IBAction func DoneButton(_ sender: Any) {
       // _ = popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func expandDescription(_ sender: Any) {
        //descBox?.attributedText = NSAttributedString(string: rawDescription,  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
        //descBox.sizeToFit();
    }
    
    var selectedBook : BookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = "Papercraft"

        titleLabel?.sizeToFit()
        //reserveButtonImage.image = #imageLiteral(resourceName: "reserveicon3");
        authorLabel?.text = "Mandy Cooper"
        descBox?.attributedText = NSAttributedString(string: "The next planet was inhabited by a tippler. This was a very short visit, but it plunged the little prince into deep dejection. The fourth planet belonged to a businessman. This man was so much occupied that he did not even raise his head at the little prince's arrival.  The next planet was inhabited by a tippler. This was a very short visit, but it plunged the little prince into deep dejection. The fourth planet belonged to a businessman. This man was so much occupied that he did not even raise his head at the little prince's arrival.",  attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ])
        rawDescription = (descBox?.attributedText.string)!;
        descBox?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        var addDots:Bool = false;
        while/* (descBox?.contentSize.height)!>CGFloat(180)*/ descBox!.attributedText.length>356 {
            addDots = true;
            
            let subRange = NSMakeRange(0,(descBox?.attributedText.length)!-5)
            descBox?.attributedText = descBox?.attributedText.attributedSubstring(from: subRange)
        }
        if(addDots)
        {
            let stringVersion = descBox?.attributedText.string
            let stringIndex = descBox?.attributedText.string.range(of: " ", options: .backwards)?.lowerBound
            
            let finalString = stringVersion?.substring(to: stringIndex!);
            /*
            let wordLength = stringIndex.count;
            let index:Int = stringVersion?.startIndex.distanceTo(stringIndex);
           // let subRange = NSMakeRange(0,Int(descBox?.attributedText.string.range(of: ".", options: .backwards)?.lowerBound));
 
            descBox?.attributedText = descBox?.attributedText.attributedSubstring(from: subRange)
           */ descBox?.attributedText=NSAttributedString(string: /*(descBox?.attributedText.string)!*/finalString!+"... (more)",attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16) ]);
        }
        descBox.sizeToFit();
        //descBox?.attributedText
        mapView.layer.cornerRadius = 25
        mapView.layer.masksToBounds = true
        
        checkoutButton.layer.cornerRadius=15
        checkoutButton.layer.masksToBounds=true
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33712,  -122.04896), MKCoordinateSpanMake(0.0004, 0.0004)), animated: true)
        
        
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
