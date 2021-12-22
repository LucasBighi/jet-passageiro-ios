//
//  BeDriverVC.swift
//  JET
//
//  Created by Lucas Marques Bighi on 10/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class BeDriverVC: BaseVC {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnShare: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setupBackButton()
        lblTitle.text = "TXT_BE_DRIVER".localized
        messageLabel.text = "TXT_BE_DRIVER_DESC".localized
        messageLabel.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnShare.setTitle("   " + "TXT_DOWNLOAD_APP".localized + "   ", for: .normal)
        btnShare.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnShare.backgroundColor = UIColor.themeButtonBackgroundColor
        btnShare.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
        btnShare.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
    }
    
    @IBAction func onClickBtnShare(_ sender: Any) {
        let myString = "MSG_SHARE_REFERRAL".localized + CurrentTrip.shared.user.referralCode

        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
     }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.popToRootViewController(animated: true)
    }

}
