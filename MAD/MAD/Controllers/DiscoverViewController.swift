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
    
    @IBOutlet weak var insideScrollView: UIView!
    @IBOutlet weak var barItem: UITabBarItem!
    @IBAction func searchButton(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "searchController") as! SearchTableViewController
        self.navigationController?.pushViewController(scanners, animated: true)
    }
    
   
    override func viewDidLoad() {
        popularBookArr = [BookModel(ISBN: "9780375893773"), BookModel(ISBN:"9780062077011"), BookModel(ISBN: "9781416955078"), BookModel(ISBN:"9781781109601"), BookModel(ISBN:"9781781100486"), BookModel(ISBN:"9781480483576")]
        
        let animationView: LOTAnimationView = LOTAnimationView(name: "bookUpdated");
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x: 50, y: 700, width: 300, height: 200)
        

        self.insideScrollView.addSubview(animationView)
        animationView.loopAnimation = true
        //animationView.play()
        animationView.play(fromProgress: 0, toProgress: 1.0, withCompletion: nil)
        
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

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularBookArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookThumbNailCell", for: indexPath) as! BookCoverCollectionViewCell
        let row = indexPath.row
        cell.coverImageView = popularBookArr[row].BookCoverImage
        cell.titleLabel.text = popularBookArr[row].title
        return cell
    }
}
