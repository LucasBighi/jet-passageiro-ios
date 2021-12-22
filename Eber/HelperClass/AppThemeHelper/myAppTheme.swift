//
//  myAppColors.swift
//  Cabtown
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//
import UIKit

extension UIColor
{
    var imageRepresentation : UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 320.0, height:64.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    static let themeImageColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
    //Custom Button Colors
    static let themeButtonBackgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1) //UIColor(red:  25/255, green: 96/255, blue: 118/255, alpha: 1.0)
    static let themeButtonTitleColor:UIColor = UIColor(red:255/255, green:255/255 ,blue:255/255 , alpha:1.00)
    static let themeSelectionColor:UIColor = UIColor(red:  0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
  
    static let themeSwitchTintColor:UIColor =  UIColor(red:  0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
    
    //Custom TextFieldColors
    static let themeActiveTextColor:UIColor = UIColor(red:  0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let themeErrorTextColor:UIColor = UIColor(red:220/255, green:74/255 ,blue:48/255 , alpha:1.0)
    static let themeTextColor:UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    static let themeLightTextColor:UIColor = UIColor(red:0/255, green:0/255 ,blue:0/255 , alpha:0.5)
  
    //NavigationBar Colors
    static let themeTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let themeNavigationBackgroundColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0, alpha: 1)
   
    //Theme Dialog Colors
    static let themeOverlayColor:UIColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 0.8)
    static let themeDialogBackgroundColor:UIColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    
    static let themeViewBackgroundColor:UIColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    static let themeDividerColor:UIColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        static let themeLightDividerColor:UIColor = UIColor(red:136/255, green:139/255 ,blue:136/255 , alpha:0.7)
    
    static let themeShadowColor:UIColor = UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1.0)
    
    static let themeGooglePathColor:UIColor = UIColor(red:  71/255, green: 170/255, blue: 255/255, alpha: 1.0)
    
    
    static let themeWalletDeductedColor:UIColor = UIColor(red:230/255, green:65/255 ,blue:67/255 , alpha:1.00)
    
    static let themeWalletAddedColor:UIColor = UIColor(red:87/255, green:142/255 ,blue:18/255 , alpha:1.00)
    
    static let themeWalletBGColor:UIColor = UIColor(red:236/255, green:236/255 ,blue:236/255 , alpha:0.60)
    
     static let themeSenderBGColor:UIColor = UIColor(red:201/255, green:206/255 ,blue:241/255 , alpha:1.0)
    
    static let themeReceiverBGColor:UIColor = UIColor(red:211/255, green:241/255 ,blue:201/255 , alpha:1.0)
    
    
 }

//MARK:- Font Helper
struct FontSize
{
    static let navigationTitle:CGFloat = 22;
    static let button:CGFloat = 22;
    
    static let small:CGFloat = 14;
    static let tiny:CGFloat = 12;
    static let regular:CGFloat = 16;
    static let medium:CGFloat = 18;
    static let large:CGFloat = 20
    static let extraLarge:CGFloat = 24;
    static let doubleExtraLarge:CGFloat = 36;
}

struct FontAsset
{
    static let icon_back_arrow = "\u{e815}"
    static let icon_car_rent = "\u{e800}"
    static let icon_add = "\u{e813}"
    static let icon_add_image = "\u{e814}"
    static let icon_bank_detail = "\u{e816}"
    static let icon_work_address = "\u{e817}"
    static let icon_new_trip = "\u{e818}"
    static let icon_calender_fill = "\u{e819}"
    static let icon_calender_blank = "\u{e81a}"
    static let icon_call = "\u{e81b}"
    static let icon_cancel = "\u{e81c}"
    static let icon_payment_card = "\u{e81d}"
    static let icon_payment_cash = "\u{e81f}"
    static let icon_card = "\u{e81e}"
    static let icon_chat = "\u{e820}"
    static let icon_cross_rounded = "\u{e821}"
    static let icon_contact = "\u{e822}"
    static let icon_destination = "\u{e823}"
    static let icon_distance = "\u{e824}"
    static let icon_document = "\u{e825}"
    static let icon_checked = "\u{e826}"
    static let icon_earning = "\u{e827}"
    static let icon_edit = "\u{e828}"
    static let icon_emergency_call = "\u{e829}"
    static let icon_expand = "\u{e82a}"
    static let icon_fare_estimate = "\u{e82b}"
    static let icon_star = "\u{e82c}"
    static let icon_filter = "\u{e82d}"
    static let icon_help = "\u{e82e}"
    static let icon_hide_password = "\u{e82f}"
    static let icon_wallet_history = "\u{e830}"
    static let icon_home_address = "\u{e831}"
    static let icon_info = "\u{e832}"
    static let icon_location = "\u{e833}"
    static let icon_forward_arrow = "\u{e834}"
    static let icon_message = "\u{e835}"
    static let icon_menu = "\u{e836}"
    static let icon_menu_referral = "\u{e854}"
    static let icon_offline = "\u{e837}"
    static let icon_menu_profile = "\u{e838}"
    static let icon_referral = "\u{e839}"
    static let icon_refresh = "\u{e83a}"
    static let icon_schedule_calender = "\u{e83b}"
    static let icon_search = "\u{e83c}"
    static let icon_radio_box_selected = "\u{e83d}"
    static let icon_navigation = "\u{e83e}"
    static let icon_menu_setting = "\u{e83f}"
    static let icon_menu_share = "\u{e840}"
    static let icon_show_password = "\u{e842}"
    static let icon_pickup_location = "\u{e843}"
    static let icon_current_location = "\u{e844}"
    static let icon_feedback_star = "\u{e845}"
    static let icon_checked_bold = "\u{e846}"
    static let icon_time = "\u{e847}"
    static let icon_btn_current_location = "\u{e848}"
    static let icon_document_place_holder = "\u{e84b}"
    static let icon_up_arrow = "\u{e84c}"
    static let icon_radio_box_normal = "\u{e84a}"
    static let icon_check_box_normal = "\u{e849}"
    static let icon_check_box_selected = "\u{e856}"
    static let icon_waiting_time = "\u{e84d}"
    static let icon_payment_wallet = "\u{e84e}"
    static let icon_warning = "\u{e84f}"
    static let icon_message_send = "\u{e850}"
    static let icon_message_receive = "\u{e851}"
    static let icon_menu_my_booking = "\u{e852}"
    static let icon_btn_work = "\u{e855}"
    static let icon_paired = "\u{e853}"
    static let icon_btn_home = "\u{e857}"
    static let icon_favourite = "\u{e85c}"
    static let icon_no_service_available = "\u{e85d}"
}

enum FontType
{
    case Bold
    case Light
    case Regular
}

class FontHelper:UIFont
{
  class func font(size: CGFloat = FontSize.regular,type:FontType) -> UIFont
    {
        switch type
        {
        case .Bold:
             return UIFont(name: "Roboto-Bold", size: size)!
        case .Light:
            return UIFont(name: "Roboto-Regular", size: size)!
        case .Regular:
            return UIFont(name: "Roboto-Regular", size: size)!
        }
    }
    class func assetFont(size: CGFloat = FontSize.regular) -> UIFont
    {
        return UIFont(name: "eber", size: size)!
    }
}
