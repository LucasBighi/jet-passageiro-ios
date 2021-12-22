//
//  Storyboard.swift
//  Cabtown
//
//  Created by Elluminati  on 08/09/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import Foundation

import UIKit

enum AppStoryboard: String {
    case Map
    case PreLogin
    case Splash
    case History
    case Trip
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClas : T.Type) -> T
    {
        let storyboardID = (viewControllerClas as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}



extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
}
