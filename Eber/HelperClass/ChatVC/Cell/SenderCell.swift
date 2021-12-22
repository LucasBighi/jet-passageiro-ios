//
//  SenderCell.swift
//  Qatch Driver
//
//  Created by Sakir Sherasiya on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet var viewForMessage: UIView!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet weak var lblRead: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMessage.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblTime.font = FontHelper.font(size: FontSize.small, type: .Regular)
        viewForMessage.backgroundColor = UIColor.themeSenderBGColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblMessage.textColor = UIColor.themeTextColor
        
        lblRead.font = FontHelper.font(size: FontSize.small, type: .Regular)
        lblRead.textColor = UIColor.themeLightTextColor
        lblRead.isHidden = true
        lblRead.text = "TXT_READ".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellData(dict:FirebaseMessage)
    {
        lblMessage.text = dict.message
        lblTime.text = Utility.stringToString(strDate: dict.time, fromFormat: DateFormat.WEB, toFormat: DateFormat.MESSAGE_FORMAT)
        viewForMessage.layer.cornerRadius = 15.0
        viewForMessage.clipsToBounds = true
        if (dict.isRead) == true
        {
            lblRead.isHidden = false
        }
        else
        {
            lblRead.isHidden = true
        }
        
    }
}
