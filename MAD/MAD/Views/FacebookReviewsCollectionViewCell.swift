//
//  FacebookReviewsCollectionViewCell.swift
//  MAD
//
//  Created by David McAllister on 1/26/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import Lottie

class FacebookReviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var boundingView: UIView!
    var reviewModel: FacebookReviewModel = FacebookReviewModel()
    var animationView: LOTAnimationView = LOTAnimationView(name: "scan");
    var highResImageCounter: Int = 0
    var placeHolderCounter: Int = 0
    var timer = Timer()
    var nameTimer = Timer()
    var userID: String = ""

    var searching: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.layer.cornerRadius=15
        coverImageView.layer.masksToBounds=true
        boundingView.layer.cornerRadius=25
        boundingView.layer.masksToBounds=true
        //coverImageView.backgroundColor = UIColor.blue
        //let animationView: LOTAnimationView = LOTAnimationView(name: "scan");
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 17, y: 55, width: 135, height: 135)
        coverImageView.tintColor = UIColor.red
        titleLabel.text = ""
        
        self.boundingView.addSubview(animationView)
        //self.boundingView.sendSubview(toBack: animationView)
        self.boundingView.bringSubview(toFront: coverImageView)
        //self.coverImageView.sendSubview(toBack: animationView)
        
        animationView.loopAnimation = true
        //animationView.play()
        animationView.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(FacebookReviewsCollectionViewCell.action2), userInfo: nil,  repeats: true)
        //nameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(FacebookReviewsCollectionViewCell.action2), userInfo: nil,  repeats: true)
        
        
        
    }
    
    @objc func action2()
    {

        if(self.reviewModel.isPlaceHolder == false)
        {
            //print("my dog")
            if(self.reviewModel.bookModel.BookCoverImage.image != nil && self.reviewModel.bookModel.BookCoverImage.image?.isEqual(#imageLiteral(resourceName: "loadingImage")) == false && self.reviewModel.userImage.isEqual(#imageLiteral(resourceName: "loadingBacksplash")) == false && self.reviewModel.userName.count > 2)
            {
                self.placeHolderCounter = 0
                self.highResImageCounter =  self.highResImageCounter + 1
                //print("Loaded")
                self.titleLabel.text = self.reviewModel.userName
                self.coverImageView.image = self.reviewModel.bookModel.BookCoverImage.image
                self.profilePicture.image = self.reviewModel.userImage
                self.boundingView.bringSubview(toFront: self.profilePicture) //self.profilePicture
                
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
                self.profilePicture.clipsToBounds = true
                //UIColor.
                //174, 255, 0
                let customGreen = UIColor(red: 230.0/255.0, green: 131.0/255, blue: 180.0/255.0, alpha: 1)
                self.profilePicture.layer.borderColor = customGreen.cgColor
                self.profilePicture.layer.borderWidth = 3.0
                
            }
            
        }
        else
        {
            self.placeHolderCounter = self.placeHolderCounter + 1
            if(self.placeHolderCounter > 30)
            {
            self.titleLabel.text = "Not found"
            }
        }
        if(self.highResImageCounter > 30)
        {
            self.timer.invalidate()
        }

        /*
        var titleAsNum = Int(userID)
        if(titleAsNum != nil && (titleLabel.text?.count)! < 2)
        {
            
            self.titleLabel.textColor = UIColor.clear

            if let token = FBSDKAccessToken.current()
            {
                //print("Token")
                //print(token)
                print(token.tokenString)
                
                let params = ["fields": "name"]
                FBSDKGraphRequest(graphPath: userID, parameters: params).start { (connection, result, error) -> Void in
                    //print(result)
                    
                    if let result = result as? [String:Any]
                    {
                        if let dataDict = result["name"] as? String
                        {
                            print("Name: " + dataDict)
                            self.titleLabel.text = dataDict
                            self.titleLabel.textColor = UIColor.black

                        }
                    }
                    
                    
                }
            }

        }
        else
        {
        }
        */
    }
    
    /*
    @objc func action3()
    {
        
        //print(titleLabel.text)
        if(self.coverImageView.image != nil  && animationView.isHidden == false)
        {
            animationView.pause()
            animationView.isHidden = true
            self.timer.invalidate()
            
            //print(titleLabel.text)
        }
        if(self.searching == false && userID != nil && userID != "" && userID != "Title")
        {
            //print("Title: " + userID)
            searching = true
            if let url = URL(string: "https://graph.facebook.com/" + userID + "/picture?type=large") {
            
            self.downloadCoverImage(url: url)
                
                
                
            
        }
        }
        
        
    }
     */
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL) {
        //print("Download Started")
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    self.coverImageView.image = temp
                    self.profilePicture.image = temp
                    self.boundingView.bringSubview(toFront: self.profilePicture) //self.profilePicture
                    self.coverImageView.image = #imageLiteral(resourceName: "abstractArtSampleCover")
                    //self.profilePicture.layer.cornerRadius = 40
                    //self.profilePicture.layer.bound
                    //self.profilePicture.layer.masksToBounds = true
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
                    self.profilePicture.clipsToBounds = true
                    //UIColor.
                    //174, 255, 0
                    let customGreen = UIColor(red: 230.0/255.0, green: 131.0/255, blue: 180.0/255.0, alpha: 1)
                    self.profilePicture.layer.borderColor = customGreen.cgColor
                    self.profilePicture.layer.borderWidth = 3.0
                    //boundingView.layer.cornerRadius=25
                    //boundingView.layer.masksToBounds=true
                    found = true;
                }
                else
                {
                    
                }
                //print(String(describing: temp?.size.height))
                
            }
        }
        if(found == false)
        {
            //self.coverImageView.image = #imageLiteral(resourceName: "loadingBacksplash")
        }
    }
    
}
