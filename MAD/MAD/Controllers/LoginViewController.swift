//
//  LoginViewController.swift
//  MAD
//
//  Created by David McAllister on 2/3/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import GoogleSignIn
import Lottie

class LoginViewController: UIViewController, DownloadProtocol, GIDSignInUIDelegate {
    
    @IBOutlet weak var incorrectCredentialsLabel: UILabel!
    let animationView: LOTAnimationView = LOTAnimationView(name: "loginBook")
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var lottieViewHolder: UIView!
    
    func itemsDownloaded(items: NSArray, from: String) {
        self.loginButton.setTitle("Login", for: UIControlState.normal)
        if (String(describing: items.firstObject) == "failed") {
            userNameField.text = ""
            passwordField.text = ""
            self.incorrectCredentialsLabel.alpha = 1.0
            
        } else {
            let user = items.firstObject
            switch user {
            case is UserModel:
                //let userCasted = user as! UserModel
//                UserDefaults.standard.set(self.userNameField.text,forKey: "id")
//                UserDefaults.standard.set(self.passwordField.text,forKey: "credential")
                UserDefaults.standard.set((user as! UserModel).name, forKey: "userName")

                if UserDefaults.standard.object(forKey: "FirstLogin") == nil
                {
                    UserDefaults.standard.set("false", forKey: "FirstLogin")
                    self.performSegue(withIdentifier: "LoginToIntro", sender: self)
                    
                }
                else
                {
                    self.performSegue(withIdentifier: "LoginToTabs", sender: self)
                    
                }
            default:
                userNameField.text = ""
                passwordField.text = ""
                self.incorrectCredentialsLabel.alpha = 1.0

            }
        }
    }
    
    var timer: Timer = Timer()
    var counter: Int = 0
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var libraryBackdrop: UIImageView!
    @IBOutlet weak var fadeOutView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backBlurView: UIVisualEffectView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var googleButtonFrame: UIView!
    var animationCounter = 0
    
    @objc func checkForGoogleSignIn()
    {
        animationCounter = animationCounter + 1
        if(animationCounter%8 == 0)
        {
            animationView.play()
        }
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Login validated")
            let user = GIDSignIn.sharedInstance().currentUser
            let profile = user?.profile
            let firstName = profile?.givenName
            self.userNameField.text = firstName
            let email = profile?.email
            if email?.range(of:"fuhsd.org") != nil
            {
                let login = UserLoginVerify()
                login.delegate = self
                login.verifyLogin(schoolID: "1234567", password: "test")
                timer.invalidate()
            }
            else if email != nil
            {
                self.incorrectCredentialsLabel.alpha = 1.0
                GIDSignIn.sharedInstance().signOut()

            }
            

        } else {
            print("Not logged in")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.incorrectCredentialsLabel.alpha = 0.0
        self.userNameField.layer.cornerRadius = 12
        self.passwordField.layer.cornerRadius = 12
        self.userNameField.layer.masksToBounds = true
        self.passwordField.layer.masksToBounds = true
        self.iconImage.layer.cornerRadius = 12
        self.iconImage.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        let signInButton = GIDSignInButton(frame: CGRect(x: view.center.x - 99, y: googleButtonFrame.frame.minY, width: 156, height: 48))
        view.addSubview(signInButton)
        signInButton.style = .wide

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:
            #selector(self.checkForGoogleSignIn), userInfo: nil,  repeats: true)
        
        
        
        if let userID = UserDefaults.standard.object(forKey: "id")
        {
            let idAsString = String(describing: userID)
        

        let userCredential = UserDefaults.standard.object(forKey: "credential")
        
        if(idAsString.count > 2 && String(describing: userCredential).count > 2)
        {
            

            self.loginButton.setTitle("Logging in...", for: UIControlState.normal)
            //self.loginButton.titleLabel?.text = "Logging in..."
            let login = UserLoginVerify()
            login.delegate = self
            self.userNameField.text = idAsString
            self.passwordField.text = String(describing: userCredential!)
            login.verifyLogin(schoolID: idAsString, password: String(describing: userCredential!))
            
            }
        else{
            self.userNameField.text = ""
            self.passwordField.text = ""
        }
        }
        
        backBlurView.alpha = 0.4
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height+130)
        backgroundImage.addSubview(effectView)
        signInButton.alpha = 0.0
        effectView.alpha = 0
        self.iconImage.alpha = 0
        self.userNameField.alpha = 0.0
        self.passwordField.alpha = 0.0
        self.loginButton.alpha = 0.0
        UIView.animate(withDuration: 0.9) {
            effectView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5, delay:3.0, options: [], animations:{
            signInButton.alpha = 1.0

        }, completion: nil)
        
//        let viewFrame = view.frame
        print("description")
        print(lottieViewHolder.widthAnchor.description)
        
        
//        UIView.animate(withDuration: 2.4) {
//            signInButton.alpha = 1.0
//        }
//        UIView.animate(withDuration: 1.4) {
//            self.backgroundImage.alpha = 0.2
//            self.fadeOutView.alpha = 0.8
//            self.iconImage.alpha = 1.0
//            self.userNameField.alpha = 1.0
//            self.passwordField.alpha = 1.0
//            self.loginButton.alpha = 1.0
//        }
        
        
    }
    
    /*
    @objc func action()
    {
        
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        animationView.frame = CGRect(x: 0, y: 0, width: lottieViewHolder.frame.height, height: lottieViewHolder.frame.width)
        lottieViewHolder.addSubview(animationView)
//        animationView.center = lottieViewHolder.center
        //        animationView.center = lottieViewHolder.center
        
        //        animationView.frame = CGRect(x: viewFrame.midX - width/2, y: loginTitleLabel.frame.maxY - width + 88, width: width, height: width)
        //        animationView.bottomAnchor.constraint(equalTo: loginTitleLabel.topAnchor, constant: 10).isActive = true
        //        animationView.widthAnchor.constraint(equalToConstant: width).isActive = true
        //        animationView.heightAnchor.constraint(equalToConstant: width).isActive = true
        //        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
//        animationView.loopAnimation = true
        print("width")
        print(animationView.frame.width)
        print("height")
        print(animationView.frame.height)
        
        
        //        animationView.center = view.center
        animationView.play()
    }
    
    @IBAction func Submit(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signOut()
        
        self.loginButton.setTitle("Logging in...", for: UIControlState.normal)
        self.loginButton.titleLabel?.text = "Logging in..."
        let login = UserLoginVerify()
        login.delegate = self
        login.verifyLogin(schoolID: userNameField.text!, password: passwordField.text!)
        
        
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
