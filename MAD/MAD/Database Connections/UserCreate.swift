import Foundation
import UIKit


class UserCreate: NSObject {
    
    weak var delegate: TransactionProtocol!
    
    let urlPath = "http://www.the-library-database.com/hhs_php/account_create.php"
    
    //Pass in isbn of book and userid to create a hold
    func createUser(email: String,name:String) {
        
        
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "password=secureAf&email=\(email)&name=\(name)"
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
    
    //Checks for a request's success
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



