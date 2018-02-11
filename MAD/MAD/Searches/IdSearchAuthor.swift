import Foundation
import UIKit

// SLATED FOR DELETION
protocol AuthorProtocol: class {
    func nameReceived(name: String, authorID: Int)
}

class IdSearchAuthor: NSObject {
    
    
    
    weak var delegate: AuthorProtocol!
    
    let urlPath = "http://www.the-library-database.com/php_scripts/idsearch_author.php"
    
    func downloadItems(inputID: String) -> String {
        var tempstringreturn = "nil"
        
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "password=secureAf&id=\(inputID)"
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
            //print("responseString = \(responseString)")
            
            tempstringreturn = self.parseJSON(data)
            print("authorsearchclass 3 " + tempstringreturn)
            
        }
        task.resume()
         print("authorsearchclass 4 " + tempstringreturn)
        return tempstringreturn
        
    }
    
    
    func parseJSON(_ data:Data) ->String {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var nameResult = "nil"
        
        for i in 0 ..< jsonResult.count
        {
            print("correctemundo")
            jsonElement = jsonResult[i] as! NSDictionary
            print(jsonElement)
            if let name = jsonElement["name"] as! String? {
                nameResult = name
                print("authorsearchclass 2 " + name)
                return name
            }
            
        }
        DispatchQueue.main.async(execute: { () -> Void in
            
            //self.delegate.nameReceived(name:nameResult, authorID:jsonElement["author_id"])
            
        })
        return "nil"
    }
    
}


