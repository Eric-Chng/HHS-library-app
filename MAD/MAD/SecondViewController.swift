//
//  SecondViewController.swift
//  MAD
//
//  Created by NonAdmin Eric on 10/20/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController, MyProtocol{
    
    
    func sendScannedValue(valueSent: String) {
        self.scannerValue = valueSent
        scannerLabel.text = valueSent
    }
    
    @IBOutlet weak var scannerLabel: UILabel!
    
    
    var scannerValue:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //self.navigationController?.push
        self.navigationController?.pushViewController(scanners, animated: true)
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

