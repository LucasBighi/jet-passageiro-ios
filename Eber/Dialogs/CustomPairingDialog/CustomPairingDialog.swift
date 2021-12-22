//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomPairingDialog: CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    
    @IBOutlet weak var lblTitle: UILabel!
   
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viewForPickupAddress: UIView!
    @IBOutlet weak var viewForSourceAddress: UIView!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    
    
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForPairing"
    
    
    
    public static func  showCustomPairingDialog
        (title:String,
         sourceAddress:String,
         destinationAddress:String,
         titleLeftButton:String,
         titleRightButton:String, 
         tag:Int = 501
         ) ->
        CustomPairingDialog
     {
       
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPairingDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
       
        view.setLocalization()
        view.lblTitle.text = title;
        view.lblPickupAddress.text = sourceAddress
        view.lblDestinationAddress.text = destinationAddress
      //  view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        if let view = (APPDELEGATE.window?.viewWithTag(501))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
        UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        view.btnLeft.isHidden =  titleLeftButton.isEmpty()
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        view.lblTitle.isHidden = title.isEmpty()
        
        return view;
    }
    
    func setLocalization(){
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTitleColor
         btnRight.setupButton()
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
         viewForPickupAddress.backgroundColor = UIColor.groupTableViewBackground
        viewForSourceAddress.backgroundColor = UIColor.groupTableViewBackground
        viewForPickupAddress.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        viewForSourceAddress.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    //ActionMethods
    
    @IBAction func onClickBtnLeft(_ sender: Any)
    {
        if self.onClickLeftButton != nil
        {
            self.onClickLeftButton!();
        }
        
        
    }
    @IBAction func onClickBtnRight(_ sender: Any)
    {
        if self.onClickRightButton != nil
        {
            self.onClickRightButton!()
        }
        
    }
    
}


