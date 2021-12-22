//
//  SearchViewController.swift
//  PullUpControllerDemo
//
//  Created by Mario on 03/11/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit
import MapKit


class AppPromotionVC: BaseVC {
    
    @IBOutlet weak var navigaitonView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    // MARK: - Lifecycle
    @IBOutlet weak var viewForApp: UIView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var lblAppDescription: UILabel!
    
    @IBOutlet weak var btnGetApp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigaitonView.navigationShadow()
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    func initialViewSetup()
    {
        lblTitle.text = "TXT_APP_PROMOTION_NAME".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblAppName.text = "TXT_APP_PROMOTION_NAME".localizedCapitalized
        lblAppName.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblAppName.textColor = UIColor.themeTextColor
        
        
        
        
        
        lblAppDescription.text = "TXT_APP_PROMOTION_DESCRIPTION".localized
        lblAppDescription.font = FontHelper.font(size: FontSize.regular
            , type: FontType.Regular)
        lblAppDescription.textColor = UIColor.themeLightTextColor
        
        btnGetApp.setTitle("TXT_GET_APP".localizedCapitalized, for: .normal)
        btnGetApp.titleLabel?.font = FontHelper.font(size: FontSize.regular
            , type: FontType.Regular)
        btnGetApp.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnGetApp.backgroundColor = UIColor.themeButtonBackgroundColor
        btnGetApp.setRound(withBorderColor: .clear, andCornerRadious: 20, borderWidth: 1.0)
        btnBack.setupBackButton()}
    @IBAction func onClickBtnGetApp(_ sender: Any) {
        
     openApp()
    }
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1276529954"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    printE("App Store Opened")
                }
            }
        } else {
            printE("Can't Open URL on Simulator")
        }
    }
    func openApp() {

        let appScheme = "edelivery://"
        let appUrl = URL(string: appScheme)
        
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            UIApplication.shared.open(appUrl!)
            
        } else {
           openAppStore()
        }
        
    }
}

