//
//  DiscoverViewController.swift
//  MAD
//
//  Created by Lily Li on 12/26/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewController: UIViewController{
    
    var url: String = "https://www.googleapis.com/books/v1/volumes?q=isbn+"
    var popularBookArr: [String] = []
    
    @IBAction func searchButton(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "searchController") as! SearchTableViewController
        self.navigationController?.pushViewController(scanners, animated: true)
    }
    
    override func viewDidLoad() {
        popularBookArr = [url + "9780375893773", url+"9780062077011", url+"9781416955078", url+"9781781109601", url+"9781781100486", url+"9781480483576"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularBookArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookThumbNailCell", for: indexPath) as! BookCoverCollectionViewCell
        cell.downloadCoverImage(url: NSURL(string: popularBookArr[0])! as URL)
        
        return cell
    }
}
