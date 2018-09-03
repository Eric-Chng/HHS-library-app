//
//  IDScannerViewController.swift
//  FUHSD Libraries
//
//  Created by David McAllister on 9/2/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import UIKit
import AVFoundation

class IDScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    var lastScan = Int(ProcessInfo.processInfo.systemUptime)
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    var captureSession:AVCaptureSession!
    var currentBook: BookModel?
    var currentISBN: String = ""
    var scannerStopped = false
    //var qrCodeFrameView:UIView?
    
    public var delegate:MyProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueView = UIView()
        //        let screenSize = UIScreen.main.bounds
        //        let screenWidth = screenSize.width
        //        let screenHeight = screenSize.height
        
        //        let isbnBook = IdSearchBook.init()
        //        isbnBook.delegate = self
        //        isbnBook.downloadItems(isbn: "978-0-374-53451-6")
        
        
        blueView.frame = view.layer.bounds
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         let horizontalConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -20)
         let verticalConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
         let widthConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view.widthAnchor, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
         let heightConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view.heightAnchor, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80)
         blueView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
         */
        introAnimationView.addSubview(blueView)
        
        blueView.widthAnchor.constraint(equalTo: introAnimationView.widthAnchor, multiplier: 1).isActive = true
        //blueView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor)
        blueView.heightAnchor.constraint(equalToConstant: introAnimationView.frame.height).isActive = true
        blueView.leftAnchor.constraint(equalTo: introAnimationView.leftAnchor, constant: 0).isActive = true
        blueView.topAnchor.constraint(equalTo: introAnimationView.topAnchor, constant: 0).isActive = true
        blueView.backgroundColor = testView.backgroundColor
        
        //print("Uptime: " + String(Int(ProcessInfo.processInfo.systemUptime)))
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    var scannerAdded: Bool = false
    var blueView: UIView = UIView()
    @IBOutlet weak var introAnimationView: UIView!
    override func viewDidAppear(_ animated: Bool)
    {
        //print()
        //creating session
        blueView = UIView()
        //        let screenSize = UIScreen.main.bounds
        //let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        blueView.frame = view.layer.bounds
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         let horizontalConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -20)
         let verticalConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
         let widthConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view.widthAnchor, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
         let heightConstraint = NSLayoutConstraint(item: blueView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view.heightAnchor, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 80)
         blueView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
         */
        introAnimationView.addSubview(blueView)
        
        blueView.widthAnchor.constraint(equalTo: introAnimationView.widthAnchor, multiplier: 1).isActive = true
        //blueView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor)
        blueView.heightAnchor.constraint(equalToConstant: introAnimationView.frame.height*2.2).isActive = true
        blueView.leftAnchor.constraint(equalTo: introAnimationView.leftAnchor, constant: 0).isActive = true
        blueView.topAnchor.constraint(equalTo: introAnimationView.topAnchor, constant: -200).isActive = true
        blueView.backgroundColor = testView.backgroundColor
        
        
        if(self.scannerAdded == false)
        {
            self.scannerAdded = true
            //Define capture device
            if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            {
                captureSession = AVCaptureSession()
                
                do
                {
                    
                    let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
                    captureSession.addInput(input)
                    
                }
                catch let error as NSError
                {
                    print(error)
                }
                
                let output = AVCaptureMetadataOutput()
                captureSession.addOutput(output)
                
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
                output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.ean8]
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
                videoPreviewLayer.frame = UIScreen.main.bounds
                testView.layer.addSublayer(videoPreviewLayer)
                //view.sendSubview(toBack: videoPreviewLayer)
                captureSession.startRunning()
                print("Video feed started")
                for x in blueView.constraints
                {
                    //print(x)
                    //print(x.constant)
                    if(x.constant == introAnimationView.frame.height)
                    {
                        //self.blueView.removeConstraint(x)
                        
                        x.constant = 0
                        
                    }
                    
                }
                
                UIView.animate(withDuration: 0.37) {
                    self.blueView.layoutIfNeeded()
                }
                let tempVIew = UIView(frame: CGRect(x: 200, y: 200, width: 200, height: 200))
                view.addSubview(tempVIew)
                //print("Uptime: " + String(Int(ProcessInfo.processInfo.systemUptime)))
            }
            else
            {
                print("Camera not found")
            }
        }
        else
        {
            captureSession.startRunning()
            
            for x in blueView.constraints
            {
                //print(x)
                //print(x.constant)
                if(x.constant == introAnimationView.frame.height)
                {
                    //self.blueView.removeConstraint(x)
                    
                    x.constant = 0
                    
                }
                
            }
            
            UIView.animate(withDuration: 0.37) {
                self.blueView.layoutIfNeeded()
            }
        }
    }
    @IBOutlet weak var testView: UIView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing segue")
        
        if let destinationViewController = segue.destination as? BookDetailViewController {
            destinationViewController.selectedBook = self.currentBook!
            destinationViewController.fromScanner = true
        }
    }
    
    @available(iOS, deprecated: 9.0)
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if self.lastScan  < (Int(ProcessInfo.processInfo.systemUptime) - 1)  && metadataObjects.count != 0
        {
            self.lastScan = Int(ProcessInfo.processInfo.systemUptime)
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.code39 && scannerStopped == false
                {
                    let alert = UIAlertController(title: "ID Card Scanned", message: "Barcode found: " + object.stringValue!, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    print("Barcode type")
                    print(object.type)
                    let alert = UIAlertController(title: "Unkown barcode type", message: "Barcode type found: " + String(describing: object.type), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
                    //                    self.present(alert, animated: true, completion: nil)
                    //                    alert.addAction(UIAlertAction(title: String(describing: object.type!), style: .default, handler: nil))
                }
            }
        }
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
