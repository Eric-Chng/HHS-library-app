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

class DiscoverViewController: UIViewController{
    
    var url: String = "https://www.googleapis.com/books/v1/volumes?q=isbn+"
    var popularBookArr: [BookModel] = []
    var pressedItem: Int = 0
    var timer = Timer()

    @IBOutlet weak var popularTitleCollectionView: UICollectionView!
    @IBOutlet weak var librarianRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var barItem: UITabBarItem!
    @IBAction func searchButton(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "searchController") as! SearchTableViewController
        self.navigationController?.pushViewController(scanners, animated: true)
    }
    
   
    override func viewDidLoad() {
        popularBookArr = [BookModel(ISBN: "9781594634239"), BookModel(ISBN:"9780393061703"), BookModel(ISBN: "9781594489785"), /*d*/ BookModel(ISBN:"9781101971062"), BookModel(ISBN:"9780307887443"), BookModel(ISBN:"9781439181713")]
        
        let animationView: LOTAnimationView = LOTAnimationView(name: "bookUpdated");
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 50, y: 700, width: 300, height: 200)
        

        self.insideScrollView.addSubview(animationView)
        animationView.loopAnimation = true
        //animationView.play()
        animationView.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        
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
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        print("hello")
        self.performSegue(withIdentifier: "discoverToSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToBookDetail" {
            let destinationVC = segue.destination as! BookDetailViewController
            destinationVC.fromSB = .fromDiscoverViewController
        }
        if(segue.identifier == "collectionViewDetail")
        {
            
            let bookToPass = popularBookArr[self.pressedItem]
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
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
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
        //code for click
        print(indexPath.item)
        if(collectionView.restorationIdentifier! == "librarianRecommended")
        {
        self.pressedItem = indexPath.item
        }
        else if(collectionView.restorationIdentifier! == "popularTitles")
        {
            self.pressedItem = 5 - indexPath.item

        }
        self.performSegue(withIdentifier: "collectionViewDetail", sender: self)

        //print("clicked")
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        //largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
        return false
    }
 */
    
    
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularBookArr.count
        //collectionView(collectionView(<#T##collectionView: UICollectionView##UICollectionView#>, didSelectItemAtIndexPath: <#T##NSIndexPath#>))
        //collectionView.collection
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookThumbNailCell", for: indexPath) as! BookCoverCollectionViewCell
        let row = indexPath.row
        if(collectionView.restorationIdentifier! == "librarianRecommended")
        {
            //insert data for librarian recommended section
            if(popularBookArr[row].BookCoverImage != nil)
            {
        cell.coverImageView.image = popularBookArr[row].BookCoverImage.image
            }
        cell.titleLabel.text = popularBookArr[row].title
        }
        else if(collectionView.restorationIdentifier! == "popularTitles")
        {
            //insert data for popular titles section
            if(popularBookArr[5-row].BookCoverImage != nil)
            {
            cell.coverImageView.image = popularBookArr[5-row].BookCoverImage.image
            }
            cell.titleLabel.text = popularBookArr[5-row].title
        }
        return cell
    }
}
