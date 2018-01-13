//
//  SecondViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController, MyProtocol{
    
    var lastSendTime:Int = Int(ProcessInfo.processInfo.systemUptime)
    
    func sendScannedValue(valueSent: String) {
        if(lastSendTime != Int(ProcessInfo.processInfo.systemUptime))
        {
            lastSendTime = Int(ProcessInfo.processInfo.systemUptime);
        self.scannerValue = valueSent
        scannerLabel.text = valueSent
        BookDetailViewController.updateISBN(newISBN: valueSent)
        print("sending value")
        //self.performSegue(withIdentifier: "scannerDetailViewSegue", sender: self)

            //let scanners = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
            
            
            //self.navigationController?.push
            //self.navigationController?.pushViewController(scanners, animated: true)
        //super.window?.makeKeyAndVisible()
        //self.tabBarController?.prefersStatusBarHidden = false;
        }
    }

    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scannerDetailViewSegue"
        {
            if let destinationVC = segue.destination as? BookDetailViewController {
                destinationVC.ISBN = scannerValue!
            }
        }
    }*/
    
    @IBOutlet weak var scannerLabel: UILabel!
    
    
    var scannerValue:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = false

        //creating session
        //let session = AVCaptureSession()
        
        //Define capture device
        //let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        if scannerValue != nil
        {
            print("Value from display = \(scannerValue!)")
        }
       
        
        
         //navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func goNext(_ sender: Any) {
        let scanners = self.storyboard?.instantiateViewController(withIdentifier: "Scanner") as! Scanner
        
        scanners.delegate = self
        print("going next")
        //self.navigationController?.push
        self.navigationController?.pushViewController(scanners, animated: true)
        //self.performSegue(withIdentifier: "scannerDetailViewSegue", sender: self)

        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

