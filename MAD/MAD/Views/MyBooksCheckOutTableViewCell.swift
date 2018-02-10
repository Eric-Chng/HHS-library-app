//
//  MyBooksCheckOutTableViewCell.swift
//  MAD
//
//  Created by Lily Li on 2/9/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit

class MyBooksCheckOutTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
