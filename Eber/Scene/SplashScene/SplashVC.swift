//
//  SplashVC.swift
//  Store
//
//  Created by Disha Ladani on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SplashVC: BaseVC {

    @IBOutlet weak var splash: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        wsGetAppSetting()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        APPDELEGATE.setupIQKeyboard()
        UISwitch.appearance().tintColor = UIColor.themeSwitchTintColor
        UISwitch.appearance().onTintColor = UIColor.themeSwitchTintColor
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            GMSServices.provideAPIKey(Google.MAP_KEY);
            GMSPlacesClient.provideAPIKey(Google.MAP_KEY);
        }
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }

    //MARK: User Define Funtions
    func isUpdateAvailable(_ latestVersion: String) -> Bool
    {
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let myCurrentVersion: [String] = currentAppVersion.components(separatedBy: ".")
        let myLatestVersion: [String] = latestVersion.components(separatedBy: ".")
        let legthOfLatestVersion: Int = myLatestVersion.count
        let legthOfCurrentVersion: Int = myCurrentVersion.count
        if legthOfLatestVersion == legthOfCurrentVersion
        {
            for i in 0..<myLatestVersion.count
            {
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                }
                else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                }
                else
                {
                    return false
                }
            }
            return false
        }
        else
        {
            let count: Int = legthOfCurrentVersion > legthOfLatestVersion ? legthOfLatestVersion : legthOfCurrentVersion
            for i in 0..<count
            {
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                }
                else if CInt(myCurrentVersion[i])! > CInt(myLatestVersion[i])! {
                    return false
                }
                else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                }
            }
            if legthOfCurrentVersion < legthOfLatestVersion {
                for i in legthOfCurrentVersion..<legthOfLatestVersion {
                    if CInt(myLatestVersion[i]) != 0
                    {
                        return true
                    }
                }
                return false
            }
            else {
                return false
            }
        }
    }
    
    func checkLogin()
    {
        if preferenceHelper.getSessionToken().isEmpty()
        {
            APPDELEGATE.gotoLogin()
        }
        else
        {
            if !(CurrentTrip.shared.user.isReferral == TRUE) && CurrentTrip.shared.user.countryDetail.isReferral
            {
                if let referralVC:ReferralVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "ReferralVC") as? ReferralVC
                {
                    self.present(referralVC, animated: true, completion: {
                    });
                    
                }
            }
            else if (CurrentTrip.shared.user.isDocumentUploaded == FALSE)
            {
                APPDELEGATE.gotoDocument()
            }
            else
            {
                CurrentTrip.shared.tripId = CurrentTrip.shared.user.tripId
                if CurrentTrip.shared.user.isProviderAccepted == TRUE
                {
                    //CurrentTrip.shared.tripStaus.trip.providerId = CurrentTrip.shared.user.providerId
                    APPDELEGATE.gotoTrip()
                    
                }
                else
                {
                    APPDELEGATE.gotoMap()
                }
            }
            
        }
    }


}
//MARK: Web Service Calls
extension SplashVC
{
    func  wsGetAppSetting(){
        
        let afh:AlamofireHelper = AlamofireHelper()
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
      
        
        let dictParam : [String : Any] =
            [ PARAMS.USER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.DEVICE_TYPE : CONSTANT.IOS,
              PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
              PARAMS.APP_VERSION: currentAppVersion]
        
        
        
        afh.getResponseFromURL(url: WebService.GET_USER_SETTING_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if (error != nil)
            {
                self.openServerErrorDialog()
            }
            else
            {
                
                if Parser.parseAppSettingDetail(response: response)
                {
                    if self.isUpdateAvailable(preferenceHelper.getLatestVersion())
                    {
                        self.openUpdateAppDialog(isForceUpdate: preferenceHelper.getIsRequiredForceUpdate())
                    }
                    else
                    {
                        self.checkLogin()
                    }
                    
                }
                
            }
        }
    }
 }

//MARK:- Dialogs
extension SplashVC
{
    func openUpdateAppDialog(isForceUpdate:Bool)
    {
        if isForceUpdate
        {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_UPDATE".localized)
            dialogForUpdateApp.onClickLeftButton =
                { [/*unowned self,*/ unowned dialogForUpdateApp] in
                    dialogForUpdateApp.removeFromSuperview();
                    exit(0)
                    
            }
            dialogForUpdateApp.onClickRightButton =
                { [/*unowned self,*/ unowned dialogForUpdateApp] in
                    if let url = URL(string: CONSTANT.UPDATE_URL),
                        UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                    dialogForUpdateApp.removeFromSuperview()
                }
            
        }
        else
        {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_UPDATE".localized)
            dialogForUpdateApp.onClickLeftButton =
                { [unowned self, unowned dialogForUpdateApp] in
                    dialogForUpdateApp.removeFromSuperview();
                    self.checkLogin()
            }
            dialogForUpdateApp.onClickRightButton =
                { [unowned self, unowned dialogForUpdateApp] in
                    if let url = URL(string: CONSTANT.UPDATE_URL),
                        UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                    printE(self)
                    dialogForUpdateApp.removeFromSuperview()
            }
            
            
        }
        
        
    }
    func openServerErrorDialog(){
        let dialogForServerError = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_SERVER_ERROR".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_RETRY".localized)
        dialogForServerError.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview();
                exit(0)
                
        }
        dialogForServerError.onClickRightButton =
            { [unowned self, unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview();
                self.wsGetAppSetting()
        }
    }
    func openPushNotificationDialog()
    {
        let dialogForPushNotification = CustomAlertDialog.showCustomAlertDialog(title: "TXT_PUSH_ENABLE".localized, message: "MSG_PUSH_ENABLE".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "".localized)
        dialogForPushNotification.onClickLeftButton =
            { [/*unowned self,*/ unowned dialogForPushNotification] in
                dialogForPushNotification.removeFromSuperview();
                exit(0)
        }
        dialogForPushNotification.onClickRightButton =
            { [/*unowned self,*/ unowned dialogForPushNotification] in
                dialogForPushNotification.removeFromSuperview();
        }
        
    }
}
