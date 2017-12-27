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

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL){
        var foundGoogleImage: Bool = false;
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
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
                        print("Image not found")
                        self.coverImageView.image = #imageLiteral(resourceName: "loadingImage")
                    }
                }
                print(String(describing: temp?.size.height))
                
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
