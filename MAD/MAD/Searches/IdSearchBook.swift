import Foundation
import UIKit

protocol DownloadProtocol: class {
    func itemsDownloaded(items: NSArray, from: String)
}

class IdSearchBook: NSObject {
    
    
    
    weak var delegate: DownloadProtocol!
    
    let urlPath = "http://www.the-library-database.com/php_scripts/isbn_book.php"
    
    func downloadItems(inputID: String) {
        
        
         let url = URL(string: urlPath)!
         var request = URLRequest(url: url)
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "POST"
         let postString = "password=secureAf&isbn=\(inputID)"
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
            self.parseJSON(data)
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
        
        //NSArrays initialized
        var jsonElement = NSDictionary()
        let books = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {

            jsonElement = jsonResult[i] as! NSDictionary
            
            let book = BookModel()
  
            
            //JsonElement values are guaranteed to not be null through optional binding
            if let name = jsonElement["name"] as! String?,
                let isbn = jsonElement["isbn"] as! String?,
                let authorID = jsonElement["author_id"] as! String?,
                let desc = jsonElement["description"] as! String?
            {
                book.name = name
                book.ISBN = isbn
                book.authorID = CLong(authorID)
                book.desc = desc
                print(name)
            }
            
            books.add(book)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: books, from: "idSearch")
            
        })
    }
    
}

