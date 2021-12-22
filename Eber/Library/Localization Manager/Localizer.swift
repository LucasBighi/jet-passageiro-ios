//
//  Localizer.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }    
}

class Localizer: NSObject {
    class func doTheMagic() {
        MethodSwizzleGivenClassName(cls: Bundle.self, 
                                    originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), 
                                    overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        
        MethodSwizzleGivenClassName(cls: UIApplication.self, 
                                    originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), 
                                    overrideSelector: #selector(getter: UIApplication.custom_userInterfaceLayoutDirection))
        
        MethodSwizzleGivenClassName(cls: UITextField.self, 
                                    originalSelector: #selector(UITextField.layoutSubviews), 
                                    overrideSelector: #selector(UITextField.customlayoutSubviews))
        
        MethodSwizzleGivenClassName(cls: UILabel.self, 
                                    originalSelector: #selector(UILabel.layoutSubviews), 
                                    overrideSelector: #selector(UILabel.customlayoutSubviews))
        
        MethodSwizzleGivenClassName(cls: UIButton.self, 
                                    originalSelector: #selector(UIButton.layoutSubviews), 
                                    overrideSelector: #selector(UIButton.customlayoutSubviews))
        
        if UIApplication.isRTL() {            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

extension UILabel {
    @objc public func customlayoutSubviews() {
        self.customlayoutSubviews()
        
        if self.textAlignment != .center {
            if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
                return // handle special case with uitextfields
            }
            
            if self.tag <= 0  {
                if UIApplication.isRTL()  {
                    if self.textAlignment == .right {
                        return
                    }
                } 
                else {
                    if self.textAlignment == .left {
                        return
                    }
                }
            }
            
            if self.tag <= 0 {
                if UIApplication.isRTL()  {
                    self.textAlignment = .right
                } 
                else {
                    self.textAlignment = .left
                }
            }
        }
    }
}

extension UIButton {
    @objc public func customlayoutSubviews() {
        self.customlayoutSubviews()
        
        if self.titleLabel?.textAlignment != .center {
            if self.tag <= 0 {
                if UIApplication.isRTL() {
                    if self.titleLabel?.textAlignment == .right {
                        return
                    }
                } 
                else {
                    if self.titleLabel?.textAlignment == .left {
                        return
                    }
                }
            }
            
            if self.tag <= 0 {
                if UIApplication.isRTL() {
                    self.titleLabel?.textAlignment = .right
                }
                else {
                    self.titleLabel?.textAlignment = .left
                }
            }
        }
    }
}

extension UITextField {
    @objc public func customlayoutSubviews() {
        if self.textAlignment != .center {
            self.customlayoutSubviews()
            
            if self.tag <= 0 {
                if UIApplication.isRTL() {
                    if self.textAlignment == .right {
                        return
                    }
                    
                    self.textAlignment = .right
                } 
                else {
                    if self.textAlignment == .left { return }
                    self.textAlignment = .left
                }
            }
        }
    }
}

var numberoftimes = 0

extension UIApplication {
    @objc var custom_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            
            if LocalizeLanguage.currentLanguage() == "ar" {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = LocalizeLanguage.currentLanguage()
            var bundle = Bundle();
            
            if let _path = Bundle.main.path(forResource: LocalizeLanguage.currentAppleLanguageFull(), ofType: "lproj") {
                bundle = Bundle(path: _path)!
            }
            else {
                if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                    bundle = Bundle(path: _path)!
                } 
                else {
                    let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                    bundle = Bundle(path: _path)!
                }
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } 
        else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

func disableMethodSwizzling() {
    
}

/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, 
                                 overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    
    if (class_addMethod(cls, 
                        originalSelector, 
                        method_getImplementation(overrideMethod), 
                        method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, 
                            overrideSelector, 
                            method_getImplementation(origMethod), 
                            method_getTypeEncoding(origMethod));
    } 
    else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
