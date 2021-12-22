//
//  EPContactCell.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 13/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class EmergencyContactCell: UITableViewCell
{

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblShareDetail: UILabel!
    @IBOutlet weak var swForShareDetail: UISwitch!
    
    
    var contact: EPContact?
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCell.SelectionStyle.none
       
        lblName.textColor = UIColor.themeLightTextColor
        lblName.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblPhoneNumber.textColor = UIColor.themeLightTextColor
        lblPhoneNumber.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblShareDetail.textColor = UIColor.themeTextColor
        lblShareDetail.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblShareDetail.text = "TXT_SHARE_YOUR_RIDE".localized
        btnDelete.setTitle(FontAsset.icon_cross_rounded, for: .normal)
        btnDelete.setSimpleIconButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:EmergencyContactData)
    {
        
        lblName.text = data.name
        lblPhoneNumber.text = data.phone
        swForShareDetail.isOn = data.isAlwaysShareRideDetail == TRUE
        
    }
   
}
