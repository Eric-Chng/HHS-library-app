//
//  SearchTableViewController.swift
//  MAD
//
//  Created by David McAllister on 12/23/17.
//  Copyright © 2017 Eric C. All rights reserved.
//
import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, DownloadProtocol, UITabBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var currentAuthors: [String] = [""]
    var currentTitles: [String] = []
    var currentCovers: [UIImage] = [UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage(), UIImage()]
    var currentISBNs: [String] = [""]
    var timer = Timer()
    var currentBooks: [BookModel] = []
    var downloaded: Bool = false;
    var currentThumbnails: [String] = [""]
    var pressedItem: Int = 0
    var JSONsParsed: [String] = []
    var requestCounter: Int = 0
    var libraryBookModels: [BookModel] = []
    @IBOutlet weak var tableViewSearch: UISearchBar!
    var sendNewRequest: Bool = false;
    var discoverViewController: [DiscoverViewController] = []

    var currentCoversDownloaded:[Bool] = [false, false, false, false, false, false, false, false, false, false]
    
    
    @available(iOS, deprecated: 9.0)
    func itemsDownloaded(items: NSArray, from: String) {
        var counter: Int = 0
        for book in items {
            counter = counter + 1
            //print(book)
        switch book {
            case is BookModel:
                print("gotem")
                print(book)
                if((book as! BookModel).title != nil)
                {
                    print("Title gotten: " + (book as! BookModel).title!)
                    self.currentTitles.append((book as! BookModel).title!)
                    print(self.currentTitles[0])
                    self.currentAuthors.append((book as! BookModel).author!)
                    print("Author found: " + (book as! BookModel).author!)
                }
                _ = book as! BookModel
                self.sendNewRequest = true
            default:
                print("failed")
                if (items.count == 1) {
                    return;
                    // no books found in database ____________________________
                }
            }
        }
        if(counter < 1)
        {
            currentTitles.append("No Results Found")
            currentAuthors.append("Please try another query")
        }
        let temparray = NSMutableArray()
        var count:Int = 0;
        for itemUse in items {
            if (count<10) {
                temparray.add(itemUse)
            }
            count = count + 1;
        }
        //Searches with library Database
        displayResults(books: temparray)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController.b
        self.navigationItem.hidesBackButton = true
        tableViewSearch.becomeFirstResponder()
        let clearColor = UIColor(red: 0.3, green: 0.7, blue: 1, alpha: 0.0)
        
        self.tableView.separatorColor = clearColor;
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(SearchTableViewController.action), userInfo: nil,  repeats: true)
        
    }
    
    @objc func action()
    {
        //print("hi")
        //self.tableView.scroll
        if(self.tableView.contentOffset.y < -63)
        {
            self.tableView.reloadData()
            //print("Offset: " + String(describing: self.tableView.contentOffset.y))
        }
        if(currentISBNs.count>3 && downloaded == false)
        {
            //print("stored")
            
            //print("now")
            downloaded = true
            
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        //self.performSegue(withIdentifier: "searchUnwindSegue", sender: self)
        self.navigationController?.popViewController(animated: false)
        //self.dismiss(animated: false, completion: nil)
        //self.discoverViewController[0].view.setNeedsDisplay()
    }
    
    //func searchBar(searchBar: UISearchBar, textDidChange: String) {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.currentTitles = []
        self.currentAuthors = []
        self.currentISBNs = []
        self.tableView.reloadData()
        let keywords = searchBar.text!;
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        //print("finding results for keyword: " + keywords)
        let discoverDatabaseSearch = DiscoverSearch()
        discoverDatabaseSearch.delegate = self
        discoverDatabaseSearch.downloadItems(textquery: keywords)
        
        
        //Searches with google books API
        //apiSearch(keywordSearch: keywords)
        //Searches with local database when no method called here. It's called in itemsDownloaded()
        
        
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
        //print("Length of currentTitles: ")
        //print(currentTitles.count)
        return currentTitles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //d
        //print("ISBN: " + self.currentISBNs[indexPath.row])
        //BookDetailViewController.updateISBN(newISBN: self.currentISBNs[indexPath.row]);
        self.pressedItem = indexPath.row
        
        self.performSegue(withIdentifier: "SearchToBookDetail", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        //print("retrieving")
        let cellIdentifier: String = "cell"
        let myCell: SearchTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTableViewCell)!
        //print(sendNewRequest)
        // Get references to labels of cell
        if(currentTitles.count<=indexPath.row)
        {
            self.currentTitles = []
            self.currentAuthors = []
            self.currentTitles.append("No results found")
            self.currentAuthors.append("NA")
            if(sendNewRequest)
            {
                sendNewRequest = false;
                myCell.newRequest();
            }
            myCell.bookCover.image = nil
        }
        else
        {
            //if(indexPath.section == 1)
            //{
            if(currentTitles.count > indexPath.row)
            {
                if(self.requestCounter > 0)
                {
                    self.requestCounter = self.requestCounter - 1
                    //print("Good here")
                    sendNewRequest = false;
                    myCell.newRequest();
                }
                //print("dogs")
                myCell.titleLabel.text = currentTitles[indexPath.row];
                myCell.authorLabel.text = currentAuthors[indexPath.row]
                if(currentBooks.count > indexPath.row)
                {
                    myCell.bookCover.image = self.currentBooks[indexPath.row].BookCoverImage.image //found nil while unwrapping optional
                }
            }
            //}
            
        }
        
        //myCell.imageView?.image = #imageLiteral(resourceName: "search")
        return myCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("preparing segue")
        if(segue.identifier == "SearchToBookDetail")
        {
            
            let bookToPass = currentBooks[self.pressedItem]
            //selectedBooke
            if let destinationViewController = segue.destination as? BookDetailViewController {
                destinationViewController.selectedBook = bookToPass
            }
        }
        else if(segue.identifier != "unwindSegueToVC1")
        {
            //performSegue(withIdentifier: "unwindSegueToVC1", sender: self)

        }
    }
    
    @available(iOS, deprecated: 9.0)
    func apiSearch(keywordSearch: String){
        let keywords = keywordSearch.replacingOccurrences(of: " ", with: "+")
        let todoEndpoint: String = "https://www.googleapis.com/books/v1/volumes?q=intitle:" + keywords + "&key=AIzaSyBCy__wwGef5LX93ipVp1Ca5ovoLpMqjqw"
        
        /*"https://www.googleapis.com/books/v1/volumes?q=intitle:Hello&key=AIzaSyBCy__wwGef5LX93ipVp1Ca5ovoLpMqjqw"*/
        
        /*"https://www.googleapis.com/books/v1/volumes?q=intitle:" + keywords + "&key=AIzaSyBCy__wwGef5LX93ipVp1Ca5ovoLpMqjqw"*/
        //print("keywords:" + keywords + "]")
        //print("https://www.googleapis.com/books/v1/volumes?q=intitle:" + keywords + "&key=AIzaSyBCy__wwGef5LX93ipVp1Ca5ovoLpMqjqw")
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
                    //print(JSONAsString)
                    //print("End of JSON")
                    
                    var counter:Int = 0;
                    //Parses out the title
                    while let rangeTotitle: Range<String.Index> = JSONAsString.range(of: " title = ")
                    {
                        let distanceTotitle = Int(JSONAsString.distance(from: JSONAsString.startIndex, to: rangeTotitle.lowerBound))
                        let titleIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle+9)
                        let temp = JSONAsString[titleIndex...]
                        let titleAndOn = String(temp)
                        //print("Title and on: " + titleAndOn)
                        //print("swung through")
                        //print(JSONAsString)
                        self.JSONsParsed.append(JSONAsString)
                        let x = BookModel.init(JSON: JSONAsString)
                        
                        self.sendNewRequest = true
                        self.requestCounter = self.requestCounter + 1
                        
                        
                        
                        let rangeToSemiColon: Range<String.Index> = titleAndOn.range(of: ";")!
                        let distanceToSemiColon = Int(titleAndOn.distance(from: titleAndOn.startIndex, to: rangeToSemiColon.lowerBound))
                        
                        if(counter == 0 && x.title!.count>3)
                        {
                            /*
                            self.currentAuthors = []
                            self.currentTitles = []
                            self.currentISBNs = []
                            self.currentThumbnails = []
                            self.currentBooks = []
                            */
                        }
                        if JSONAsString.range(of: "authors = ") != nil
                        {
                            
                            //print("The Author is \"" + finalAuthor + "\"")
                            
                            let tempIndex = JSONAsString.index(JSONAsString.startIndex, offsetBy: distanceTotitle + distanceToSemiColon)
                            
                            
                            self.currentTitles.append(x.title!)
                            self.currentAuthors.append(x.author!)
                            self.currentISBNs.append(x.ISBN!)
                            self.currentBooks.append(x)
                            self.sendNewRequest = true
                            if(x.googleImageURL != nil)
                            {
                                self.currentThumbnails.append(x.googleImageURL!)
                            }
                            else
                            {
                                print("Image URL not found")
                            }
                            
                            //print("qualified if")
                            //let substring1 = template[indexStartOfText...]
                            //let temp = JSONAsString[tempIndex...]
                            //print(String(temp))
                            JSONAsString = String(JSONAsString[tempIndex...])
                            //JSONAsString = String(temp)
                            //979x
                            //31
                            
                            counter = counter + 1;
                        }
                        else{
                            print(JSONAsString)
                            JSONAsString = "break"
                        }
                    }
                    /*
                     for m in self.JSONsParsed
                     {
                     print("Initialization started")
                     //print(m)
                     let x = BookModel.init(JSON: m)
                     print("Initialization ended")
                     }
                     */
                    
                }
                else
                {
                    print("No results found")
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
            print("Test received")
    }
    
    @available(iOS, deprecated: 9.0)
    func displayResults(books: NSMutableArray){

        var counter:Int = 0
        //self.currentAuthors = []
        //self.currentTitles = []
        //self.currentISBNs = []
        self.currentThumbnails = []
        self.currentBooks = []
        for tempvarforarray in books {
            if (tempvarforarray is BookModel) {
                print("search returned book")
                let intermediatetemp = tempvarforarray as! BookModel
                //let x = BookModel(ISBN: intermediatetemp.ISBN!)
                let y = BookModel.init(ISBN: intermediatetemp.ISBN!, name: intermediatetemp.name!, author: intermediatetemp.author!, desc: "")
                //print(x)
                //self.currentTitles.append(x.title!)
                //self.currentTitles.append("test")
                //self.currentAuthors.append(x.author!)
                //self.currentISBNs.append(x.ISBN!)
                
                self.currentBooks.append(y)
                self.sendNewRequest = true
                if(y.googleImageURL != nil)
                {
                    self.currentThumbnails.append(y.googleImageURL!)
                }
                else
                {
                    print("Image URL not found")
                }
                
                counter = counter + 1;
            } else {
                print(type(of: tempvarforarray))
            }
            
            
        }
        
        
    }
}
