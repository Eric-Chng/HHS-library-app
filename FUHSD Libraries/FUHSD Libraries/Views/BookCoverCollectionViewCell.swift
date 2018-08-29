//
//  BookCoverCollectionViewCell.swift
//  MAD
//
//  Created by Lily Li on 12/26/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit
import Lottie

class BookCoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var boundingView: UIView!
    var animationView: LOTAnimationView = LOTAnimationView(name: "scan");
    var timer = Timer()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.layer.cornerRadius=15
        coverImageView.layer.masksToBounds=true
        boundingView.layer.cornerRadius=25
        boundingView.layer.masksToBounds=true
        //coverImageView.backgroundColor = UIColor.blue
        //let animationView: LOTAnimationView = LOTAnimationView(name: "scan");
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 17, y: 55, width: 135, height: 135)
        coverImageView.tintColor = UIColor.red
        
        
        self.boundingView.addSubview(animationView)
        //self.boundingView.sendSubview(toBack: animationView)
        self.boundingView.bringSubview(toFront: coverImageView)
        //self.coverImageView.sendSubview(toBack: animationView)
        
        animationView.loopAnimation = true
        //animationView.play()
        animationView.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        
    }
    
    
    @objc func action()
    {
        //print(titleLabel.text)
        if(self.coverImageView.image != nil  && animationView.isHidden == false)
        {
            animationView.pause()
            animationView.isHidden = true
            self.timer.invalidate()

            //print(titleLabel.text)
        }
    }
    
}
