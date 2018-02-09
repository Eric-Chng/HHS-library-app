//
//  MyBooksViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/29/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit

class MyBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DownloadProtocol, FBSDKLoginButtonDelegate{
    var feedItems: NSArray = NSArray()
    
    
    
    @IBOutlet weak var loginButtonView: UIView!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    //@IBOutlet weak var listTableView: UITableView!
    var temp:String = ""
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "user_friends", "email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.frame = CGRect(x: 0, y: 0, width: loginButtonView.frame.width, height: loginButtonView.frame.height)
        
        loginButtonView.addSubview(loginButton)
        loginButton.delegate = self
        if (FBSDKAccessToken.current()) != nil
        {
            self.fetchProfile()
        }
        self.profilePictureView.layer.cornerRadius = profilePictureView.layer.frame.width/2
        self.profilePictureView.layer.masksToBounds = true
        
        let UserSearch = UserGetBooks()
            UserSearch.delegate = self
        UserSearch.downloadItems(inputID: UserDefaults.standard.object(forKey: "id") as! String)
        
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        print(items.firstObject)
        //self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get references to labels of cell
        
        myCell.textLabel!.text = "The Theory of Nothing"
        //self.listTableView.reloadData()

        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
        //selectedLocation = feedItems[indexPath.row] as! LocationModel
        // Manually call segue to detail view controller
        //BookDetailViewController.updateISBN(newISBN: "9781921019630");
        
        //let scanners = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        
        
        //self.navigationController?.push
        //self.navigationController?.pushViewController(scanners, animated: true)
        self.performSegue(withIdentifier: "bookInfoSegue", sender: self)
        //let scanners = self.storyboard?.instantiateViewController(withIdentifier: "bookInfoSegue") as! BookDetailViewController
        
        //scanners.delegate = self
        
        //self.navigationController?.push
        //self.navigationController?.pushViewController(scanners, animated: true)
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
                    //print("Email: " + email)
                    //print(pictureDict)
                    
                    if let dataDict = pictureDict["data"] as? [String:Any]
                    {
                        //print("data dictionary success")
                        if let profilePictureUrl = dataDict["url"] as? String
                        {
                            print("URL: " + profilePictureUrl)
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
        print("Completed login")
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
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
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
