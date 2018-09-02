//
//  DiscoverViewController.swift
//  MAD
//
//  Created by Lily Li on 12/26/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class DiscoverViewController: UIViewController, UINavigationControllerDelegate
{
    
    
    
    var url: String = "https://www.googleapis.com/books/v1/volumes?q=isbn+"
    var popularBookArr: [BookModel] = []
    var librarianBookArr: [BookModel] = []
    var reviewBookArr: [BookModel] = []

    var reviewArr: [FacebookReviewModel] = []
    var pressedItem: BookModel = BookModel()
    var timer = Timer()
    var scrollTimer = Timer()
    var reloading: Bool = false
    @IBOutlet weak var reloadLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var facebookReviewsCollectionView: UICollectionView!
    @IBOutlet weak var popularTitleCollectionView: UICollectionView!
    @IBOutlet weak var librarianRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var barItem: UITabBarItem!
    @IBAction func searchButton(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "searchController") as! SearchTableViewController
        self.navigationController?.pushViewController(scanners, animated: true)
    }
    
    @available(iOS, deprecated: 9.0)
    override func viewDidLoad() {
        
        
        let animationView: LOTAnimationView = LOTAnimationView(name: "bookUpdated");
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 50, y: 700, width: 300, height: 200)
        self.setArrays()
        
        //self.insideScrollView.addSubview(animationView)
        animationView.loopAnimation = true
        //animationView.play()
        animationView.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(DiscoverViewController.action), userInfo: nil,  repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DiscoverViewController.action2), userInfo: nil,  repeats: true)
        //nameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(FacebookReviewsCollectionViewCell.action2), userInfo: nil,  repeats: true)
        
        
        
    }
    
    @available(iOS, deprecated: 9.0)
    @IBAction func reloadCollection(_ sender: Any) {
        print("Reloading collection")
        self.timer.invalidate()
        self.reviewArr = []
        self.librarianBookArr = []
        self.popularBookArr = []
        self.setArrays()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(DiscoverViewController.action), userInfo: nil,  repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DiscoverViewController.action2), userInfo: nil,  repeats: true)
    }
    
    /*
    func reloadCollections()
    {
        
    }
    */
    
    @available(iOS, deprecated: 9.0)
    override func viewDidAppear(_ animated: Bool) {
        self.reloadLabel.alpha = 0
        if(self.reviewArr.count < 1)
        {
            self.timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DiscoverViewController.action2), userInfo: nil,  repeats: true)
            
        }
        self.scrollTimer.invalidate()
        scrollTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DiscoverViewController.action3), userInfo: nil,  repeats: true)
        RunLoop.main.add(scrollTimer, forMode: RunLoopMode.commonModes)


    }
    
    @available(iOS, deprecated: 9.0)
    @objc func action3()
    {
        
        if(self.reloading == false && self.scrollView.contentOffset.y < -65)
        {
            self.reloading = true
            self.reloadLabel.text = "Reloading..."
            self.reloadCollection(self)
        }
        else if(self.reloading == false && self.scrollView.contentOffset.y < 0)
        {
            self.reloadLabel.alpha = 0.013*(self.scrollView.contentOffset.y*(-1)-10)
        }
        else if(self.scrollView.contentOffset.y > -5)
        {
            self.reloading = false
            self.reloadLabel.alpha = 0
            self.reloadLabel.text = "Pull to Reload..."
        }
    }

    
    @objc func action2()
    {
        if (FBSDKAccessToken.current()) != nil
        {
        let params = ["fields": "friends"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start { (connection, result, error) -> Void in
            //var ids: [String] = []
            if let result = result as? [String:Any]
            {
                
                if let dataDict = result["data"] as? NSArray
                {
                    

                    var tempCounter: Int = 0

                    for inner in dataDict
                    {
                        let insideDataDict = inner as! [String: Any]
                        
                        //var insideDataDict2 = ["id": "14", "id": "15"]
                        if let id = insideDataDict["id"] as? String
                        {
                            //@Eric Cheng, make FacebookReviewModels as shown below from userIDs and books\/
                            
                            
                            if(tempCounter<6)
                            {
                                
                            self.reviewArr.append(FacebookReviewModel(bookModel: self.reviewBookArr[tempCounter], userID: id, score: 4.5))
                            }
                            tempCounter = tempCounter + 1
                            //id is friend's id
                        }
                    }
                    
                    self.facebookReviewsCollectionView.reloadData()
                    self.timer.invalidate()
                }
            
            }
            if error != nil
            {
                print(error as Any)
                return
            }
            
            }
        }
 
        
    }
    
    @objc func action()
    {
        var collectionViewLoaded: Bool = true
        for model in self.popularBookArr
        {
            if(model.title == nil || model.title == "")
            {
                collectionViewLoaded = false
            }
        }
        if(collectionViewLoaded)
        {
            popularTitleCollectionView.reloadData()
            librarianRecommendedCollectionView.reloadData()
            for model in self.popularBookArr
            {
                if(model.BookCoverImage != nil && model.BookCoverImage != nil)
                {
                    timer.invalidate()
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue)
    {
        
        
        
    }
    
    @available(iOS, deprecated: 9.0)
    func setArrays()
    {
        popularBookArr = [BookModel(ISBN: "9780141182773"), BookModel(ISBN:"9783608938180"), BookModel(ISBN: "9780810891951"), BookModel(ISBN:"9781594480003"), BookModel(ISBN:"9781555975098"), BookModel(ISBN:"9780199738410")]
        librarianBookArr = [BookModel(ISBN: "9781845114657"), BookModel(ISBN: "9780545402163"), BookModel(ISBN:"9781883831073"), BookModel(ISBN:"9780812504675"), BookModel(ISBN:"9780553151671"), BookModel(ISBN:"9780553588255")]
        reviewBookArr = [BookModel(ISBN:"9780439358071"), BookModel(ISBN:"9780590353427"), BookModel(ISBN: "9781594634239"), BookModel(ISBN: "9781594489785"), BookModel(ISBN:"9781101971062"), BookModel(ISBN:"9780439358071"), BookModel(ISBN:"9781439181713")]

    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        //self.performSegue(withIdentifier: "discoverToSearch", sender: self)
        self.performSegue(withIdentifier: "testSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToBookDetail" {
            let destinationVC = segue.destination as! BookDetailViewController
            destinationVC.fromSB = .fromDiscoverViewController
        }
        if(segue.identifier == "collectionViewDetail")
        {
            
            let bookToPass = self.pressedItem
            if let destinationViewController = segue.destination as? BookDetailViewController {
                destinationViewController.selectedBook = bookToPass
            }
        }
        if(segue.identifier == "discoverToSearch")
        {
            if let destinationVC = segue.destination as? UINavigationController
            {
                if let x = destinationVC.viewControllers.first as? SearchTableViewController
                {
                    x.discoverViewController.append(self)
                }
            }
        }
    }
    
    
    
    
    
    
}
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 10
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        _ = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: 170, height: 250)
        
        return itemSize
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //code for collection view pressed
        var stopSegue: Bool = false
        if(collectionView.restorationIdentifier! == "librarianRecommended")
        {
            if(self.librarianBookArr.count > indexPath.item)
            {
            self.pressedItem = librarianBookArr[indexPath.item]
            }
        }
        else if(collectionView.restorationIdentifier! == "popularTitles")
        {
            if(self.popularBookArr.count > indexPath.item)
            {
            self.pressedItem = popularBookArr[indexPath.item]
            }
            
        }
        else if(collectionView.restorationIdentifier! == "facebookFeed")
        {
            stopSegue = true
            //self.p
            //self.pressedItem =
            if(self.reviewArr.count > indexPath.item && reviewArr[indexPath.item].bookModel.ISBN != nil)
            {
                stopSegue = false
            self.pressedItem = reviewArr[indexPath.item].bookModel
            }
            
        }
        if(stopSegue == false)
        {
        self.performSegue(withIdentifier: "collectionViewDetail", sender: self)
        }
        
    }
    
    
    
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularBookArr.count
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        _ = UICollectionViewCell()
        if(collectionView.restorationIdentifier! == "facebookFeed")
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacebookReviewsCollectionViewCell", for: indexPath) as! FacebookReviewsCollectionViewCell
            
            if(self.reviewArr.count > indexPath.row)
            {
                cell.reviewModel = self.reviewArr[indexPath.row]
            }
            return cell
        }
        else
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookThumbNailCell", for: indexPath) as! BookCoverCollectionViewCell
        let row = indexPath.row
        if(collectionView.restorationIdentifier! == "librarianRecommended")
        {
            //insert data for librarian recommended section
            if(librarianBookArr[row].BookCoverImage != nil)
            {
                cell.coverImageView.image = librarianBookArr[row].BookCoverImage.image
            }
            cell.titleLabel.text = librarianBookArr[row].title
        }
        else if(collectionView.restorationIdentifier! == "popularTitles")
        {
            //insert data for popular titles section
            if(popularBookArr[row].BookCoverImage != nil)
            {
                cell.coverImageView.image = popularBookArr[row].BookCoverImage.image
            }
            cell.titleLabel.text = popularBookArr[row].title
        }
            return cell
        }
        //return cell
    }
}
