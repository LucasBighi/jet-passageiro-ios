//
//  WalletHistoryDetailVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 03/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

import UIKit

class WalletHistoryDetailVC: BaseVC {
    
    
    weak var walletDetail:WalletHistoryItem? = nil
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var lblWalletRequestId: UILabel!
    @IBOutlet weak var lblWalletREquestDate: UILabel!
    
    
    
    
    @IBOutlet weak var viewForCurrentRate: UIView!
    @IBOutlet weak var lblCurrentRate: UILabel!
    @IBOutlet weak var lblCurrentRateValue: UILabel!
    
    
    @IBOutlet weak var lblAmountTag: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAamountValue: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setLocalization()
        
        
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
    }
    
    //MARK:
    //MARK: Set localized layout
    
    func setLocalization()
    {
        
        //Set Color
        lblAmount.textColor = UIColor.themeLightTextColor
        lblTotalAmount.textColor = UIColor.themeLightTextColor
        lblCurrentRate.textColor = UIColor.themeLightTextColor
        lblWalletRequestId.textColor = UIColor.themeTextColor
        lblWalletREquestDate.textColor = UIColor.themeLightTextColor
        lblTotalAamountValue.textColor = UIColor.themeTextColor
        lblCurrentRateValue.textColor = UIColor.themeTextColor
        lblDescription.textColor = UIColor.themeTextColor
        
        //Set Font
        
        lblWalletRequestId.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblWalletREquestDate.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        
        
        lblAmount.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblAmountTag.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTotalAmount.font = FontHelper.font(size: FontSize.regular , type: FontType.Regular)
        lblCurrentRate.font = FontHelper.font(size: FontSize.regular , type: FontType.Regular)
        
        lblTotalAamountValue.font = FontHelper.font(size: FontSize.medium , type: FontType.Bold)
        lblCurrentRateValue.font = FontHelper.font(size: FontSize.medium , type: FontType.Bold)
        lblDescription.font = FontHelper.font(size: FontSize.regular , type: FontType.Regular)
        
        
        //Set Text
        lblTotalAmount.text = "TXT_TOTAL_WALLET_AMOUNT".localized
        lblCurrentRate.text = "TXT_CURRENT_RATE".localized
        
        let walletHistoryStatus:WalletHistoryStatus = WalletHistoryStatus(rawValue: walletDetail!.walletCommentId) ?? .Unknown;
        
        lblTitle.text = walletHistoryStatus.text()
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        btnBack.setupBackButton()    
    }
    
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupLayout()
    {
        self.setWalletData()
         navigationView.navigationShadow()
        
    }
    func setWalletData()
    {
        if let walletRequestData = walletDetail
        {
            lblWalletRequestId.text =  "  " +  "TXT_ID".localized +  String(walletRequestData.uniqueId) +  "  "
            
            lblWalletREquestDate.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_TIME_FORMAT)
            
            lblDescription.text = walletRequestData.walletDescription
            
            lblTotalAamountValue.text = String(walletRequestData.totalWalletAmount) + " " + walletRequestData.fromCurrencyCode
            
            
            
            switch (walletRequestData.walletStatus)
            {
            case WalletStatus.ADD_WALLET_AMOUNT: fallthrough
            case WalletStatus.ORDER_REFUND_AMOUNT: fallthrough
            case WalletStatus.ORDER_PROFIT_AMOUNT:
                lblAmount.textColor = UIColor.themeWalletAddedColor
                lblAmountTag.text = "TXT_AMOUNT_ADDED".localized
                lblAmount.text =  "+" +
                    String(walletDetail?.addedWallet ?? 0.0) + " " + (walletDetail?.toCurrencyCode)!
                lblTotalAamountValue.text =   String(walletDetail?.totalWalletAmount ?? 0.0) + " " +  (walletDetail?.toCurrencyCode)!
                break;
            case WalletStatus.REMOVE_WALLET_AMOUNT:fallthrough
            case WalletStatus.ORDER_CHARGE_AMOUNT:fallthrough
            case WalletStatus.ORDER_CANCELLATION_CHARGE_AMOUNT:fallthrough
            case WalletStatus.REQUEST_CHARGE_AMOUNT:
                lblAmount.textColor = UIColor.themeWalletDeductedColor
                lblAmountTag.text = "TXT_AMOUNT_DEDUCTED".localized
                lblAmount.text =  "-" + String(walletDetail?.addedWallet ?? 0.0) + " " + (walletDetail?.fromCurrencyCode)!
                lblTotalAamountValue.text =   String(walletDetail?.totalWalletAmount ?? 0.0) + (walletDetail?.fromCurrencyCode)!
               break;
            default:
                break;
            }
            
            if (walletRequestData.currentRate == 1.0)
            {
                viewForCurrentRate.isHidden = true
            } else
            {
                viewForCurrentRate.isHidden = false
                lblCurrentRateValue.text =  "1 " + walletRequestData.fromCurrencyCode + " (" +  String(format: "%.4f", arguments: [walletRequestData.currentRate]) + " " + walletRequestData.toCurrencyCode + ")"
                
            }
            
           
        }
    }
}

