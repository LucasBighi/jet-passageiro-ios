//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomStatusDialog: CustomDialog
{
   //MARK:- OUTLETS
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables

    var onClickOkButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForStatus"
    
    
    
    public static func  showCustomStatusDialog
        (
         message:String,
         titletButton:String,
         tag:Int = 150
         ) ->
        CustomStatusDialog
     {
       
        
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomStatusDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;

        
        view.lblMessage.text = message;
        view.setLocalization()
     
        view.btnOk.setTitle(titletButton.capitalized, for: UIControl.State.normal)
        if let view = (APPDELEGATE.window?.viewWithTag(tag))
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
     
        btnOk.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnOk.backgroundColor = UIColor.themeButtonBackgroundColor
         lblMessage.textColor = UIColor.themeTextColor
         btnOk.setupButton()
        /* Set Font */
        btnOk.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblMessage.font = FontHelper.font(type: FontType.Regular)
        
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    func updateMessage(message:String)
    {
        self.lblMessage.text = message;
    }
    //ActionMethods
    
   
    @IBAction func onClickBtnOk(_ sender: Any)
    {
        if self.onClickOkButton != nil
        {
            self.onClickOkButton!()
        }
    }
    
}


