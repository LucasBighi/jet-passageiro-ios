//
//  CustomSurgePriceDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomSurgePriceDialog: CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblSurgePriceValue: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForSurgePrice"
    
    
    
    public static func  showCustomSurgePriceDialog
        (title:String,
         message:String,
         surgePrice:String,
         titleLeftButton:String,
         titleRightButton:String,
         tag:Int = 400
         ) ->
        CustomSurgePriceDialog
     {
       
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomSurgePriceDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.lblSurgePriceValue.text = " " + surgePrice
        view.lblSurgePriceValue.addImage(imageName: "asset-up-arrow", afterLabel: false)
        view.setLocalization()
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        if let view = (APPDELEGATE.window?.viewWithTag(400))
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
        
        return view;
    }
    
    func setLocalization(){
        
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        
        
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()
        
        
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        
        
        lblSurgePriceValue.textColor = UIColor.themeTextColor
        lblSurgePriceValue.font = FontHelper.font(type: FontType.Regular)
        
        lblMessage.textColor = UIColor.themeTextColor
        lblMessage.font = FontHelper.font(type: FontType.Regular)
        
        
        /* Set Font */
        
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


