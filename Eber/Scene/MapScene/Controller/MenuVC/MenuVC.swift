//
//  ViewController.swift
//  newt
//
//  Created by Elluminati  on 10/07/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

//let font_right_arrow = "→"
//let font_left_arrow = "←"

let color_18556B = UIColor(red: 24.0/255.0, green: 85.0/255.0, blue: 107.0/255.0, alpha: 1.0)

class MenuVC: BaseVC {
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!

    var arrForMenu: [(String,String)] = [
        ("TXT_PROFILE".localized,"asset-menu-profile"),
        ("TXT_PAYMENTS".localized,"asset-menu-payments"),
        ("TXT_REFERRAL".localized,"asset-menu-referral"),
        ("TXT_JETAMIGO".localized,"asset-menu-jetamigo"),
        ("TXT_JETANJO".localized,"asset-menu-jetanjo"),
        ("TXT_JETFAVORITO".localized,"asset-menu-jetfavorito"),
        ("TXT_MY_BOOKINGS".localized,"asset-menu-booking"),
        ("TXT_HISTORY".localized,"asset-menu-history"),
        ("TXT_SETTINGS".localized,"asset-menu-setting"),
        ("TXT_CONTACT_US".localized,"asset-menu-contact-us")
    ]

    let user = CurrentTrip.shared.user

//    var arrForMenu: [(String, String)] = [
//        ("TXT_PROFILE".localized, FontAsset.icon_menu_profile),
//        ("TXT_PAYMENTS".localized, FontAsset.icon_payment_card),
//        //Jet Cash
//        //Jet Amigo
//        //Jet Anjo
//        ("TXT_FAVOURITE_DRIVER".localized, FontAsset.icon_favourite),
//        ("TXT_MY_BOOKINGS".localized, FontAsset.icon_menu_my_booking),
//        ("TXT_HISTORY".localized, FontAsset.icon_wallet_history),
//        ("TXT_DOCUMENTS".localized, FontAsset.icon_document),
//        ("TXT_REFERRAL".localized, FontAsset.icon_menu_referral),
//        ("TXT_SETTINGS".localized, FontAsset.icon_menu_setting),
//        ("TXT_CONTACT_US".localized, FontAsset.icon_help)
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }

    override func viewDidLayoutSubviews(){
       super.viewDidLayoutSubviews()
        userImageView.setRound()
    }
    
    func initialViewSetup() {
        self.view.backgroundColor = UIColor.clear
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfileVC)))
        setProfileData()
        setupTableView()
    }

    func setProfileData() {
        userNameLabel.text = user.firstName

        if !user.picture.isEmpty {
            userImageView.downloadedFrom(link: user.picture)
        }
    }

    @objc private func showProfileVC() {
        self.revealViewController()?.revealLeftView()
        let navigationVC = revealViewController()?.mainViewController as? UINavigationController
        navigationVC?.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.revealViewController()?.revealLeftView()
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuTableViewCell else { return UITableViewCell() }
        cell.setup(item: arrForMenu[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.revealViewController()?.revealLeftView()

        if let navigationVC: UINavigationController = revealViewController()?.mainViewController as? UINavigationController {
            switch indexPath.row {
            case 0:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
            case 1:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
            case 2:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_JETCASH, sender: self)
            case 3:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_JETAMIGO, sender: self)
            case 4:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_JETANJO, sender: self)
            case 5:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_FAVOURITE_DRIVER, sender: self)
            case 6:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_MY_BOOKING, sender: self)
            case 7:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_HISTORY, sender: self)
            case 8:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SETTING, sender: self)
            case 9:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
            default:
                printE("under development")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

public extension UIViewController {
    func clearPBRevealVC() {
        if let vC = APPDELEGATE.window?.rootViewController {
            if vC.isKind(of: PBRevealViewController.classForCoder()) {
                let pbrVC = vC as! PBRevealViewController
                pbrVC.delegate = nil
                
                pbrVC.tapGestureRecognizer?.delegate = nil
                pbrVC.panGestureRecognizer?.delegate = nil
                pbrVC.tapGestureRecognizer?.view?.removeGestureRecognizer(pbrVC.tapGestureRecognizer ?? UIGestureRecognizer())
                pbrVC.panGestureRecognizer?.view?.removeGestureRecognizer(pbrVC.tapGestureRecognizer ?? UIGestureRecognizer())
                
                pbrVC.mainViewController?.removeFromParent()
                pbrVC.mainViewController?.view.removeFromSuperview()
                pbrVC.leftViewController?.removeFromParent()
                pbrVC.leftViewController?.view.removeFromSuperview()
                
                pbrVC.leftViewController = UIViewController()
                pbrVC.mainViewController = UIViewController()                
            }
        }
    }
}
