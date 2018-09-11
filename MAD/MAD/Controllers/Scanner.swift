//
//  ViewController.swift
//  MAD
//
//  Created by David McAllister on 10/22/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftEntryKit

protocol MyProtocol {
    func sendScannedValue(valueSent: String)
}

class Scanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, DownloadProtocol, TransactionProtocol {
    
    
    func transactionProcessed(success: Bool) {
        if(success)
        {
            var attributes = EKAttributes.topFloat
            attributes.entryBackground = .gradient(gradient: .init(colors: [.greenGrass, UIColor.init(red: 0.8, green: 1.0, blue: 0.2, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.displayDuration = 3
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
            
            let title = EKProperty.LabelContent(text: "Student ID Added", style: .init(font: MainFont.bold.with(size: 18), color: UIColor.white))
            let description = EKProperty.LabelContent(text: "Check it out on your profile page", style: .init(font: MainFont.light.with(size: 12), color: UIColor.white))
            let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "success"), size: CGSize(width: 45, height: 45))
            let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            
            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    
    
    func itemsDownloaded(items: NSArray, from: String) {
        print("Items downloaded called")
        
        for item in items
        {
            if let book = item as? BookModel
            {
                self.currentBook = book
                self.performSegue(withIdentifier: "scannerPushToDetail", sender: self)

                print(book.title!)
            }
        }
        if items.count < 1
        {
            self.currentBook = BookModel.init(ISBN: self.currentISBN)
            self.performSegue(withIdentifier: "scannerPushToDetail", sender: self)

        }
        scannerStopped = false
    }
    
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
            var attributes = EKAttributes.topFloat
            attributes.entryBackground = .gradient(gradient: .init(colors: [.greenGrass, UIColor.init(red: 0.8, green: 1.0, blue: 0.2, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.displayDuration = 3
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
            
            let title = EKProperty.LabelContent(text: "Scanning", style: .init(font: MainFont.bold.with(size: 18), color: UIColor.white))
            let description = EKProperty.LabelContent(text: "Point the camera at an ID card or book barcode", style: .init(font: MainFont.light.with(size: 12), color: UIColor.white))
            let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "phone"), size: CGSize(width: 45, height: 45))
            let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            
            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
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
                if object.type == AVMetadataObject.ObjectType.ean13 && scannerStopped == false
                {
                    if self.viewIfLoaded?.window != nil {
                    //delegate?.sendScannedValue(valueSent: object.stringValue!)
                        //BookDetailViewController.updateISBN(newISBN: object.stringValue!)
                        //captureSession.stopRunning()
                        //let scanners = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
                        
                        //self.navigationController?.push
                        //self.navigationController?.pushViewController(scanners, animated: true)
                        //print("test point")
                        scannerStopped = true
                        var attributes = EKAttributes.centerFloat
                        attributes.entryBackground = .gradient(gradient: .init(colors: [.greenGrass, UIColor.init(red: 0.8, green: 1.0, blue: 0.2, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                        attributes.statusBar = .light
                        attributes.displayDuration = 1
                        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
                        
                        let title = EKProperty.LabelContent(text: "Book Scanned", style: .init(font: MainFont.bold.with(size:22), color: UIColor.white))
                        let description = EKProperty.LabelContent(text: "Searching the web now...", style: .init(font: MainFont.light.with(size: 14), color: UIColor.white))
                        let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "phone"), size: CGSize(width: 45, height: 56))
                        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                        
                        let contentView = EKNotificationMessageView(with: notificationMessage)
                        SwiftEntryKit.display(entry: contentView, using: attributes)
                        self.currentISBN = object.stringValue!
                        let isbnBook = IdSearchBook.init()
                        isbnBook.delegate = self
                        isbnBook.downloadItems(isbn: object.stringValue!)

                    //_ = navigationController?.popViewController(animated: true)
                    }
                    
                    
//                    alert.addAction(UIAlertAction(title: "Checkout", style: .default, handler: nil))
                    
                    

                    
                    
                    
                    //alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {(nil) in UIPasteboard.general.string = object.stringValue}))
                    //present(alert, animated: true, completion: nil)
 
 
                }
                else if object.type == AVMetadataObject.ObjectType.code39 && scannerStopped == false
                {
                    let alert = UIAlertController(title: "ID Card Scanned", message: "Would you like to add the Student ID " + object.stringValue! + " to your account?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        let setSchoolID = UserSetSchoolID()
                        setSchoolID.delegate = self
                        setSchoolID.setSchoolID(id: UserDefaults.standard.object(forKey: "userId") as! String, schoolid: object.stringValue!)
                    })
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
