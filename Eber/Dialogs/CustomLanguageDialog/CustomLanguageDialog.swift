//
//  CustomTableDialog.swift
//  edelivery
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
class CustomLanguageDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate
{
    
    //MARK:- Outlets
   
    @IBOutlet var heightForContent: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblChangeLanguage: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    //MARK:- Variables
    var cellIdentifier = "cell"
    var onItemSelected : ((_ selectedItem:Int) -> Void)? = nil
    let selectedIndex = preferenceHelper.getLanguage()
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.themeOverlayColor
    }
    public static func  showCustomLanguageDialog() -> CustomLanguageDialog
    {
        let view = UINib(nibName: "dialogForCustomLanguage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomLanguageDialog
        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.clear
            , andCornerRadious: 10.0, borderWidth: 1.0)
        view.lblChangeLanguage.text = "TXT_CHANGE_LANGUAGE".localized
        
        view.lblChangeLanguage.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        view.lblChangeLanguage.textColor = UIColor.themeTextColor
        
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(CustomLanguageDialog.closeLanguageDialog))
        tapForOverlayLanguage.delegate = view
        view.heightForContent.constant = CGFloat(40 * arrForLanguages.count)
        view.addGestureRecognizer(tapForOverlayLanguage)
        return view;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.onItemSelected != nil
        {
            if selectedIndex == indexPath.row
            {
              closeLanguageDialog()
            }
            else
            {
            self.onItemSelected!(indexPath.row)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrForLanguages.count > 0
        {
            return arrForLanguages.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil
        {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = arrForLanguages[indexPath.row].language
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableForItems) == true
        {
            return false
        }
        return true
    }

    @objc func closeLanguageDialog()
    {
        self.removeFromSuperview();
    }
}
