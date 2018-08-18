import Foundation
import UIKit

//Protocol that allows for asynchronous code, allowing other code to function even if network issues causes delays in the information download
protocol UserCheck: class {
    func itemsDownloaded(items: NSArray, from: String)
}

class IdSearchBook: NSObject {
    
    
    
    weak var delegate: DownloadProtocol!
    
    let urlPath = "http://www.the-library-database.com/hhs_php/account_check.php"
    //Downloads book matching that isbn
    func downloadItems(email: String) {
        
        
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "password=secureAf&email=\(email)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            _ = String(data: data, encoding: .utf8)
            self.parseJSON(data)
        }
        task.resume()
        
    }
    
    //Parses retrieved JSON
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
            
            var book = ""
            
            
            //JsonElement values are guaranteed to not be null through optional binding
            if let id = jsonElement["user_id"] as! String?,
                let pass = jsonElement["password"] as! String?,
                let name = jsonElement["name"] as! String?,
                let email = jsonElement["email"] as! String?,
                let scid = jsonElement["schoolid"] as! String?,
                let fbid = jsonElement["facebookid"] as! String?
            {
                book = "user_id:" + id + "|password:" + pass + "|name:" + name + "|email:" + email + "|school_id:" + scid + "|facebook_id:" + fbid
            }
            
            books.add(book)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: books, from: "UserCheck")
            
        })
    }
    
}

