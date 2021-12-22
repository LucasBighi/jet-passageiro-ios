//
//  AppDelegate.swift
//  Cabtown
//
//  Created by Elluminati  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import GooglePlaces
import IQKeyboardManagerSwift
import Fabric
import FirebaseCrashlytics
import Firebase
import FirebaseDatabase
import FirebaseMessaging

extension UIViewController {
    public func removeFromParentAndNCObserver() {
        for childVC in self.children {
            childVC.removeFromParentAndNCObserver()
        }
        
        if self.isKind(of: UINavigationController.classForCoder()) {
            (self as! UINavigationController).viewControllers = []
        }
        
        self.dismiss(animated: false, completion: nil)        
        self.view.removeFromSuperviewAndNCObserver()
        NotificationCenter.default.removeObserver(self)
        self.removeFromParent()
    }
}

extension UIView {
    public func removeFromSuperviewAndNCObserver() {
        for subvw in self.subviews {
            subvw.removeFromSuperviewAndNCObserver()
        }
        
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var reachability: Reachability?;
    var dialogForNetwork:CustomAlertDialog?;
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    private struct PUSH
    {
        static let  Approved = "215"
        static let  Declined = "216"
        static let  ProviderInitTrip = "217"
        static let  LoginAtAnother = "220"
        static let  ProviderComing = "200"
        static let  ProviderAcceptRequest = "203"
        static let  ProviderArrived = "204"
        static let  ProviderStartTrip = "206"
        static let  ProviderEndTrip = "209"
        static let  ProviderEndTripWithTip = "240"
        static let  ProviderNoProviderTrip = "213"
        static let  ProviderCancelTrip = "214"
        static let  CorporateRequest = "231"
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in

        }
        application.registerForRemoteNotifications()

        self.launchOptions = launchOptions
        Localizer.doTheMagic()
        setupNetworkReachability()
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyC8oPUp66DYkrqyvnx4VgpCUQ_J4pn7m5U")
        GMSServices.provideAPIKey("AIzaSyC8oPUp66DYkrqyvnx4VgpCUQ_J4pn7m5U")
        UIApplication.shared.isIdleTimerDisabled = true
        //UIApplication.shared.statusBarStyle = .lightContent
        //Override point for customization after application launch.

        Messaging.messaging().delegate = self
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }

    //MARK:Keyboard Setting
    func setupIQKeyboard()
    {
        IQKeyboardManager.shared.enableAutoToolbar = false
        UITextField.appearance().tintColor = UIColor.black;
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    }

    func gotoLogin()
    {
        //AlamofireHelper.manager.session.invalidateAndCancel()        
        AlamofireHelper.manager.session.cancelTasks {
            CurrentTrip.shared.clear()
            CurrentTrip.shared.clearTripData()
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = AppStoryboard.PreLogin.instance.instantiateInitialViewController() as? UINavigationController
            self.window?.makeKeyAndVisible()
        }
    }

    func gotoMap()
    {
        //AlamofireHelper.manager.session.invalidateAndCancel()
        AlamofireHelper.manager.session.cancelTasks { 
            self.setupPushNotification(UIApplication.shared, launchOptions: self.launchOptions)
            SocketHelper.shared.disConnectSocket()
            CurrentTrip.shared.clearTripData()
            let  pbrController = AppStoryboard.Map.instance.instantiateInitialViewController() as? PBRevealViewController
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = pbrController
            self.window?.makeKeyAndVisible()
            //printE("\(#function) \((self.window!.rootViewController as! PBRevealViewController))")
            //printE("\(#function) \((pbrController!.mainViewController as! UINavigationController).viewControllers)")
            //printE("\(#function) \(pbrController!.leftViewController ?? UIViewController())")
        }
    }

    func gotoDocument()
    {
        //AlamofireHelper.manager.session.invalidateAndCancel()
        AlamofireHelper.manager.session.cancelTasks { 
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "documentVC")
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func gotoTrip()
    {
        //AlamofireHelper.manager.session.invalidateAndCancel()
        AlamofireHelper.manager.session.cancelTasks { 
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "MainNavController")
            let leftViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "LeftMenuController")
            let tripViewController = AppStoryboard.Trip.instance.instantiateInitialViewController()!
            (mainViewController as! UINavigationController).viewControllers = [tripViewController]
            let revealViewController = PBRevealViewController(leftViewController: leftViewController, mainViewController: mainViewController)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = revealViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func gotoInvoice()
    {
        //AlamofireHelper.manager.session.invalidateAndCancel()
        SocketHelper.shared.disConnectSocket()
        AlamofireHelper.manager.session.cancelTasks { 
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "MainNavController")
            let leftViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "LeftMenuController")
            let invoiceVC = AppStoryboard.Trip.instance.instantiateViewController(withIdentifier: "invoiceVC")
            (mainViewController as! UINavigationController).viewControllers = [invoiceVC]
            let revealViewController = PBRevealViewController(leftViewController: leftViewController, mainViewController: mainViewController)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = revealViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func setupNetworkReachability()
    {
        self.reachability = Reachability.init();
        do
        {
            try self.reachability?.startNotifier()
        }
        catch
        {
            printE(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
    }

    func openNetworkDialog ()
    {
        dialogForNetwork  = CustomAlertDialog.showCustomAlertDialog(title: "TXT_INTERNET".localized, message: "MSG_INTERNET_ENABLE".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_OK".localized)

        self.dialogForNetwork!.onClickLeftButton =
            { [unowned self, weak dialogForNetwork = self.dialogForNetwork] in
                self.dialogForNetwork!.removeFromSuperview()
                self.dialogForNetwork = nil
                dialogForNetwork = nil
                printE(dialogForNetwork ?? "")
                exit(0)
        }
        self.dialogForNetwork!.onClickRightButton =
            { [unowned self, weak dialogForNetwork = self.dialogForNetwork] in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    self.dialogForNetwork?.removeFromSuperview()
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            
                        })
                    } else
                    {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
                self.dialogForNetwork?.removeFromSuperview();
                self.dialogForNetwork = nil
                dialogForNetwork = nil
                printE(dialogForNetwork ?? "")
        }
    }

    @objc func reachabilityChanged(note: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            let reachability = note.object as! Reachability
            if reachability.isReachable
            {
                if (APPDELEGATE.window?.viewWithTag(DialogTags.networkDialog)) != nil
                {
                    self?.dialogForNetwork?.removeFromSuperview()
                }
                if reachability.isReachableViaWiFi
                {
                    printE("Reachable via WiFi")
                } else {
                    printE("Reachable via Cellular")
                }
            } else {
                printE("Network not reachable")
                self?.openNetworkDialog()
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: tokenDict)
    }
}

//MARK:- Push notification Handler
extension AppDelegate : UNUserNotificationCenterDelegate {

    func setupPushNotification(_ application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                if error == nil
                {
                    if grant {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    } else {
                        //User didn't grant permission
                    }
                } else {
                }
            })
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        let pushNotificationData = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
        if pushNotificationData != nil
        {
            let aps = pushNotificationData!["aps" as NSString] as? [String:Any]
            let alert:NSDictionary = (aps!["alert"] as? NSDictionary)!
            self.manageAllPush(data: alert)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        preferenceHelper.setDeviceToken(deviceTokenString)
        printE("Device Token: \(deviceToken)")
        wsUpdateDeviceToken()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        if let alert:NSDictionary = (aps["alert"] as? NSDictionary)
        {
            self.manageAllPush(data: alert)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        if let alert:NSDictionary = (aps["alert"] as? NSDictionary)
        {
            self.manageAllPush(data: alert,isClick: false)
            if let id = (alert["id"] as? String) ?? (alert["id"] as? Int)?.toString()
            {
                switch id
                {
                case PUSH.ProviderComing,PUSH.ProviderArrived,PUSH.ProviderStartTrip,PUSH.ProviderEndTrip,PUSH.ProviderEndTripWithTip,PUSH.ProviderInitTrip:
                    if let wd = self.window {
                        var viewController = wd.rootViewController
                        if(viewController is PBRevealViewController)
                        {
                            viewController = (viewController as! PBRevealViewController).mainViewController
                            if(viewController is UINavigationController)
                            {
                                viewController = (viewController as! UINavigationController).visibleViewController
                                if(viewController is TripVC)
                                {
                                    let mapvc:TripVC = (viewController as! TripVC)
                                    mapvc.wsGetTripStatus()
                                }
                                if(viewController is MapVC)
                                {
                                    let mapvc:MapVC = (viewController as! MapVC)
                                    mapvc.startTripStatusTimer()
                                }
                            }
                        }
                    }
                    break;
                default:
                    break;
                }
            }
        }
        completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo:[AnyHashable:Any] =  response.notification.request.content.userInfo
        let aps:NSDictionary = (userInfo[AnyHashable("aps")] as? NSDictionary)!
        if let alert:NSDictionary = (aps["alert"] as? NSDictionary)
        {
            self.manageAllPush(data: alert,isClick: true)
        }
        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printE("i am not available in simulator \(error)")
    }

    func manageAllPush(data:NSDictionary,isClick:Bool = true)
    {
        if let id = (data["id"] as? String) ?? (data["id"] as? Int)?.toString()
        {
            switch id
            {
            case PUSH.LoginAtAnother:
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                self.gotoLogin()
                break;
            case PUSH.Approved:
                self.gotoMap()
                break;
            case PUSH.CorporateRequest:
                printE("Push Data \(data)")
                printE("push received")
                if let corporateDetail:[String:Any] = data["extraParam"] as? [String:Any]
                {
                    CurrentTrip.shared.user.corporateDetail = CorporateDetail.init(fromDictionary: corporateDetail)
                    if let wd = self.window
                    {
                        var viewController = wd.rootViewController
                        if(viewController is PBRevealViewController)
                        {
                            viewController = (viewController as! PBRevealViewController).mainViewController
                            if(viewController is UINavigationController)
                            {
                                printE("Push Controller Find")
                                viewController = (viewController as! UINavigationController).visibleViewController
                                if(viewController is MapVC)
                                {
                                    let mapvc:MapVC = (viewController as! MapVC)
                                    mapvc.openCorporateRequestDialog()
                                }
                            }
                        }
                    }
                }
                break;
            case PUSH.Declined:
                self.gotoMap()
                break;
            case PUSH.ProviderAcceptRequest:
                if let wd = self.window
                {
                    var viewController = wd.rootViewController
                    if(viewController is PBRevealViewController)
                    {
                        viewController = (viewController as! PBRevealViewController).mainViewController
                        if(viewController is UINavigationController)
                        {
                            viewController = (viewController as! UINavigationController).visibleViewController
                            if(viewController is MapVC)
                            {
                                let mapvc:MapVC = (viewController as! MapVC)
                                mapvc.wsGetTripStatus()
                            }
                        }
                    }
                }
                break;
            case PUSH.ProviderComing,PUSH.ProviderArrived,PUSH.ProviderStartTrip,PUSH.ProviderEndTrip,PUSH.ProviderEndTripWithTip,PUSH.ProviderInitTrip:
                if let wd = self.window {
                    var viewController = wd.rootViewController
                    if(viewController is PBRevealViewController)
                    {
                        viewController = (viewController as! PBRevealViewController).mainViewController
                        if(viewController is UINavigationController)
                        {
                            viewController = (viewController as! UINavigationController).visibleViewController

                            if(viewController is TripVC)
                            {
                                let mapvc:TripVC = (viewController as! TripVC)
                                mapvc.wsGetTripStatus()
                            }
                            if(viewController is MapVC)
                            {
                                let mapvc:MapVC = (viewController as! MapVC)
                                mapvc.startTripStatusTimer()
                            }
                        }
                    }
                }
                break;
            case PUSH.ProviderCancelTrip:
                if let wd = self.window {
                    var viewController = wd.rootViewController
                    if(viewController is PBRevealViewController)
                    {
                        viewController = (viewController as! PBRevealViewController).mainViewController
                        if(viewController is UINavigationController)
                        {
                            viewController = (viewController as! UINavigationController).visibleViewController

                            if(viewController is MapVC)
                            {
                                let mapvc:MapVC = (viewController as! MapVC)
                                mapvc.wsGetTripStatus()
                            }
                            else if(viewController is TripVC)
                            {
                                let tripVC:TripVC = (viewController as! TripVC)
                                tripVC.wsGetTripStatus()
                            }
                            else
                            {
                                Utility.showToast(message: "TXT_TRIP_CANCELLED_BY_PROVIDER".localized)
                            }
                        }
                    }
                }
                break;
            default:
                break;
            }
        }
    }
}

extension AppDelegate
{
    func wsUpdateDeviceToken()
    {
        if !preferenceHelper.getUserId().isEmpty
        {
            let afh:AlamofireHelper = AlamofireHelper.init()
            let dictParam : [String : Any] =
                [ PARAMS.USER_ID:preferenceHelper.getUserId(),
                  PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                  PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken()];

            afh.getResponseFromURL(url: WebService.UPDATE_DEVICE_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response, error) -> (Void) in
                printE(Utility.conteverDictToJson(dict: response))
            }
        }
    }
}
