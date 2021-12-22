//
//  ProviderLanguageCell.swift
//  Cabtown
//
//  Created by Elluminati  on 17/09/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class ProviderLanguageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   @IBOutlet weak var languageName:UIButton!
    @IBOutlet weak var lblLanguageName:UILabel!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellData(data:Language)
    {
        lblLanguageName.textColor = UIColor.themeTextColor
        lblLanguageName.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        languageName.setTitle(FontAsset.icon_check_box_normal, for: .normal)
        languageName.setTitle(FontAsset.icon_check_box_selected, for: .selected)
        languageName.setSimpleIconButton()
        
        lblLanguageName.text =  data.name
        languageName.isSelected = data.isSelected
    }

}
