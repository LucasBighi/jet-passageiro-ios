//
//  BaseVC.swift
//  Cabtown Use
//
//  Created by Elluminati iMac on 10/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    var timeInterval: TimeInterval = 0.0
    
    //MARK:
    //MARK: View life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        printE("\(self) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
     }
    override func viewWillAppear(_ animated: Bool)
    {
            super.viewWillAppear(true)
         self.setupNetworkReachability()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: APPDELEGATE.reachability)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func setupNetworkReachability()
    {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: APPDELEGATE.reachability)
    }
    
    @objc func reachabilityChanged(note: NSNotification)
    {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable
        {
            self.networkEstablishAgain()
        }
        else
        {
            self.networklost()
            
        }
    }
    func networkEstablishAgain()
    {
       printE("\(self.description) Network reachable")
    }
    func networklost()
    {
       printE("\(self.description) Network not reachable")
    }
    
    func changed(_ language: Int) {
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        LocalizeLanguage.setAppleLanguageTo(lang: language)
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } 
        else {
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        AlamofireHelper.manager.session.cancelTasks { [unowned self] in
            let appWindow: UIWindow? = APPDELEGATE.window
            var vC: UIViewController? = nil
            if CurrentTrip.shared.tripId.isEmpty {
                vC = self.storyboard?.instantiateInitialViewController()
            }
            else {
                APPDELEGATE.gotoTrip()
            }

            
            appWindow?.removeFromSuperviewAndNCObserver()
            appWindow?.rootViewController?.removeFromParentAndNCObserver()
            appWindow?.rootViewController = vC
            appWindow?.makeKeyAndVisible()
            appWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            
            UIView.transition(with: appWindow ?? UIWindow(), 
                              duration: 0.5, 
                              options: transition, 
                              animations: { () -> Void in
            }) { (finished) -> Void in 
                appWindow?.backgroundColor = UIColor.clear
            }
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public class Model {
    deinit {
        printE("\(self) \(#function)")
    }
}

public class ModelNSObj: NSObject {
    deinit {
        printE("\(self) \(#function)")
    }
}

public class CustomDialog: UIView {
    deinit {
        printE("\(self) \(#function)")
    }
}
