//
//  HoldViewController.swift
//  MAD
//
//  Created by David McAllister on 2/11/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit

class HoldViewController: UIViewController, TransactionProtocol {
    
    
    func transactionProcessed(success: Bool) {
        self.holdButton.setTitle("Set Hold", for: UIControlState.normal)
        if(success)
        {
            self.holdButton.setTitle("Success", for: UIControlState.normal)
            let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "holdUnwind", sender: self)
        }
    }
    

    @IBOutlet weak var backgroundView: UIView!
    var currentModel: BookModel = BookModel()
    @IBOutlet weak var authorLabel: UILabel!
    var storeTitle: String = "Title"
    var author: String = "Author"
    var isbn: String = ""
    @IBOutlet weak var isbnLabel: UILabel!
    var bookImage: UIImage = UIImage()
    @IBOutlet weak var holdButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = storeTitle
        self.authorLabel.text = author
        self.bookImageView.image = bookImage
        self.isbnLabel.text = ("ISBN: " + self.isbn)
        self.bookImageView.layer.cornerRadius = 10
        self.bookImageView.layer.masksToBounds = true
        self.holdButton.layer.cornerRadius = 10
        self.holdButton.layer.masksToBounds = true
        
        backgroundView.backgroundColor = UIColor.clear
        /*
        let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any)
    {
        //self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "holdUnwind", sender: self)
        
    }
    
    @IBAction func holdPressed(_ sender: Any)
    {
        self.holdButton.setTitle("Processing Hold", for: UIControlState.normal)

        let holdCreate = HoldCreate()
        holdCreate.delegate = self

        holdCreate.createhold(isbn: self.isbn, user: UserDefaults.standard.object(forKey: "userId") as! String)
        //login.delegate = self
        //login.verifyLogin(schoolID: userNameField.text!, password: passwordField.text!)
    }
    func setBookModel(model: BookModel)
    {
        self.currentModel = model
            storeTitle = currentModel.title!
            author = currentModel.author!
            bookImage = currentModel.BookCoverImage.image!
            isbn = currentModel.ISBN!
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
