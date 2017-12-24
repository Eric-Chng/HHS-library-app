//
//  SearchTableViewCell.swift
//  MAD
//
//  Created by David McAllister on 12/23/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

     @IBOutlet weak var bookCover: UIImageView!
     @IBOutlet weak var authorLabel: UILabel!
     @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
