//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomVerificationDialog: CustomDialog, UITextFieldDelegate
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var editText: ACFloatingTextfield!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables
    var onClickRightButton : ((_ text:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForVerification"
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public static func  showCustomVerificationDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         editTextHint:String,
         editTextInputType:Bool = false
         ) ->
        CustomVerificationDialog
     {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVerificationDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.lblMessage.isHidden = message.isEmpty()
        view.setLocalization()
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        view.editText.isSecureTextEntry = editTextInputType
        if view.editText.isSecureTextEntry
        {
            view.editText.isPasswordTextField = true
            view.editText.addPasswordWatcher()
        }
        view.editText.placeholder = editTextHint;
        
        
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    
    func setLocalization(){
        /* Set Color */
        
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTitleColor
        lblMessage.textColor = UIColor.themeTextColor
        editText.textColor = UIColor.themeTextColor
        
        
        btnRight.setupButton()
        
        /* Set Font */
        
        btnLeft.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        
        
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblMessage.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        editText.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == self.editText
        {
            textField.resignFirstResponder()
            
        }
        else
        {
            textField.resignFirstResponder();
        }
        
        
        return true
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
            self.onClickRightButton!(editText.text ?? "")
        }
        
    }
    public override func removeFromSuperview() {
        super.removeFromSuperview()
      
    }
}


