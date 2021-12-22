//
//  CustomDriverDetailDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomDriverDetailDialog: CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancelTrip: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imgDriver: UIImageView!
    
    //MARK:Variables
    var onClickCancelTrip : (() -> Void)? = nil
    
    static let  verificationDialog = "dialogForDriverDetail"
    
    
    
    public static func  showCustomDriverDetailDialog
        (name:String,
         imageUrl:String,
         rate:Double = 0.0,
         message:String,
         cancelButton:String,
         tag:Int = 112
         ) ->
        CustomDriverDetailDialog
     {
       
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDriverDetailDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.imgDriver.image =  UIImage.animatedImage(with: [UIImage.init(named: "asset-lookingForProvider1")!,UIImage.init(named: "asset-lookingForProvider2")!], duration: 0.5)
        view.lblMessage.text = message;
         view.setLocalization()
         view.btnCancelTrip.setTitle(cancelButton.localizedCapitalized, for: UIControl.State.normal)
        if let view = (APPDELEGATE.window?.viewWithTag(110))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
        UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
      
        
        return view;
    }
    
    func setLocalization(){
        btnCancelTrip.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnCancelTrip.backgroundColor = UIColor.themeButtonBackgroundColor
         lblMessage.textColor = UIColor.themeTextColor
         btnCancelTrip.setupButton()
        /* Set Font */
        btnCancelTrip.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblMessage.font = FontHelper.font(type: FontType.Regular)
        
         
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    //ActionMethods
    
   
    @IBAction func onClickBtnCancel(_ sender: Any)
    {
        if self.onClickCancelTrip != nil
        {
            self.onClickCancelTrip!()
        }
        
    }
    
}


