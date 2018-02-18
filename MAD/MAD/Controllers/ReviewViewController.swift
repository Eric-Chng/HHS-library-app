//
//  ReviewViewController.swift
//  MAD
//
//  Created by David McAllister on 2/16/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import Lottie

class ReviewViewController: UIViewController {

    
    var currentScore: Int = 0
    @IBOutlet weak var starView1: UIView!
    
    @IBOutlet weak var starView2: UIView!
    
    @IBOutlet weak var starView3: UIView!
    
    @IBOutlet weak var starView4: UIView!
    
    @IBOutlet weak var starView5: UIView!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    @IBOutlet weak var ratingCommentaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStarViews()
        self.bookCoverImageView.layer.cornerRadius = 8
        self.bookCoverImageView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func oneStarPressed(_ sender: Any)
    {
        self.currentScore = 1
        self.updateStarViews()
        self.ratingCommentaryLabel.text = "Poor"
    }
    
    
    @IBAction func twoStarPressed(_ sender: Any)
    {
        self.currentScore = 2
        self.updateStarViews()
        self.ratingCommentaryLabel.text = "Mediocre"

    }
    
    @IBAction func threeStarPressed(_ sender: Any)
    {
        self.currentScore = 3
        self.updateStarViews()
        self.ratingCommentaryLabel.text = "Good"

    }
    
    @IBAction func fourStarPressed(_ sender: Any)
    {
        self.currentScore = 4
        self.updateStarViews()
        self.ratingCommentaryLabel.text = "Very Good"

    }
    
    
    @IBAction func fiveStarPressed(_ sender: Any)
    {
        self.currentScore = 5
        self.updateStarViews()
        self.ratingCommentaryLabel.text = "Amazing"

    }
    
    func updateStarViews()
    {
        self.clearStarViews()
        
        if(currentScore > 0)
        {
            let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            animationView.contentMode = .scaleToFill
            animationView.frame = CGRect.init(x: -21, y: -19, width: 100, height: 100)
            self.starView1.addSubview(animationView)
            animationView.play()
        }
        else
        {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "emptyStar"))
            imageView.contentMode = .scaleToFill
            let frame = self.starView1.frame
            imageView.frame = CGRect(x: 16, y: 16, width: frame.width-32, height: frame.height-32)
            imageView.alpha = 0.5

            self.starView1.addSubview(imageView)
        }
        if(currentScore > 1)
        {
            let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            animationView.contentMode = .scaleToFill
            animationView.frame = CGRect.init(x: -21, y: -19, width: 100, height: 100)
            self.starView2.addSubview(animationView)
            animationView.play()
        }
        else
        {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "emptyStar"))
            imageView.contentMode = .scaleToFill
            let frame = self.starView2.frame
            imageView.frame = CGRect(x: 16, y: 16, width: frame.width-32, height: frame.height-32)
            imageView.alpha = 0.5

            self.starView2.addSubview(imageView)
            
        }
        if(currentScore > 2)
        {
            let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            animationView.contentMode = .scaleToFill
            animationView.frame = CGRect.init(x: -21, y: -19, width: 100, height: 100)
            self.starView3.addSubview(animationView)
            animationView.play()
        }
        else
        {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "emptyStar"))
            imageView.contentMode = .scaleToFill
            let frame = self.starView3.frame
            imageView.frame = CGRect(x: 16, y: 16, width: frame.width-32, height: frame.height-32)
            imageView.alpha = 0.5

            self.starView3.addSubview(imageView)
        }
        if(currentScore > 3)
        {
            let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            animationView.contentMode = .scaleToFill
            animationView.frame = CGRect.init(x: -21, y: -19, width: 100, height: 100)
            self.starView4.addSubview(animationView)
            animationView.play()
        }
        else
        {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "emptyStar"))
            imageView.contentMode = .scaleToFill
            let frame = self.starView4.frame
            imageView.frame = CGRect(x: 16, y: 16, width: frame.width-32, height: frame.height-32)
            imageView.alpha = 0.5

            self.starView4.addSubview(imageView)
        }
        if(currentScore > 4)
        {
            let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
            animationView.contentMode = .scaleToFill
            animationView.frame = CGRect.init(x: -21, y: -19, width: 100, height: 100)
            self.starView5.addSubview(animationView)
            animationView.play()
        }
        else
        {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "emptyStar"))
            imageView.contentMode = .scaleToFill
            let frame = self.starView5.frame
            imageView.frame = CGRect(x: 16, y: 16, width: frame.width-32, height: frame.height-32)
            imageView.alpha = 0.5

            self.starView5.addSubview(imageView)
        }
    }
    
    func clearStarViews()
    {
        if(self.starView1.layer.sublayers != nil)
        {
            for subLayer in self.starView1.layer.sublayers! {
                if(subLayer.isKind(of: UIButton.classForCoder()) == false)
                {
                    subLayer.removeFromSuperlayer()
                }
                
            }
            self.starView1.layer.addSublayer(CALayer())
            self.starView1.addSubview(UIView())

        }
        if(self.starView2.layer.sublayers != nil)
        {
            for subLayer in self.starView2.layer.sublayers! {
                if(subLayer.isKind(of: UIButton.classForCoder()) == false)
                {
                    subLayer.removeFromSuperlayer()
                }
                
            }
            self.starView2.layer.addSublayer(CALayer())
            self.starView2.addSubview(UIView())


        }
        if(self.starView3.layer.sublayers != nil)
        {
            for subLayer in self.starView3.layer.sublayers! {
                if(subLayer.isKind(of: UIButton.classForCoder()) == false)
                {
                    subLayer.removeFromSuperlayer()
                }
                
            }
            self.starView3.layer.addSublayer(CALayer())
            self.starView3.addSubview(UIView())

        }
        if(self.starView4.layer.sublayers != nil)
        {
            for subLayer in self.starView4.layer.sublayers! {
                if(subLayer.isKind(of: UIButton.classForCoder()) == false)
                {
                    subLayer.removeFromSuperlayer()
                }
                
            }
            self.starView4.layer.addSublayer(CALayer())
            self.starView4.addSubview(UIView())


        }
        if(self.starView5.layer.sublayers != nil)
        {
            //print("clearing 5")

            for subLayer in self.starView5.layer.sublayers! {
                if(subLayer.isKind(of: UIButton.classForCoder()) == false)
                {
                subLayer.removeFromSuperlayer()
                }
            }
            self.starView5.layer.addSublayer(CALayer())
            self.starView5.addSubview(UIView())

            

        }
        
    }
    
    
    
}
