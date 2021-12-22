//
//  CustomRentCarDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit




class CustomDriverDetailCell:UITableViewCell
{
    @IBOutlet var imgProfilePic: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNameValue: UILabel!
    @IBOutlet var btnRemoveDriver: UIButton!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        
        lblName.textColor = UIColor.themeTextColor
        
        lblName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblNameValue.textColor = UIColor.themeTextColor
        lblNameValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnRemoveDriver.setSimpleIconButton()
        
    }
    func setData(data:Provider)
    {
        lblNameValue.text = data.firstName + " " + data.lastName
        imgProfilePic.downloadedFrom(link: data.picture)
        imgProfilePic.setRound()
    }
}
