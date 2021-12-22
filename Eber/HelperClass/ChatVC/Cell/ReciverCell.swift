//
//  ReciverCell.swift
//  Qatch Driver
//
//  Created by Sakir Sherasiya on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit

class ReciverCell: UITableViewCell {

    @IBOutlet var viewForMessage: UIView!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMessage.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblTime.font = FontHelper.font(size: FontSize.small, type: .Regular)
        viewForMessage.backgroundColor = UIColor.themeReceiverBGColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblMessage.textColor = UIColor.themeTextColor
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
    }
    
}
