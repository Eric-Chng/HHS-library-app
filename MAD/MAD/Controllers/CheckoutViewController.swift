//
//  CheckoutViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit


class CheckoutViewController: UIViewController, MyProtocol, FBSDKLoginButtonDelegate{
    
    var lastSendTime:Int = Int(ProcessInfo.processInfo.systemUptime)
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "user_friends", "email"]
        return button
    }()
    @IBOutlet weak var loginButtonView: UIView!
    
    func sendScannedValue(valueSent: String) {
        if(lastSendTime != Int(ProcessInfo.processInfo.systemUptime))
        {
            lastSendTime = Int(ProcessInfo.processInfo.systemUptime);
        self.scannerValue = valueSent
        scannerLabel.text = valueSent
        BookDetailViewController.updateISBN(newISBN: valueSent)
        print("sending value")
        
        }
    }

    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scannerDetailViewSegue"
        {
            if let destinationVC = segue.destination as? BookDetailViewController {
                destinationVC.ISBN = scannerValue!
            }
        }
    }*/
    
    @IBOutlet weak var scannerLabel: UILabel!
    
    
    var scannerValue:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.frame = CGRect(x: 0, y: 0, width: loginButtonView.frame.width, height: loginButtonView.frame.height)
        loginButtonView.addSubview(loginButton)
        loginButton.delegate = self
        //loginButton.center = view.center
        if let token = FBSDKAccessToken.current()
        {
            fetchProfile()
            print("Token")
            //print(token)
            print(token.tokenString)
        }
        if scannerValue != nil
        {
            print("Value from display = \(scannerValue!)")
        }
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchProfile()
    {
        print("fetch profile")
        /*
        let params = ["fields" : "email, name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult)  in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    print(responseDictionary["name"])
                    print(responseDictionary["email"])
                }
            }
        }
         */
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) -> Void in
            
            
            print("doing this")
            if error != nil
            {
                print(error as Any)
                return
            }
            
            if let result = result as? [String:Any]
            {
                if let email = result["email"] as? String
                {
                    print("Email: " + email)
                }
                if let pictureDict = result["picture"] as? [String:Any]
                {
                    //print("Success boyo")
                    //print("Email: " + email)
                    //print(pictureDict)
                    
                    if let dataDict = pictureDict["data"] as? [String:Any]
                    {
                        //print("data dictionary success")
                        if let profilePictureUrl = dataDict["url"] as? String
                        {
                            print("URL: " + profilePictureUrl)
                            
                        }
                    }
                    
                }
            }
            
            
        }
        
        let params = ["fields": "friends"] ///me/friends?fields=installed
        
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start { (connection, result, error) -> Void in
            
            if let result = result as? [String:Any]
            {
            print("result start")
            //print(result)
                for x in result{
                    print(x)
                    print("break")
                }
            print("result end")
                if let dataDict = result["data"] as? NSArray
                {
                    print("Data dictionary")
                    for x in dataDict{
                        print(x)
                        print("data break")
                    }
                    print("bigs")
                    print(dataDict[0])
                    
                     if let insideDataDict = dataDict[0] as? [String:Any]
                    {
                        print("inside")
                        print(insideDataDict)
                        print("done")
                        //var insideDataDict2 = ["id": "14", "id": "15"]
                        if let id = insideDataDict["id"] as? String
                        {
                            print("ID: " + id)
                            //id is friend's id
                        }
                    }
                    
                }
            }
            if error != nil
            {
                print(error as Any)
                return
            }
            
            
        }
        
        let parames = ["fields": "picture.type(large)"] ///me/friends?fields=installed
        //https://graph.facebook.com/110990426382408/picture?type=large

        //110990426382408
        
        
    }

    @IBAction func goNext(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "Scanner") as! Scanner
        
        scanners.delegate = self
        print("going next")
        //self.navigationController?.push
        self.navigationController?.pushViewController(scanners, animated: true)
        //self.performSegue(withIdentifier: "scannerDetailViewSegue", sender: self)

        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error!)
    {
        print("Completed login")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true;
    }
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannerDetailViewSegue" {
            let destinationVC = segue.destination as! BookDetailViewController
            destinationVC.fromSB = .fromCheckoutViewController
        }
    }


}

