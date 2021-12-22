//
//  ContactUsVC.swift
//  Cabtown
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ContactUsVC: BaseVC
{
   
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContactUsMessage: UILabel!
    
    @IBOutlet weak var lblIconContact: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    //@IBOutlet weak var lblAdminCountryPhoneCode: UILabel!
    @IBOutlet weak var lblAdminContact: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblIconCall: UILabel!
    @IBOutlet weak var lblIconEmail: UILabel!
    
    
//MARK: View life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        
     }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
     }
   
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
    }
    
    func initialViewSetup()
    {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
      
        
        lblTitle.text = "TXT_CONTACT_US".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
     
        lblContactUsMessage.font = FontHelper.font(size: FontSize.large
            , type: FontType.Light)
        
        lblContactUsMessage.textColor = UIColor.themeTextColor
        lblContactUsMessage.text = "TXT_CONTACT_US_MSG".localized
        
       
        
        lblEmailAddress.text =  preferenceHelper.getContactEmail()
        lblEmailAddress.font = FontHelper.font(size: FontSize.regular
            , type: FontType.Light)
        lblEmailAddress.textColor = UIColor.themeTextColor
        
        
        lblAdminContact.font = FontHelper.font(size: FontSize.regular
            , type: FontType.Light)
        lblAdminContact.textColor = UIColor.themeTextColor
        
        let adminContact = preferenceHelper.getContactNumber()
            lblAdminContact.text = adminContact
        lblIconCall.text = FontAsset.icon_call
        lblIconEmail.text = FontAsset.icon_message
        lblIconContact.text = FontAsset.icon_contact
        
        
        lblIconCall.setForIcon()
        lblIconEmail.setForIcon()
        lblIconContact.setForIcon()
        
        btnBack.setupBackButton()    
   }
    @IBAction func onClickBtnMenu(_ sender: Any)
    {
        
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func onClickBtnTerms(_ sender: UIButton) {
        guard let url = URL(string: preferenceHelper.getTermsAndCondition()) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func onClickBtnPrivacy(_ sender: Any) {
        guard let url = URL(string: preferenceHelper.getPrivacyPolicy()) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func onClickbtnCall(_ sender: Any)
    {
         let adminMobileNumber =  preferenceHelper.getContactNumber()
        if adminMobileNumber.isEmpty
        {
            Utility.showToast(message: "VALIDATION_MSG_UNABLE_TO_CALL".localized)
        }
        else
        {
            if let url = URL(string: "tel://\(adminMobileNumber)"), UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                }
                else {
                UIApplication.shared.openURL(url)
                }
            }
            else
            {
                Utility.showToast(message: "VALIDATION_MSG_UNABLE_TO_CALL".localized)
            }
        }
    }
    @IBAction func onClickBtnMail(_ sender: Any) {
        let email = preferenceHelper.getContactEmail()
        if let url = URL(string: "mailto://\(email)"), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else
        {
            Utility.showToast(message: "VALIDATION_MSG_UNABLE_TO_MAIL".localized)
        }
    }
    
//MARK:
//MARK: Button action methods
  
   
}
