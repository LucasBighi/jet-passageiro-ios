//
//  HistoryCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var walleBackView: UIView!
    
    @IBOutlet weak var lblRequestId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*Set Font*/
        lblAmount.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblStatus.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTime.font =  FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblRequestId.font =  FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        /*Set Color*/
        
        lblRequestId.textColor = UIColor.themeLightTextColor
        lblAmount.textColor = UIColor.themeTextColor
        lblStatus.textColor = UIColor.themeTextColor
        lblTime.textColor = UIColor.themeLightTextColor
        
        self.walleBackView.backgroundColor = UIColor.themeWalletBGColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }

    func setWalletHistoryData(walletRequestData: WalletHistoryItem)
    {
        lblRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
        lblTime.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_TIME_FORMAT)

        let walletHistoryStatus:WalletHistoryStatus = WalletHistoryStatus(rawValue: walletRequestData.walletCommentId) ?? .Unknown;

        lblStatus.text = walletHistoryStatus.text()
        switch (walletRequestData.walletStatus)
        {
        case WalletStatus.ADD_WALLET_AMOUNT: fallthrough
        case WalletStatus.ORDER_REFUND_AMOUNT: fallthrough
        case WalletStatus.ORDER_PROFIT_AMOUNT:
            lblAmount.textColor = UIColor.themeWalletAddedColor
            lblAmount.text = "+"  +  String(walletRequestData.addedWallet) + " " + walletRequestData.toCurrencyCode
            lblDivider.backgroundColor = UIColor.themeWalletAddedColor
            break;
        case WalletStatus.REMOVE_WALLET_AMOUNT:fallthrough
        case WalletStatus.ORDER_CHARGE_AMOUNT:fallthrough
        case WalletStatus.ORDER_CANCELLATION_CHARGE_AMOUNT:fallthrough
        case WalletStatus.REQUEST_CHARGE_AMOUNT:
            
            lblAmount.textColor = UIColor.themeWalletDeductedColor
            lblAmount.text = "-"  +  String(walletRequestData.addedWallet) + " " + walletRequestData.fromCurrencyCode
            
            lblDivider.backgroundColor = UIColor.themeWalletDeductedColor
            break;
        default:
            break;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

final class PaddedLabel: UILabel
{
    var padding: UIEdgeInsets?
    
    override func draw(_ rect: CGRect) {
        if let insets = padding {
            
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }}

