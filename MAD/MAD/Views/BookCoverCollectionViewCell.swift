//
//  BookCoverCollectionViewCell.swift
//  MAD
//
//  Created by Lily Li on 12/26/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit

class BookCoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    var imageURL: String = ""
    var downloaded: Bool = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var boundingView: UIView!
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL){
       print("downloading")
        if(downloaded == false)
        {
            //print("downloading")
            downloaded = true
        var foundGoogleImage: Bool = false;
        coverImageView.layer.cornerRadius = 8
        coverImageView.layer.masksToBounds = true
        boundingView.layer.cornerRadius = 15
        boundingView.layer.masksToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = boundingView.bounds
        
        let topColor = UIColor(red: 0.7, green: 0.9, blue: 1, alpha: 0.25)
        let bottomColor = UIColor(red: 0.3, green: 0.7, blue: 1, alpha: 0.5)
            
            titleLabel.text = "The World of Abstract Art"
            titleLabel.layer.shadowColor = UIColor.black.cgColor
            titleLabel.layer.shadowRadius = 3.0
            titleLabel.layer.shadowOpacity = 0.3
            titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            titleLabel.layer.masksToBounds = false

        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        blurredView.layer.insertSublayer(gradientLayer, at: 0)
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    self.coverImageView.image = temp
                    found = true;
                }
                else
                {
                    if(foundGoogleImage == false)
                    {
                        //print("Image not found")
                        self.coverImageView.image = #imageLiteral(resourceName: "abstractArtSampleCover")
                    }
                }
                //print(String(describing: temp?.size.height))
                
            }
        }
        if(found == false)
        {
            if let googleURL = URL(string: imageURL) {
                self.getDataFromUrl(url: googleURL) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        let temp: UIImage? = UIImage(data: data)
                        if(temp != nil && Double((temp?.size.height)!)>20.0)
                        {
                            print("Doing it")
                            self.coverImageView.image = temp
                            foundGoogleImage = true
                        }
                        else
                        {
                            print("Image not found 2")
                        }
                        print(String(describing: temp?.size.height))
                    }
                }
            }
        }
    }
    }
}
