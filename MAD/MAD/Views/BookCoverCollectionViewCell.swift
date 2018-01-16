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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
