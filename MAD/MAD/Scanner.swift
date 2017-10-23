//
//  ViewController.swift
//  MAD
//
//  Created by David McAllister on 10/22/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit
import AVFoundation

protocol MyProtocol {
    func sendScannedValue(valueSent: String)
}

class Scanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()

    
    public var delegate:MyProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.sendScannedValue(valueSent: "hello world")
        
        /*
        //creating session
        let session = AVCaptureSession()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        
        do
        {
            
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            session.addInput(input)
            
        }
        catch let error as NSError
        {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.upce]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
