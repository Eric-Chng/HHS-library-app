//
//  SearchTableViewController.swift
//  MAD
//
//  Created by David McAllister on 12/23/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var currentAuthors: [String] = [""]
    var currentTitles: [String] = [""]
    var currentCovers: [UIImage] = [UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage()]
    var currentISBNs: [String] = [""]
    var timer = Timer()
    var downloaded: Bool = false;
    var currentThumbnails: [String] = [""]
    
    var currentCoversDownloaded:[Bool] = [false, false, false, false, false, false, false, false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        
    }
    
    @objc func action()
    {
        //print("hi")
        self.tableView.reloadData()
        if(currentISBNs.count>3 && downloaded == false)
        {
            print("stored")
            for x in self.currentISBNs
            {
                print("x: " + x)
            }
            //print("now")
            downloaded = true
            var counter2:Int = 0;
            for ISBN in currentISBNs
            {
                if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + ISBN + "-L.jpg") {
                    //imageView.contentMode = .scaleAspectFit
                    //self.downloadCoverImage(url: url, index: counter2)
                }
                counter2 = counter2 + 1
            }
        }
    }
    
    
    
    //func searchBar(searchBar: UISearchBar, textDidChange: String) {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.reloadData()

        var keywords = searchBar.text!;
        searchBar.resignFirstResponder()
        //print("finding results for keyword: " + keywords)
        keywords = keywords.replacingOccurrences(of: " ", with: "+")
        let todoEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=intitle:" + keywords
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL for: " + todoEndpoint)
            return
        }
        
        
        
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling with Google Books GET call with Keywords: " + keywords)
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let googleBooksJSON = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    as? [String: Any]
                    else {
                        print("error trying to convert data to JSON")
                        return
                }
                //print("Google Books JSON: " + String(describing: googleBooksJSON))
                
                
                
                
                
                
                //Converts JSON into a String
                
                var JSONAsString = "describing =                       \"could not be found\" authors = \"not found\" title = not found"
                let itemsDictionary = /*googleBooksJSON["items"] as? NSArray?*/ String(describing: googleBooksJSON)
                if itemsDictionary != "[\"totalItems\": 0, \"kind\": books#volumes]"
                {
                    JSONAsString = itemsDictionary/*String(describing: itemsDictionary!![0])*/
                    print(JSONAsString)
                    print("End of JSON")
                    
                    var counter:Int = 0;
                    var finalTitle = "Not found"
                    //Parses out the title
                    while let rangeTotitle: Range<String.Index> = JSONAsString.range(of: " title = ")
                    {
                    let distanceTotitle = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeTotitle.lowerBound))
                    let titleIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle+9)
                    let titleAndOn = JSONAsString.substring(from: titleIndex)
                    let rangeToSemiColon: Range<String.Index> = titleAndOn.range(of: ";")!
                    let distanceToSemiColon = Int(titleAndOn.distance(from: titleAndOn.startIndex, to: rangeToSemiColon.lowerBound))
                    let finalIndex = titleAndOn.index(titleAndOn.startIndex, offsetBy: distanceToSemiColon)
                    finalTitle = titleAndOn.substring(to: finalIndex)
                    if finalTitle.range(of: "\"") != nil
                    {
                        let firstQuoteIndex = finalTitle.index(finalTitle.startIndex, offsetBy: 1)
                        finalTitle = finalTitle.substring(from: firstQuoteIndex)
                        let lastQuoteIndex = finalTitle.index(finalTitle.endIndex, offsetBy: -1)
                        finalTitle = finalTitle.substring(to: lastQuoteIndex)
                    }
                        if(counter == 0 && finalTitle.count>3)
                        {
                            self.currentAuthors = []
                            self.currentTitles = []
                            self.currentISBNs = []
                            self.currentThumbnails = []
                        }
                        var finalAuthor = "Not available"
                    //Parses out the author
                    if let rangeToAuthors: Range<String.Index> = JSONAsString.range(of: "authors = ")
                    {
                    let distanceToAuthors = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeToAuthors.lowerBound))
                    let authorsIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceToAuthors+33)
                    let authorsAndOn = JSONAsString.substring(from: authorsIndex)
                    //print("oh boy" + authorsAndOn)
                    let rangeToQuote: Range<String.Index> = authorsAndOn.range(of: "\"")!
                    let distanceToQuote = Int(authorsAndOn.distance(from: authorsAndOn.startIndex, to: rangeToQuote.lowerBound))
                    let quoteIndex = authorsAndOn.index(authorsAndOn.startIndex, offsetBy: distanceToQuote)
                    finalAuthor = authorsAndOn.substring(to: quoteIndex)
                    //print("The Author is \"" + finalAuthor + "\"")
                    print("Title: \"" + finalTitle + "\" by " + finalAuthor)
                        
                        let tempIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle + distanceToSemiColon)

                        var tempString = JSONAsString.substring(to: tempIndex)
                        var finalISBN = "Incomplete Google Books Listing"
                        //Parses out ISBN
                        if let rangeToISBN: Range<String.Index> = tempString.range(of: "type = \"ISBN_13\"")
                        {
                            let distanceToISBN = Int(tempString.distance(from: tempString.startIndex, to: rangeToISBN.lowerBound))
                            //print(distanceToISBN)
                            let ISBNIndex = tempString.index(tempString.startIndex, offsetBy: distanceToISBN-31)
                            let ISBNAndOn = tempString.substring(from: ISBNIndex)
                            let rangeToColon: Range<String.Index> = ISBNAndOn.range(of: ";")!
                            let distanceToColon = Int(ISBNAndOn.distance(from: ISBNAndOn.startIndex, to: rangeToColon.lowerBound))
                            let colonIndex = ISBNAndOn.index(ISBNAndOn.startIndex, offsetBy: distanceToColon)
                            finalISBN = ISBNAndOn.substring(to: colonIndex)
                            print("ISBN_13: " + finalISBN)

                            let tenStartIndex = finalISBN.index(finalISBN.startIndex, offsetBy: 3)
                            var temp: String = finalISBN.substring(from: tenStartIndex)
                            let tenEndIndex = temp.index(temp.endIndex, offsetBy: -1)
                            temp = temp.substring(to: tenEndIndex)
                            print("ISBN_10: " + temp)
                        }
                        
                        var finalThumbnail: String = ""
                        if let rangeToThumbnail: Range<String.Index> = tempString.range(of: " thumbnail = ")
                        {
                            let distanceToThumbnail = Int(tempString.distance(from: tempString.startIndex, to: rangeToThumbnail.lowerBound))
                            //print(distanceToISBN)
                            let thumbnailIndex = tempString.index(tempString.startIndex, offsetBy: distanceToThumbnail+14)
                            let thumbnailAndOn = tempString.substring(from: thumbnailIndex)
                            
                            let rangeToEndQuote: Range<String.Index> = thumbnailAndOn.range(of: ";")!
                            let distanceToEndQuote = Int(thumbnailAndOn.distance(from: thumbnailAndOn.startIndex, to: rangeToEndQuote.lowerBound))
                            let endQuoteIndex = thumbnailAndOn.index(thumbnailAndOn.startIndex, offsetBy: distanceToEndQuote-1)
                            finalThumbnail = thumbnailAndOn.substring(to: endQuoteIndex)
                            //finalISBN = ISBNAndOn.substring(to: colonIndex)
                            //print("ISBN_13: " + finalISBN)
                            print("Thumbnail URL: " + finalThumbnail)
                            
                            
                        }
                        
                        
                        self.currentTitles.append(finalTitle)
                        self.currentAuthors.append(finalAuthor)
                        self.currentISBNs.append(finalISBN)
                        self.currentThumbnails.append(finalThumbnail)
                        
                        JSONAsString = JSONAsString.substring(from: tempIndex)
                        //979x
                        //31
                        
                        counter = counter + 1;
                        }
                    else{
                        JSONAsString = "break"
                        }
                    }
                   
                }
                else
                {
                    //print("No results found")
                    self.currentTitles = []
                    self.currentAuthors = []
                    self.currentISBNs = []
                    self.currentThumbnails = ["No thumbnail"]
                    self.currentTitles.append("No results found")
                    self.currentAuthors.append("NA")
                    self.currentISBNs.append("bad")
                }
                
                //let distanceToTitle = Int(distanceTotitle.distance(from: distanceTotitle.startIndex, to: rangeTotitle.lowerBound))
                
                
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
       
        //if let url = URL(string: "http://covers.openlibrary.org/b/isbn/" + BookDetailViewController.ISBN + "-L.jpg") {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadCoverImage(url: URL, index: Int) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.currentCovers[index] = UIImage(data: data)!
                self.currentCoversDownloaded[index] = true
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return currentAuthors.count
        return currentTitles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //d
        print("ISBN: " + self.currentISBNs[indexPath.row])
        BookDetailViewController.updateISBN(newISBN: self.currentISBNs[indexPath.row]);
        //self.performSegue(withIdentifier: "SearchToBookDetail", sender: self)
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        scanners.googleBooksImageURL(newURL: self.currentThumbnails[indexPath.row])
        
        
        //self.navigationController?.push
        self.navigationController?.pushViewController(scanners, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("bonjour")
        // Retrieve cell
        let cellIdentifier: String = "cell"
        let myCell: SearchTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTableViewCell)!
        //myCell.style
        // Get references to labels of cell
        if(currentTitles.count<=indexPath.row)
        {
            self.currentTitles = []
            self.currentAuthors = []
            self.currentTitles.append("No results found")
            self.currentAuthors.append("NA")
        }
        else{
            //print("Titles: " + String(currentTitles.count))
            //print("Authors: " + String(currentAuthors.count))

            myCell.titleLabel.text = currentTitles[indexPath.row];
            myCell.authorLabel.text = currentAuthors[indexPath.row]
            var temp:Bool = true;
            /*
            if(self.currentCoversDownloaded[indexPath.row] == true)
            {
                print("Cover #" + String(indexPath.row) + " has been set")
            //myCell.bookCover.image = currentCovers[indexPath.row];
                self.currentCoversDownloaded[indexPath.row] = false
                myCell.imageView?.image = currentCovers[indexPath.row]
            }
            */
            //self.BookCoverImage.image = UIImage(data: data)

        //myCell.textLabel!.text = currentTitles[indexPath.row]
        }
        
        myCell.imageView?.image = #imageLiteral(resourceName: "search")
        //myCell.textLabel! = currentTitles[indexPath.row]

        return myCell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("updating")
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text       = currentTitles[indexPath.row]
        cell.detailTextLabel?.text = currentAuthors[indexPath.row]
        /*
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "UITableViewCell")
            }
            print("returning here")
            return cell
        }()
        
        // (cell is non-optional; no need to use ?. or !)
        
        // Configure your cell:
        cell.textLabel?.text       = currentTitles[indexPath.row]
        cell.detailTextLabel?.text = currentAuthors[indexPath.row]
        print("returning there")
         */
        return cell
        /*
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        // Configure the cell...

        return cell
 */
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
