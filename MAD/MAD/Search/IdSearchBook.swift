
import Foundation
import UIKit

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class IdSearchBook: NSObject {
    

    
    weak var delegate: HomeModelProtocol!
    
    let urlPath = "http://www.the-library-database.com/idsearch_book"
    
    func downloadItems() {

        let url: URL = URL(string: urlPath)!
       let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        // unsure if this sends accurate post request
        var bodyData = "id=1000000"
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
        //end
        /*
         let url = URL(string: urlPath)!
         var request = URLRequest(url: url)
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "POST"
         let postString = "password=secureAf&id=130948320984"
         request.httpBody = postString.data(using: .utf8)
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data, error == nil else {                                                 // check for fundamental networking error
         print("error=\(error)")
         return
         }
         
         if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
         print("statusCode should be 200, but is \(httpStatus.statusCode)")
         print("response = \(response)")
         }
         
         let responseString = String(data: data, encoding: .utf8)
         print("responseString = \(responseString)")
         }
         task.resume()
         */
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        //hella NS objects
        var jsonElement = NSDictionary()
        let books = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let book = BookModel()
            
            //JsonElement values are guaranteed to not be null through optional binding
            if let name = jsonElement["Name"] as? String,
                let ID = jsonElement["bookID"] as? String,
                let authorID = jsonElement["authorID"] as? String,
                let desc = jsonElement["desc"] as? String
            {
                
                book.name = name
                book.ID = ID
                book.authorID = authorID
                book.desc = desc
                
            }
            
            books.add(book)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: books)
            
        })
    }
    
}



