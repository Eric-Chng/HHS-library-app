import Foundation
import UIKit

//Called to verify when a transaction is successful
protocol TransactionProtocol: class {
    func transactionProcessed(success: Bool)
}

class UserCheckout: NSObject {
    
    
    weak var delegate: TransactionProtocol!
    
    let urlPath = "http://www.the-library-database.com/php_scripts/user_checkout.php"
    
    //Checks out a book for a user
    func checkout(isbn: String,user:String) {
        
        
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "password=secureAf&isbn=\(isbn)&user=\(user)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                //print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            self.checkTransaction(responseString)
        }
        task.resume()
        
    }
    
    //Checks for request's success
    func checkTransaction(_ response:String?) {
        var script_success = false;
        if (response=="script success"){
            script_success=true;
        }
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.transactionProcessed(success: script_success)
            
        })
    }
    
}


