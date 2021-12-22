//
//  AutoCompleteCell.swift
//  
//
//  Created by Elluminati  on 18/09/18.
//

import UIKit

class AutocompleteCell: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewForAutocomplete: UIView!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblIconLocation: UILabel!
    
    //MARK:- LIFECYCLE
    
    deinit {
        printE("\(self) \(#function)")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setLocalization()
        
    }
    //MARK:- SET CELL DATA
    func setCellData(place:(title:String,subTitle:String,address:String,placeid:String))
    {
        lblTitle.text = place.title
        lblSubTitle.text = place.subTitle
    }
    func setLocalization()
    {
        //Colors
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAutocomplete.backgroundColor = UIColor.white
        lblDivider.backgroundColor = UIColor.themeDividerColor
        
        lblTitle.textColor = UIColor.themeTitleColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        /*Set Font*/
        lblTitle.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblSubTitle.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        self.lblIconLocation.text = FontAsset.icon_location
        
        self.lblIconLocation.setForIcon()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    
}
