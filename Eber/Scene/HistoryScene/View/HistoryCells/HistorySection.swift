//
//  historySectionCell.swift
//  Edelivery
//
//   Created by Elluminati on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistorySection: UITableViewCell {

   
    
    
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        roundedView.backgroundColor = UIColor.themeSelectionColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblSection.backgroundColor = UIColor.themeSelectionColor
        
    }
    
    func setData(title: String)
    
    {
        
        lblSection.text =  title
        roundedView.sizeToFit()
        roundedView.setRound(withBorderColor: .clear, andCornerRadious: (roundedView.frame.height/2), borderWidth: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
