//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomTipDialog: CustomDialog
{
   //MARK:- OUTLETS
    /*Dialog For Tip*/
    
    @IBOutlet weak var viewForInvoice: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTipTimer: UILabel!
    @IBOutlet weak var txtTipAmount: ACFloatingTextfield!
    @IBOutlet weak var lblInvoice: UILabel!
    
    
    @IBOutlet weak var lblReferralBonus: UILabel!
    @IBOutlet weak var lblReferralBonousValue: UILabel!
    
    @IBOutlet weak var lblPromoBonous: UILabel!
    @IBOutlet weak var lblPromoBonousValue: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPaymentValue: UILabel!
    
   
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    var timerLeft:Int = 30
    //MARK:Variables
     var onClickRightButton : ((_ tipAmount:Double ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForTip"
    weak var timerForTip:Timer? = nil
    
    
    public static func  showCustomTipDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String, 
         tag:Int = 102
         ) ->
        CustomTipDialog
     {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTipDialog
        if let view = (APPDELEGATE.window?.viewWithTag(102))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
            view.tag = tag
            view.alertView.setShadow()
            view.alertView.backgroundColor = UIColor.white
            view.backgroundColor = UIColor.themeOverlayColor
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
            view.lblTitle.text = title;
            
            view.lblTipTimer.text = message;
            view.setLocalization()
            view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
            view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
            
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
            
            view.btnLeft.isHidden =  titleLeftButton.isEmpty()
            view.btnRight.isHidden =  titleRightButton.isEmpty()
            view.lblTitle.isHidden = title.isEmpty()
            view.setData()
            view.startTimer()
        }
        return view;
    }
    
    func setData()
    {
        if let trip = CurrentTrip.shared.tripStaus.trip
        {
            self.lblReferralBonousValue.text =  trip.referralPayment.toCurrencyString(currencyCode: trip.currencycode)
            self.lblPromoBonousValue.text = trip.promoPayment.toCurrencyString(currencyCode: trip.currencycode)
           
            self.lblPaymentValue.text = trip.total.toCurrencyString(currencyCode: trip.currencycode)
            if trip.tripType == TripType.ZONE || trip.tripType == TripType.CITY || trip.tripType == TripType.AIRPORT
            {
                 self.lblTotalValue.text = trip.tripTypeAmount.toCurrencyString(currencyCode: trip.currencycode)
            }
            else
            {
                self.lblTotalValue.text =  trip.totalAfterSurgeFees.toCurrencyString(currencyCode: trip.currencycode)
                
            }
        }
    }
    func setLocalization(){
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTitleColor
        lblTipTimer.textColor = UIColor.themeTextColor
         btnRight.setupButton()
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTipTimer.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    func startTimer()
    {
        self.timerLeft = CurrentTrip.shared.tripStaus.timeLeftForTip
        self.watchTimer()
        DispatchQueue.main.async { [unowned self/*, weak timer = self.timerForTip*/] in
            self.timerForTip?.invalidate()
            self.timerForTip = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.watchTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func watchTimer()
    {
        printE("Watch Timer \(timerLeft)")
        timerLeft -= 1
        if timerLeft <= 0
        {
            self.stopTimer()
            self.onClickBtnLeft(btnLeft as Any)
        }
        else
        {
            DispatchQueue.main.async
            { [weak self] in
                guard let self = self else {
                    return
                }
                self.lblTipTimer?.text = String(format: "%ds",self.timerLeft)
            }
        }
    }

    func stopTimer()
    {
        DispatchQueue.main.async
        { /*[unowned self, weak timer = self.timerForTip] in*/
            [weak self, weak timer = self.timerForTip] in
            guard let self = self else {
                return
            }
            self.timerForTip?.invalidate()
            self.timerForTip = nil
        }
    }

    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any)
    {
        if self.onClickLeftButton != nil
        {
            self.stopTimer()
            self.onClickLeftButton!();
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any)
    {
        if (txtTipAmount.text ?? "").toDouble() != 0.0
        {
            if self.onClickRightButton != nil
            {
                self.stopTimer()
                self.onClickRightButton!((txtTipAmount.text ?? "").toDouble())
            }
        }
        else
        {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_AMOUNT".localized)
        }
    }
}
