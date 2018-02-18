//
//  SearchTableViewCell.swift
//  MAD
//
//  Created by David McAllister on 12/23/17.
//  Copyright © 2017 Eric C. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

     @IBOutlet weak var bookCover: UIImageView!
     @IBOutlet weak var authorLabel: UILabel!
     @IBOutlet weak var titleLabel: UILabel!
     //var bookModel: BookModel
    @IBOutlet weak var innerView: UIView!
    var ranOnce: Bool = false;
    @IBOutlet weak var upperView: UIView!
    var counter: Int = 0
    var coverColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    var coverRed: CGFloat = 1.0
    var coverGreen: CGFloat = 1.0
    var coverBlue: CGFloat = 1.0
    @IBOutlet weak var cellView: UIView!
    var colorFound: Bool = false;
    var printColor: Bool = false;
    var displayDefault: Bool = true;
    var titleHolder: String = ""
    var imageHolder: UIImage = #imageLiteral(resourceName: "loadingIcon")
    static var count: Int = 0
    var numberInList: Int = 0
    var newSearch: Bool = true;
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SearchTableViewCell.count = SearchTableViewCell.count + 1
        numberInList = SearchTableViewCell.count




    }
    
    func newRequest()
    {
        newSearch = true
        //for layer in self.innerView.subla
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print(SearchTableViewCell.count)
        
        if(newSearch)
        {
            newSearch = false
            print(String(describing: numberInList) + "Test: " + self.titleLabel.text!)
            print(String(describing: numberInList) + "Test2: " + self.titleHolder)
            print("Worked" + String(describing: numberInList))
            printColor = false
            colorFound = false
            bookCover.image = nil
            //bookCover.image = #imageLiteral(resourceName: "loadingImage")
            self.counter = 0
            
            titleHolder = self.titleLabel.text!;
            //ranOnce = false
        }
        

        if(counter<20)
        {
        self.titleLabel.sizeToFit()
        }
        if(ranOnce == false)
        {
            ranOnce = true;
        upperView.layer.cornerRadius=25
        upperView.layer.masksToBounds=true
        bookCover.layer.cornerRadius=15
        bookCover.layer.masksToBounds=true
        borderView.layer.cornerRadius = 26
            borderView.layer.masksToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = innerView.bounds
        
        let topColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.25)
        let bottomColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.25)
        
        /*
        bookCover.layer.shadowColor = UIColor.black.cgColor
        bookCover.layer.shadowRadius = 20
        bookCover.layer.shadowOpacity = 0.3
        bookCover.layer.shadowOffset = CGSize(width: 0, height: 0)
             */
            self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2
            self.circleView.layer.masksToBounds = true
            cellView.layer.shadowColor = UIColor.black.cgColor
            cellView.layer.shadowRadius = 15
            cellView.layer.shadowOpacity = 0.1
            cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            titleLabel.layer.shadowColor = UIColor.black.cgColor
            titleLabel.layer.shadowRadius = 6
            titleLabel.layer.shadowOpacity = 0.3
            titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            authorLabel.layer.shadowColor = UIColor.black.cgColor
            authorLabel.layer.shadowRadius = 6
            authorLabel.layer.shadowOpacity = 0.3
            authorLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            
        //bookCover.layer.masksToBounds = false
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        //innerView.layer.insertSublayer(gradientLayer, at: 0)
        }
        if(bookCover != nil && bookCover.image != nil)
        {
            if(Double((bookCover.image?.size.height)!)>20.0 && bookCover.image?.isEqual(#imageLiteral(resourceName: "loadingImage")) == false)
            {
                if(self.numberInList == 1)
                {
                    //print("Made2")
                    
                }
                //if(counter < 10)
                //{
                if(printColor)
                {
                    if(innerView.layer.sublayers != nil)
                    {
                    for subLayer in innerView.layer.sublayers! {
                        subLayer.removeFromSuperlayer()
                        print("Clearing sublayers")
                    }
                    }
                }
                else
                {
                    if(self.displayDefault)
                    {
                        let gradientLayer = CAGradientLayer()
                        gradientLayer.frame = innerView.bounds
                        
                        let topColor = UIColor(red: 0.7, green: 0.9, blue: 1, alpha: 0.25)
                        let bottomColor = UIColor(red: 0.3, green: 0.7, blue: 1, alpha: 0.25)
                        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
                        UIView.animate(withDuration: 0.5) {
                            UIView.animate(withDuration: 1.0) {

                    //self.innerView.layer.insertSublayer(gradientLayer, at: 0)
                            }
                        }
                        self.displayDefault = false
                    }

                }
            counter = counter + 1
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = innerView.bounds
            if(self.numberInList == 1)
            {
               // print("Made3")

                }
            //let topColor = UIColor(red: 0.7, green: 0.9, blue: 1, alpha: 0.25)
            //let bottomColor = UIColor(red: 0.3, green: 0.7, blue: 1, alpha: 0.5)
                    if(counter == 1)
                    {
                        //print("Got here well" + String(describing: self.numberInList))
                    //let topColor = self.areaAverage();
                    //self.areaAverage()
                        self.getPrimaryColor()
                    }
                else
                    {
                        if(self.numberInList == 1)
                        {
                            //print(counter)
                            
                        }
                }
                
                
                    //let topColor = UIColor(red: self.coverRed, green: self.coverGreen, blue: self.coverBlue, alpha: 1.0)

                    //let bottomColor = UIColor(red: self.coverRed, green: self.coverGreen, blue: self.coverBlue, alpha: 1.0)
                
            //gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
                let gradientLayer2 = CAGradientLayer()
                
                
                //if(self.colorFound)
                //{
                
                let temp = self.coverColor.cgColor.components
                if(temp![1]<0.998 && colorFound == false)
                {
                    printColor = true
                    colorFound = true
                }
                if(printColor)
                {
                    
                    if(innerView.layer.sublayers != nil)
                    {
                        for subLayer in innerView.layer.sublayers! {
                            subLayer.removeFromSuperlayer()
                            //print("Clearing sublayers")
                        }
                    }
                    //print(String(describing: colorFound) + " " + String(describing: counter))
                    printColor = false
                    gradientLayer2.colors = [UIColor.white, UIColor.white]
                    UIView.animate(withDuration: 0.5) {

                    //self.innerView.layer.insertSublayer(gradientLayer2, at: 0)
                    }
                    //print("Sublayers: " + String(describing: innerView.layer.sublayers!.count))
                    //func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
                        let percentage = CGFloat(90.0)
                        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                        if self.coverColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
                            if b < 1.0 {
                                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
                                self.coverColor = UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
                            } else {
                                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                                self.coverColor = UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
                            }
                        }
                        //return self
                    //}
                    let temp = self.coverColor.cgColor.components
                    let avg = (temp![0] + temp![1] + temp![2])/CGFloat(3.0)
                    if(avg > 0.75)
                    {
                        self.titleLabel.textColor = UIColor.darkGray
                        self.authorLabel.textColor = UIColor.darkGray
                        
                        
                    }
                    else
                    {
                        self.titleLabel.textColor = UIColor.white
                        self.authorLabel.textColor = UIColor.white
                    }
            gradientLayer.colors = [self.coverColor.withAlphaComponent(0.5).cgColor, self.coverColor.withAlphaComponent(0.5).cgColor]
                    if(gradientLayer.colors!.count > 0)
                    {
                    UIView.animate(withDuration: 1.0) {
                        //self.innerView.alpha = 0.2
                        //self.innerView.backgroundColor = self.coverColor
                        //gradientLayer.colors?[0] as? UIColor
                        self.circleView.backgroundColor = self.coverColor
                        self.borderView.backgroundColor = self.coverColor
                        self.titleLabel.textColor = UIColor.black
                        self.authorLabel.textColor = UIColor.black
                        self.borderView.alpha = 0.7

            //self.innerView.layer.insertSublayer(gradientLayer, at: 0)
                    }
                    }
                    //print("put into sublayer")
                //self.colorFound = false
                }
                //}
                //}
            }
        }
        
        
        // Configure the view for the selected state
    }
    
    func getPrimaryColor()
    {
        let image = self.bookCover?.image
        //if(self.numberInList == 1)
        //{
            //print("Doing some calcs")
            
        //}
        image?.getColors { colors in
            
            self.coverColor = colors.background
            
            
            let temp = self.coverColor.cgColor.components
            //print(self.titleLabel.text! + ": " + String(describing: temp))
            
            if(temp![0] > 0.99 && temp![1] > 0.99 && temp![2] > 0.99)
            {
                self.coverColor = colors.detail
            }
            
           self.colorFound = false
            self.printColor = true
            
        }
    }
    
    func areaAverage() /*-> UIColor*/ {
        print("calculating")
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        let context = CIContext(options: nil)
        //let temp = CGImage(image: self.bookCover)
        let cgImg = context.createCGImage(CoreImage.CIImage(cgImage: (self.bookCover.image?.cgImage)!), from: CoreImage.CIImage(cgImage: (self.bookCover.image?.cgImage)!).extent)
        
        let inputImage = CIImage(cgImage: cgImg!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        // Compute result.
        //let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        self.coverRed = CGFloat(bitmap[0])/CGFloat(255.0)

        self.coverGreen = CGFloat(bitmap[1])/CGFloat(255.0)
        self.coverBlue = CGFloat(bitmap[2])/CGFloat(255.0)
        //return result
    }

}

extension UIColor {
    
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

