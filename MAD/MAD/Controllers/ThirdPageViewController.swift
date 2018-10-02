//
//  ThirdPageViewController.swift
//  MAD
//
//  Created by David McAllister on 2/3/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit

class ThirdPageViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginButtonView: UIView!
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "user_friends", "email"]
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let fadeView = UIView.init(frame: loginButton.frame)
        fadeView.backgroundColor = UIColor.gray
        fadeView.alpha = 0.0
        

        let label = UILabel.init(frame: CGRect(x: fadeView.center.x-100, y: fadeView.center.y-50, width: 200, height: 100))
        label.alpha = 0.0
        label.text = "Facebook Integration Coming Soon"
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
            fadeView.alpha = 1.0
            label.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.frame = CGRect(x: 0, y: 0, width: loginButtonView.frame.width, height: loginButtonView.frame.height)
        
        loginButtonView.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.isUserInteractionEnabled = false
//        UIView.animate(withDuration: 1.4, delay: 0.5, animations: {self.loginButton.alpha = 0.8}, completion: nil)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
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
