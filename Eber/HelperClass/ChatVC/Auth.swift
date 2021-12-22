//
//  Auth.swift
//  ChatApp
//
//  Created by Elluminati on 19/12/17.
//  Copyright © 2017 Irshad. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {
    
    private static let _instance = AuthProvider()
    private init (){}
    static var Instance:AuthProvider{
        return _instance
    }

    private func logOut() -> Bool
    {
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                return true
            }catch{
                return false
            }
        }
        return false
    }
    
    deinit {
        printE("\(self) \(#function)")
    }
}
