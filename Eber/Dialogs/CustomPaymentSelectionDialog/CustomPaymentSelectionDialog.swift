//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomPaymentSelectionDialog: CustomDialog
{
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    
    @IBOutlet weak var viewForCard: UIView!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    
    @IBOutlet weak var viewForCash: UIView!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var lblCash: UILabel!
    
    @IBOutlet weak var dividerColor: UIView!
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lblIconCard: UILabel!
    @IBOutlet weak var lblIconCash: UILabel!
    //MARK:Variables
    var onClickCashButton : (() -> Void)? = nil
    var onClickCardButton : (() -> Void)? = nil
    static let  verificationDialog = "CustomPaymentSelectionDialog"
    
    
    
    public static func  showCustomPaymentSelectionDialog() ->
        CustomPaymentSelectionDialog
    {
        
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPaymentSelectionDialog
        
        view.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.viewForCard.isHidden = CurrentTrip.shared.isCardModeAvailable == FALSE
        view.viewForCash.isHidden =  CurrentTrip.shared.isCashModeAvailable == FALSE
        view.setLocalization()
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    }
    
    func setLocalization(){
        self.lblCard.text = "TXT_CARD".localized
        self.lblCard.textColor = UIColor.themeTextColor
        lblCard.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        self.lblCash.text = "TXT_CASH".localized
        self.lblCash.textColor = UIColor.themeTextColor
        lblCash.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        self.alertView.setShadow()
        dividerColor.backgroundColor = UIColor.themeLightDividerColor
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        self.lblIconCard.text = FontAsset.icon_payment_card
        self.lblIconCash.text = FontAsset.icon_payment_cash
        self.lblIconCash.setForIcon()
        self.lblIconCard.setForIcon()
    }
    
    //ActionMethods
    
    @IBAction func onClickBtnCash(_ sender: Any)
    {
        self.removeFromSuperview()
        if self.onClickCashButton != nil
        {
            self.onClickCashButton!();
        }
    }
    @IBAction func onClickBtnCard(_ sender: Any)
    {
        self.removeFromSuperview()
        if self.onClickCardButton != nil
        {
            self.onClickCardButton!()
        }
        
    }
    
}


