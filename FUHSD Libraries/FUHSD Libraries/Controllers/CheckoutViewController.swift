//
//  CheckoutViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit


class CheckoutViewController: UIViewController, MyProtocol, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource, DownloadProtocol, TransactionProtocol{
    
    var transactionCounter: Int = 0
    
    func transactionProcessed(success: Bool) {
        print("Checkout progress: ")
        print(success)
        if(success == true && transactionCounter == 1)
        {
            transactionCounter = 0
            self.holdBookModels = []
            self.holdIDs = []
            let userHolds = HoldbyUser()
            userHolds.delegate = self
            
            userHolds.downloadItems(inputID: 1)
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(CheckoutViewController.action), userInfo: nil,  repeats: true)
        }
        else
        {
            transactionCounter = transactionCounter + 1
        }
    }
    
    
    var holdBookModels: [BookModel] = []
    var holdIDs: [String] = []
    var selectedBook: BookModel = BookModel()
    var timer: Timer = Timer()
    
    @available(iOS, deprecated: 9.0)
    func itemsDownloaded(items: NSArray, from: String) {
        print("items found")
        for x in items
        {
            let temp = x as! HoldModel
            //{
            holdIDs.append(temp.ID!)
            let isbn = temp.ISBN
            self.holdBookModels.append(BookModel(ISBN: temp.ISBN!))
            print(isbn!)
            
            //}
        }
        
    }
    
    @objc func action()
    {
        //print("acting")
        var counter: Int = 0
        var blankModel: Bool = false
        for book in self.holdBookModels
        {
            counter = counter + 1
            if(book.title == nil || book.title == "")
            {
                blankModel = true
            }
        }
        if(counter > 0 && blankModel == false)
        {
            //print("All books loaded")
            self.timer.invalidate()
            self.holdTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.holdBookModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellIdentifier: String = "cell"
        let myCell = UITableViewCell()
        //let myCell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UITableViewCell)!
        //myCell.textLabel?.text = "tester"
        myCell.textLabel?.text = "out of bounds"

        if(indexPath.row < self.holdBookModels.count)
        {
        let currentTitle = self.holdBookModels[indexPath.row].title
        myCell.textLabel?.text = currentTitle
        }
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        if(indexPath.row < holdBookModels.count)
        {
        let selectedModel = self.holdBookModels[indexPath.row]
        //print(selectedModel.title!)
        let alert = UIAlertController(title: "Do you want to checkout " + selectedModel.title! + "?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in self.checkoutBook(isbn: selectedModel.ISBN!, holdID: self.holdIDs[indexPath.row])}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
            
        }
        //checkoutBook(isbn: selectedModel.ISBN!, holdID: self.holdIDs[indexPath.row])
    }
    
    func checkoutBook(isbn: String, holdID: String)
    {
        self.holdBookModels = []
        self.holdTableView.reloadData()
        let userCheckout = UserCheckout()
        userCheckout.delegate = self
        userCheckout.checkout(isbn: isbn, user: UserDefaults.standard.object(forKey: "userId") as! String)
        
        
        let holdDelete = HoldDelete()
        holdDelete.delegate = self
        holdDelete.deleteHold(id: holdID)
        self.holdBookModels = []
        
        
        //UserCheckout.download
        
        
    }
    
    
    
    @IBOutlet weak var holdTableView: UITableView!
    
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

    override func viewDidAppear(_ animated: Bool)
    {
        self.holdBookModels = []
        self.holdIDs = []
        //print("Checkout appeared")
        let userHolds = HoldbyUser()
        userHolds.delegate = self
        
        userHolds.downloadItems(inputID: 1)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(CheckoutViewController.action), userInfo: nil,  repeats: true)

        //userHolds.
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.holdTableView.layer.cornerRadius = 10
        self.holdTableView.layer.masksToBounds = true
        self.holdTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.holdTableView.delegate = self
        self.holdTableView.dataSource = self
        self.holdTableView.layer.borderWidth = 0.5
        loginButton.frame = CGRect(x: 0, y: 0, width: loginButtonView.frame.width, height: loginButtonView.frame.height)
        loginButtonView.addSubview(loginButton)
        loginButton.delegate = self
        //loginButton.center = view.center
        /*
        if let token = FBSDKAccessToken.current()
        {
            fetchProfile()
            //print("Token")
            //print(token)
            //print(token.tokenString)
        }
        */
        if scannerValue != nil
        {
            print("Value from display = \(scannerValue!)")
        }
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //private override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //}
    
    func fetchProfile()
    {
        //print("fetch profile")
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
        
        //let parames = ["fields": "picture.type(large)"] ///me/friends?fields=installed
        //https://graph.facebook.com/110990426382408/picture?type=large

        
        
    }

    @IBAction func goNext(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "Scanner") as! Scanner
        
        scanners.delegate = self
        //print("going next")
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

