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
import SwiftEntryKit

class LoginViewController: UIViewController, DownloadProtocol, GIDSignInUIDelegate, TransactionProtocol {
    
    
    
    func transactionProcessed(success: Bool)
    {
        if(success)
        {
            if self.accountCreated == false
            {
                print("Account creation success")
                self.accountCreated = true
                firstLogin = true
                print("Success")
                let login = UserLoginVerify()
                login.delegate = self
                let user = GIDSignIn.sharedInstance().currentUser
                let profile = user?.profile
                let firstName = profile?.givenName
                self.userNameField.text = firstName
                let email = profile?.email!
                login.verifyLogin(email: email!)
            }
            else
            {
                formView.removeFromSuperview()
                UserDefaults.standard.set("false", forKey: "FirstLogin")
                self.performSegue(withIdentifier: "LoginToIntro", sender: self)
            }
        }
        else
        {
            print("Something went wrong")
            let alert = UIAlertController(title: "Something Went Wrong! 😳", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got It", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    lazy var formView: EKFormMessageView = {
        let formDescription = EKProperty.LabelContent(text: "Confirm Your Student ID", style: .init(font: MainFont.bold.with(size: 22), color: UIColor.white))
        let placeholder = EKProperty.LabelContent(text: "Student ID", style: .init(font: MainFont.light.with(size: 20), color: UIColor.white))
        var buttonDescription = EKProperty.LabelContent(text: "Confirm", style: .init(font: MainFont.light.with(size: 18), color: .gray))
        let textFieldContent = EKProperty.TextFieldContent(keyboardType: UIKeyboardType.numberPad, placeholder: placeholder, textStyle: EKProperty.LabelStyle(font: MainFont.light.with(size: 20), color: .white), isSecure: false, leadingImage: #imageLiteral(resourceName: "id-card"), bottomBorderColor: .white)
        let buttonContent = EKProperty.ButtonContent(label: buttonDescription, backgroundColor: .white, highlightedBackgroundColor: .white, action: {
            print("Button pressed")
            let id = textFieldContent.textContent
            if id.count == 7
            {
                let setSchoolID = UserSetSchoolID()
                setSchoolID.delegate = self
                setSchoolID.setSchoolID(id: UserDefaults.standard.object(forKey: "userId") as! String, schoolid: id)
            }
            else if id.count > 0
            {
                buttonDescription.text = "Incorrect Length"
                self.invalidInput()
            }
            print(textFieldContent.textContent)
            
        })
        
        let temp = EKFormMessageView(with: formDescription, textFieldsContent: [textFieldContent], buttonContent: buttonContent)
        return temp
    }()
    
    func invalidInput()
    {
        var attributes = EKAttributes.centerFloat
        attributes.entryBackground = .gradient(gradient: .init(colors: [.greenGrass, UIColor.init(red: 0.8, green: 1.0, blue: 0.2, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(scale: .init(from: 1, to: 0, duration: 1)))
        attributes.shadow = .active(with: .init(color: .white, opacity: 0.5, radius: 10, offset: .zero))
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        //        attributes.
        attributes.statusBar = .light
        attributes.displayDuration = 9999999999
        //        attributes.
        //        SwiftEntryKit.display(entry: formView, using: attributes)
        formView.removeFromSuperview()
        let alert = UIAlertController(title: "Incorrect ID Length", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default) {
            UIAlertAction in
            SwiftEntryKit.display(entry: self.formView, using: attributes)
            
        })
        alert.addAction(UIAlertAction(title: "Skip", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Skipped")
            let setSchoolID = UserSetSchoolID()
            setSchoolID.delegate = self
            setSchoolID.setSchoolID(id: UserDefaults.standard.object(forKey: "userId") as! String, schoolid: "1234567")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var accountCreated = false
    @IBOutlet weak var incorrectCredentialsLabel: UILabel!
    let animationView: LOTAnimationView = LOTAnimationView(name: "loginBook")
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var lottieViewHolder: UIView!
    var firstLogin = false
    
    func itemsDownloaded(items: NSArray, from: String) {
        self.loginButton.setTitle("Login", for: UIControlState.normal)
        if (String(describing: items.firstObject) == "failed") {
            userNameField.text = ""
            passwordField.text = ""
            self.incorrectCredentialsLabel.alpha = 1.0
            self.incorrectCredentialsLabel.text = "Creating a new account..."
            let userCreate = UserCreate.init()
            let user = GIDSignIn.sharedInstance().currentUser
            let profile = user?.profile
            let firstName = profile?.givenName
            self.userNameField.text = firstName
            let email = profile?.email!
            userCreate.createUser(email: email!, name: (profile?.name)!)
            userCreate.delegate = self
            
        } else {
            let user = items.firstObject
            switch user {
            case is UserModel:
                //let userCasted = user as! UserModel
                UserDefaults.standard.set((user as! UserModel).ID,forKey: "id")
//                UserDefaults.standard.set(self.passwordField.text,forKey: "credential")
                UserDefaults.standard.set((user as! UserModel).name, forKey: "userName")

                if(firstLogin)
                {
                    var attributes = EKAttributes.centerFloat
                    attributes.entryBackground = .gradient(gradient: .init(colors: [.greenGrass, UIColor.init(red: 0.8, green: 1.0, blue: 0.2, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                    attributes.shadow = .active(with: .init(color: .white, opacity: 0.5, radius: 10, offset: .zero))
                    attributes.statusBar = .dark
                    attributes.displayDuration = 9999999999
                    attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
                    
                    SwiftEntryKit.display(entry: formView, using: attributes)
                    
                    //add it here
                    
                    
                }
                else
                {
                    self.performSegue(withIdentifier: "LoginToTabs", sender: self)
                    
                }
            default:
                userNameField.text = ""
                passwordField.text = ""
                self.incorrectCredentialsLabel.alpha = 1.0
                print("Creating new account")
                let userCreate = UserCreate.init()
                let user = GIDSignIn.sharedInstance().currentUser
                let profile = user?.profile
                let firstName = profile?.givenName
                self.userNameField.text = firstName
                let email = profile?.email!
                userCreate.createUser(email: email!, name: (profile?.name)!)
                userCreate.delegate = self

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
                login.verifyLogin(email: email!)
                timer.invalidate()
            }
            else if email != nil && (email?.count)! > 3
            {
                self.incorrectCredentialsLabel.alpha = 1.0
                GIDSignIn.sharedInstance().signOut()

            }
            else
            {
                print("No email")
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
//            login.verifyLogin(email: <#T##String#>)
//            login.verifyLogin(schoolID: idAsString)
            
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
//        login.verifyLogin(schoolID: userNameField.text!, password: passwordField.text!)
        
        
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
