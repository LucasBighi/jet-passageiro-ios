//
//  ShareReferralVC.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class ShareReferralVC: BaseVC
{
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var viewForReferral: UIView!
    @IBOutlet weak var lblReferralMsg: UILabel!

    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblTotalBalanceValue: UILabel!
    @IBOutlet weak var lblBalanceLevel1: UILabel!
    @IBOutlet weak var lblBalanceLevel1Value: UILabel!

    @IBOutlet weak var lblCashbackBalance: UILabel!
    @IBOutlet weak var lblCashbackBalanceValue: UILabel!

    @IBOutlet weak var lblBalanceLevel2: UILabel!
    @IBOutlet weak var lblBalanceLevel2Value: UILabel!

    @IBOutlet weak var lblYourReferralCode: UILabel!
    @IBOutlet weak var lblReferralCode: UILabel!

    @IBOutlet weak var lblBalanceLevel3: UILabel!
    @IBOutlet weak var lblBalanceLevel3Value: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialViewSetup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetReferralCredit()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
        viewForReferral.setRound(withBorderColor: UIColor.clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewForReferral.setShadow()
        
        btnShare.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialViewSetup() {
        lblTitle.text = "TXT_REFERRAL".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)

        lblTotalBalance.text = "TXT_TOTAL_BALANCE".localized
        lblTotalBalance.textColor = UIColor.themeTextColor
        lblTotalBalance.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        lblCashbackBalance.text = "TXT_CASHBACK_BALANCE".localized
        lblCashbackBalance.textColor = UIColor.themeTextColor
        lblCashbackBalance.font = FontHelper.font(size: FontSize.small, type: FontType.Light)
        
        lblYourReferralCode.text = "TXT_YOUR_REFERRAL_CODE".localized
        lblYourReferralCode.textColor = UIColor.themeTextColor
        lblYourReferralCode.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        lblBalanceLevel1.text = "TXT_AMOUNT_LEVEL_1".localized
        lblBalanceLevel1.textColor = UIColor.themeTextColor
        lblBalanceLevel1.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        lblBalanceLevel2.text = "TXT_AMOUNT_LEVEL_2".localized
        lblBalanceLevel2.textColor = UIColor.themeTextColor
        lblBalanceLevel2.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        lblBalanceLevel3.text = "TXT_AMOUNT_LEVEL_3".localized
        lblBalanceLevel3.textColor = UIColor.themeTextColor
        lblBalanceLevel3.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        lblReferralMsg.text = "TXT_SHARE_REFERRAL_MSG".localized
        lblReferralMsg.textColor = UIColor.themeTextColor
        lblReferralMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblReferralCode.text = CurrentTrip.shared.user.referralCode.uppercased()
        lblReferralCode.textColor = UIColor.themeTextColor
        lblReferralCode.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnShare.setTitle("   " + "TXT_SHARE_REFERRAL_CODE".localizedCapitalized + "   ", for: .normal)
        btnShare.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnShare.backgroundColor = UIColor.themeButtonBackgroundColor
        btnShare.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnBack.setupBackButton()
    }
    
    
    
    //MARK:- Action Methods
    
    @IBAction func onClickBtnShare(_ sender: Any) {
        
        let myString = "MSG_SHARE_REFERRAL".localized + CurrentTrip.shared.user.referralCode
        
        
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
     }
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController
        {
            navigationVC.popToRootViewController(animated: true)
        }
    }
    
    
}


extension ShareReferralVC {
    func wsGetReferralCredit() {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_USER_REFERAL_CREDIT,
                                   methodName: AlamofireHelper.POST_METHOD,
                                   paramData: dictParam) { response, error in
                if (error != nil) {
                    Utility.hideLoading()
                } else {
                    if Parser.isSuccess(response: response) {
                        self.lblTotalBalanceValue.text = self.format(response["total_referral_credit"])
                        self.lblCashbackBalanceValue.text = self.format(response["total_cashback_credit"])
                        self.lblBalanceLevel1Value.text = self.format(response["total_referral_father"])
                        self.lblBalanceLevel2Value.text = self.format(response["total_referral_grandfather"])
                        self.lblBalanceLevel3Value.text = self.format(response["total_referral_grandgrandfather"])

                        Utility.hideLoading()
                    }
                }
            }
    }

    private func format(_ value: Any?) -> String {
        return (value as? Double)?.toString() ?? "0.0"
    }
}
