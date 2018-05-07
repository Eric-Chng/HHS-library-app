//
//  MyBooksViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/29/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit

class MyBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DownloadProtocol, FBSDKLoginButtonDelegate{
    
    
    var checkouts: NSArray = NSArray()
    var checkoutBooks: [BookModel] = []
    var onholds: NSArray = []
    var onholdBooks: [BookModel] = []
    var checkedTimer: Timer = Timer()
    var heldTimer: Timer = Timer()
    
    @IBOutlet weak var nameLabe: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBOutlet weak var onHoldTableView: UITableView!
    @IBOutlet weak var checkOutTableView: UITableView!
    @IBOutlet weak var loginButtonView: UIView!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    //@IBOutlet weak var listTableView: UITableView!
    var temp:String = ""
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "user_friends", "email"]
        return button
    }()
    @IBAction func xButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkedOutAction()
    {
        var counter: Int = 0
        var blankModel: Bool = false
        for book in self.checkoutBooks
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
            
            self.checkedTimer.invalidate()
            self.checkOutTableView.reloadData()
        }
    }
    
    @objc func heldAction()
    {
        var counter: Int = 0
        var blankModel: Bool = false
        for book in self.onholdBooks
        {
            counter = counter + 1
            if(book.title == nil || book.title == "")
            {
                blankModel = true
            }
        }
        if(counter > 0 && blankModel == false)
        {
            print("All books loaded")
            self.heldTimer.invalidate()
            self.onHoldTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkoutBooks = []
        self.checkouts = NSArray()
        self.onholdBooks = []
        self.onholds = NSArray()
        self.checkOutTableView.reloadData()
        self.onHoldTableView.reloadData()
        let UserSearch = UserGetBooks()
        UserSearch.delegate = self
        UserSearch.downloadItems(inputID: UserDefaults.standard.object(forKey: "userId") as! String)
        
        /*
        onHoldTableView.delegate = self
        onHoldTableView.dataSource = self
        
        checkOutTableView.delegate = self
        checkOutTableView.dataSource = self
        */
        let onHoldUserSearch = HoldbyUser()
        
        onHoldUserSearch.delegate = self
        onHoldUserSearch.downloadItems(inputID: Int(UserDefaults.standard.object(forKey: "userId") as! String)!/* as! CLong*/)
    }
    @IBOutlet weak var delinquencyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabe.text = UserDefaults.standard.object(forKey: "userName") as? String
        self.idLabel.text = "ID: " + (UserDefaults.standard.object(forKey: "id") as! String)
        delinquencyView.layer.cornerRadius = 6
        delinquencyView.layer.masksToBounds = true
        //let UserSearch = UserGetBooks()
        //UserSearch.delegate = self
        //UserSearch.downloadItems(inputID: UserDefaults.standard.object(forKey: "userId") as! String)
        onHoldTableView.delegate = self
        onHoldTableView.dataSource = self
        
        checkOutTableView.delegate = self
        checkOutTableView.dataSource = self
        //let onHoldUserSearch = HoldbyUser()
        
        //onHoldUserSearch.delegate = self
        //onHoldUserSearch.downloadItems(inputID: Int(UserDefaults.standard.object(forKey: "userId") as! String)!/* as! CLong*/)
        
        loginButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-40, height: loginButtonView.frame.height)
        
        loginButtonView.addSubview(loginButton)
        loginButton.delegate = self
        if (FBSDKAccessToken.current()) != nil
        {
            self.fetchProfile()
        }
        self.profilePictureView.layer.cornerRadius = profilePictureView.layer.frame.width/2
        self.profilePictureView.layer.masksToBounds = true
        reportBugButton.layer.cornerRadius = 4
        reportBugButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 4
        logoutButton.layer.masksToBounds = true
        helpButton.layer.cornerRadius = 4
        helpButton.layer.masksToBounds = true
    }
    
    @IBOutlet weak var reportBugButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @available(iOS, deprecated: 9.0)
    func itemsDownloaded(items: NSArray, from: String) {
        if(from.elementsEqual("UserGetBooks")){
        for i in items
        {
            let book = i as! CheckoutModel
            checkouts.adding(book);
            let model = BookModel(ISBN: book.ISBN!)
            checkoutBooks.append(model)

        }
          self.checkedTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(MyBooksViewController.checkedOutAction), userInfo: nil,  repeats: true)
        }
        else if(from == "HoldByUser"){

            for i in items{
                let book = i as! HoldModel
                onholds.adding(book)
                let model = BookModel(ISBN: book.ISBN!)
                onholdBooks.append(model)
            }
            self.heldTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(MyBooksViewController.heldAction), userInfo: nil,  repeats: true)
        }
        self.checkOutTableView.reloadData()
    }
    @IBAction func logoutPressed(_ sender: Any) {
        
        UserDefaults.standard.set("",forKey: "id")
        UserDefaults.standard.set("",forKey: "credential")
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        
    }
    
    @IBAction func helpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "helpSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.onHoldTableView {
            count = self.onholdBooks.count
            
        }
        
        if tableView == self.checkOutTableView {
            //print(count ?? 0)
            count =  self.checkoutBooks.count
        }
        return count!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.checkOutTableView {
            
            //let checkoutBook = checkouts[indexPath.row] as! CheckoutModel
            let book = checkoutBooks[indexPath.row]
           //let  cell = tableView.dequeueReusableCell(withIdentifier: "bookcheckoutcell") as! MyBooksCheckOutTableViewCell
            let cell = UITableViewCell()

            //cell.bookImg = book.BookCoverImage
            cell.textLabel?.text = book.title
            cell.textLabel?.textColor = UIColor.darkGray;
            //cell.textLabel?.font.pointSize = 12


            //cell.dueDate.text = checkoutBook.endTimestamp;
            //print("Book name: " + book.name!)
            return cell
        }
        else{
            let cell = UITableViewCell()
            _ = onholdBooks[indexPath.row]
            
            cell.textLabel?.text = onholdBooks[indexPath.row].title
           cell.detailTextLabel?.text = "test"
            //let font = UIFont(
            cell.textLabel?.textColor = UIColor.darkGray;
            //cell.textLabel?.font.pointSize = 12
            return cell;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func fetchProfile()
    {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) -> Void in
            
            
            if error != nil
            {
                print(error as Any)
                return
            }
            
            if let result = result as? [String:Any]
            {
                /*
                if let email = result["email"] as? String
                {
                    print("Email: " + email)
                }
                */
                if let pictureDict = result["picture"] as? [String:Any]
                {
                    
                    if let dataDict = pictureDict["data"] as? [String:Any]
                    {
                        if let profilePictureUrl = dataDict["url"] as? String
                        {
                            if let url = URL(string: profilePictureUrl) {
                                
                                self.downloadImage(url: url)
                            }
                            
                        }
                    }
                    
                }
            }
            
            
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error!)
    {
        self.fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.profilePictureView.image = nil
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true;
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        //print("Download Started")
        
        //var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    self.profilePictureView.image = temp
                    //found = true;
                }
                else
                {
                    /*
                    if(self.foundGoogleImage == false)
                    {
                        print("Image not found")
                        self.BookCoverImage.image = #imageLiteral(resourceName: "loadingImage")
                    }
                    */
                }
                //print(String(describing: temp?.size.height))
                
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "scannerDetailViewSegue"
        {
            let destinationVC = segue.destination as! BookDetailViewController
            destinationVC.fromSB = .fromMyBooksViewController
                //ISBN13 Value (string) ||
                //                      \/
                //destinationVC.updateISBN(newISBN: "9780545010221");
        }
        else if segue.identifier == "bookInfoSegue"{
            let bookViewController = segue.destination as! BookDetailViewController
            bookViewController.fromSB = .fromMyBooksViewController
        }
        
        // Get reference to the destination view controller
        //let detailVC  = segue.destination as! DetailViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        //detailVC.selectedLocation = selectedLocation
    }
}
