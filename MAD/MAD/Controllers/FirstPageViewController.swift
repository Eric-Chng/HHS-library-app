//
//  FirstPageViewController.swift
//  MAD
//
//  Created by David McAllister on 2/3/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import Lottie

class FirstPageViewController: UIViewController {

    @IBOutlet weak var animationBoundingView: UIView!
    
    @IBOutlet weak var bookBoundingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookBoundingView.layer.cornerRadius = 80
        self.bookBoundingView.layer.masksToBounds = true
        
        //let animationView: LOTAnimationView = LOTAnimationView(name: "starPop");
        let animationView: LOTAnimationView = LOTAnimationView(name: "bookUpdated");

        animationView.contentMode = .scaleToFill
        //animationView.frame = CGRect(x: 0, y: 0, width: self.animationBoundingView.frame.width, height: self.animationBoundingView.frame.height)
        animationBoundingView.addSubview(animationView)
        animationView.loopAnimation = true
        //animationView.play()
        animationView.contentMode = .scaleToFill

        animationView.play(fromProgress: 0, toProgress: 0.2, withCompletion: nil)
        //animationView.play()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
