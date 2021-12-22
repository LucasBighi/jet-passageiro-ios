//
//  JETamigoCell.swift
//  Edelivery
//
//   Created by Ellumination 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class JETamigoCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        /*Set Font*/
        lblName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblName.textColor = UIColor.themeTextColor
        
        lblLevel.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblLevel.textColor = UIColor.themeLightTextColor
        lblLevel.textAlignment = .right
        
        lblMessage.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblMessage.textColor = UIColor.themeTextColor
        
        lblDate.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        lblDate.textColor = UIColor.themeLightTextColor

        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }

    func setHistoryData(data: JETAmigoReferral) {
        lblName.text = data.username
        lblLevel.text = "Nível \(data.entryLevel!)"
        lblMessage.text = data.message
        let date = Utility.stringToString(strDate: data.stringDate,
                                          fromFormat: DateFormat.WEB,
                                          toFormat: DateFormat.DATE_DD_MON_YYYY)
        lblDate.text = "Entrou em: \(date)"
    }
}


