//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomMonthYearPickerDialog: CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var datePicker: MonthYearPickerView!
    var month:String = "",year:String = ""
    //MARK:Variables
    var onClickRightButton : ((_ month:String ,_ year:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForMonthYearPicker"
    
    
    
    public static func  showCustomMonthPickerDialog
        (title:String,
         titleLeftButton:String,
         titleRightButton:String,
         mode:UIDatePicker.Mode = .date) ->
        CustomMonthYearPickerDialog
     {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMonthYearPickerDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.textColor = UIColor.themeTitleColor
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        
        view.month = String(format: "%02d", view.datePicker.month)
         view.year = String(format: "%02d", view.datePicker.year)
        
        view.datePicker.onDateSelected = { (month: Int, year: Int) in
            view.month = String(format: "%02d", month)
            view.year = String(format: "%02d", year)
            }
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    func setLocalization(){
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()
        btnLeft.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 30.0, borderWidth: 1.0)
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
            
            self.onClickRightButton!(month,year)
        }
        
    }
    
}


