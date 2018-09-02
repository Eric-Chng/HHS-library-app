//
//  HomeRecommendationCollectionViewCell.swift
//  MAD
//
//  Created by David McAllister on 4/18/18.
//  Copyright © 2018 Eric C. All rights reserved.
//


import UIKit

class HomeRecommendationCollectionViewCell: UICollectionViewCell {
    
    //var mainView: UIView = UIView();
    
    
    @IBOutlet weak var mainView: UIView!
    var cellID: Int = Int(arc4random_uniform(1200))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.backgroundColor = UIColor.red
    }
    
    /*
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        print("initialized")
        //mainView = UIView(frame: contentView.bounds)
        //contentView.addSubview(mainView)
        // Initialize the mainView property and add it to the cell's contentView
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    */
    
}

