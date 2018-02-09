//
//  FinalPageViewController.swift
//  MAD
//
//  Created by David McAllister on 2/7/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit

class FinalPageViewController: UIViewController {

    @IBOutlet weak var goButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.layer.cornerRadius = 12
        goButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        //self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "IntroToHome", sender: self)
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
