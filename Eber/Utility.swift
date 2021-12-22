//
//  Utility.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit
import SDWebImage

class Utility: ModelNSObj
{
    
    static func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    static func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var overlayView = UIView();
    static var mainView = UIView();
    override init(){

    }
    static func dateToString(date: Date, withFormat:String, withTimezone:TimeZone = TimeZone.ReferenceType.default) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = withTimezone
        dateFormatter.dateFormat = withFormat
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    static func stringToDate(strDate: String, withFormat:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: strDate) ?? Date()
    }
    static func showLoading(color: UIColor = UIColor.white){
        DispatchQueue.main.async {
            if(!activityIndicator.isAnimating)
            {
                self.mainView = UIView()
                self.mainView.frame = UIScreen.main.bounds
                self.mainView.backgroundColor = UIColor.clear
                self.overlayView = UIView()
                self.activityIndicator = UIActivityIndicatorView()
                
                overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                overlayView.layer.zPosition = 1
                
                activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                activityIndicator.style = .whiteLarge
                overlayView.addSubview(activityIndicator)
                self.mainView.addSubview(overlayView)
                
                if APPDELEGATE.window?.viewWithTag(701) != nil
                {
                    
                }
                else
                {
                    overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 701
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }

            }
            
        }
        
    }
    static func hideLoading(){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();

            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }
    static func showToast( message:String, backgroundColor:UIColor = UIColor.themeButtonBackgroundColor, textColor:UIColor = UIColor.white){

        if !message.isEmpty {
            DispatchQueue.main.async {

                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
                let label = UILabel(frame: CGRect.zero);
                label.textAlignment = NSTextAlignment.center;
                label.text = message;
                label.adjustsFontSizeToFitWidth = true;

                label.backgroundColor =  backgroundColor; //UIColor.whiteColor()
                label.textColor = textColor; //TEXT COLOR
                label.sizeToFit()
                label.numberOfLines = 4
                label.layer.shadowColor = UIColor.gray.cgColor;
                label.layer.shadowOffset = CGSize.init(width: 4, height: 3)
                label.layer.shadowOpacity = 0.3;
                label.frame = CGRect.init(x: 0, y: (appDelegate.window?.frame.maxY)!, width:  appDelegate.window!.frame.size.width, height: 44);

                label.alpha = 1
                UIApplication.shared.keyWindow?.endEditing(true)
                UIApplication.shared.windows.last?.endEditing(true)
                var window: UIWindow?

                if let keyWindow = UIApplication.shared.keyWindow {
                    window = keyWindow
                } else
                {
                    window = UIApplication.shared.windows.last

                }
                window?.addSubview(label)


                var basketTopFrame: CGRect = label.frame;
                basketTopFrame.origin.x = 0;
                basketTopFrame.origin.y = (appDelegate.window?.frame.maxY)! - label.frame.height;

                UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
                },  completion: {
                    (value: Bool) in
                    UIView.animate(withDuration: 3.0, delay: 3.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                        label.removeFromSuperview()
                    })
                })
            }
        }
    }

    static func conteverDictToJson(dict:Dictionary<String, Any>) -> Void
    {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        printE(jsonString)
    }

    //MARK: - Date Handler
    static func stringToString(strDate:String, fromFormat:String, toFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default

        let locale:NSLocale = NSLocale.init(localeIdentifier: LocalizeLanguage.currentLanguage())
        dateFormatter.locale = locale as Locale

        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
    }

    static func relativeDateStringForDate(strDate: String) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from:NSDate() as Date)
        
        let calender : NSCalendar = NSCalendar.init(identifier:.gregorian)!
        
        let dayComponent = NSDateComponents()
        
        dayComponent.day = -1
        
        let date:Date = calender.date(byAdding:dayComponent as DateComponents, to: NSDate() as Date, options: NSCalendar.Options(rawValue: 0))!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strYesterdatDate = dateFormatter.string(from:date as Date)
        
        if(strDate == currentDate)
        {
            return "Today"
        }
        else if(strDate == strYesterdatDate)
        {
            return "Yesterday"
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: strDate)
            let myCurrentDate = Utility.convertDateFormate(date: date!)
            return myCurrentDate as NSString
        }
    }
    
    
    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        
      
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    static func distanceFrom(meters: Double, unit:Int,  completion: @escaping (_ distance: String)->()) {
        
        if unit == TRUE
        {
            completion((meters * 0.001).toString(places: 2) + " " + MeasureUnit.KM)
        }
        else
        {
            completion((meters * 0.000621371).toString(places: 2) + " " + MeasureUnit.MILE)
        }
    }

    static func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let locale:NSLocale = NSLocale.init(localeIdentifier: LocalizeLanguage.currentLanguage())
        let dateFormate = DateFormatter()

        dateFormate.timeZone = TimeZone.ReferenceType.default
        dateFormate.locale = locale as Locale
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)

        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }

    static func convertSelectedDateToMilliSecond(serverDate:Date,strTimeZone:String)-> Int64
    {
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let timeSince1970 = Int64(serverDate.timeIntervalSince1970)
        let finalSelectedDateMilli = Int64(Int64(timeSince1970 * 1000) +  offSetMiliSecond)
        return finalSelectedDateMilli
    }

   //MARK:
    //MARK: - Gesture Handler
    static func addGestureForRemoveViewOnTouch(view:UIView)
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        view.addGestureRecognizer(tap)
    }
   
    @objc static func hideView(sender:UITapGestureRecognizer)
    {
        let view:UIView = sender.view!
        view.removeFromSuperview()
        view.endEditing(true)
    }
    
    static func downloadImageFrom(link:String, placeholder:String = "asset-driver-pin-placeholder", completion: @escaping (_ result: UIImage) -> Void)
    {
        if link.isEmpty()
        {
            return  completion(UIImage.init(named: placeholder)!)
        }
        else
        {
            let urlStr = WebService.BASE_URL +  link
            let shared = SDWebImageDownloader.shared
            guard let url = URL(string: urlStr) else {
                return
            }

            shared.downloadImage(with: url,
                                 options: SDWebImageDownloaderOptions.ignoreCachedResponse,
                                 progress: nil,
                                 completed: { /*[weak self]*/ (image, data, error, result) in
                                    if error != nil {
                                        //debugPrint("\(self ?? UIImageView()) \(err)")
                                    }

                                    if let downloadedImage = image
                                    {
                                        let width = (UIScreen.main.bounds.width * 0.1)
                                        let height = width
                                        let size = CGSize.init(width: width, height: height)
                                        let newImage = downloadedImage.jd_imageAspectScaled(toFit: size)
                                        completion(newImage)
                                    }
            })
        }
    }

    static func getDistanceUnit(unit: Int) -> String{
        if unit == TRUE {
            return MeasureUnit.KM
        }
        return MeasureUnit.MILE
    }
}



