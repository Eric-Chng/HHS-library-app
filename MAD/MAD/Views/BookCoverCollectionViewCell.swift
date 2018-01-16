//
//  BookCoverCollectionViewCell.swift
//  MAD
//
//  Created by Lily Li on 12/26/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit

class BookCoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var boundingView: UIView!
    var timer = Timer()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.layer.cornerRadius=15
        coverImageView.layer.masksToBounds=true
        boundingView.layer.cornerRadius=25
        boundingView.layer.masksToBounds=true
        
        //timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        
    }
    
    /*
    @objc func action()
    {
        print(titleLabel.text)
    }
     */
}
