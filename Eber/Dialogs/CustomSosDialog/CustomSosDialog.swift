//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomSosDialog: CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    
    //MARK:Variables
    var timerLeft:Int = 10;
    
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForSos"
    weak var timerSos:Timer? = nil
    
    
    public static func  showCustomSosDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String, 
         tag:Int = 401
         ) ->
        CustomSosDialog
     {
       
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomSosDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        
        view.lblMessage.text = message;
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
        view.lblTitle.isHidden = title.isEmpty()
        view.startTimer()
        return view;
    }
    
    func setLocalization(){
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTitleColor
        lblMessage.textColor = UIColor.themeTextColor
         btnRight.setupButton()
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblMessage.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    func startTimer()
    {
        self.watchTimer()
        DispatchQueue.main.async { [unowned self/*, weak timer = self.timerSos*/] in
            self.timerSos?.invalidate()
            self.timerSos = nil
            self.timerSos = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.watchTimer), userInfo: nil, repeats: true)
        }
        
        
    }
    
    @objc func watchTimer()
    {
        printE("Watch Timer \(timerLeft)")
        timerLeft -= 1
        
        if timerLeft <= 0
        {
            self.stopTimer()
            self.onClickBtnRight(btnRight as Any)
          
        }
        else
        {
          
            DispatchQueue.main.async
                { /*[unowned self] in*/
                    self.lblMessage.text = String(format: "%ds",self.timerLeft)
            }
            
        }
        
    }
    func stopTimer()
    {
        DispatchQueue.main.async
            { /*[unowned self] in*/
            
            self.timerSos?.invalidate()
            self.timerSos = nil
        }
        
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


