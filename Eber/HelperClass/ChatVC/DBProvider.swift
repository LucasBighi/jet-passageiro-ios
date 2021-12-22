//
//  DBProvider.swift
//  ChatApp
//
//  Created by Elluminati on 18/12/17.
//  Copyright © 2017 Irshad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider
{
    private static let _instance = DBProvider()
    private init () {}
    
    static var Instance:DBProvider{
        return _instance
    }
    var dbRef:DatabaseReference{
        return  Database.database().reference()
    }
    
    var userRef:DatabaseReference{
        return dbRef.child(CONSTANT.DBPROVIDER.USER);
    }
   
    var messageRef:DatabaseReference{
        return dbRef;
    }
    
    func saveUser(withID:String,email:String,password:String)
    {
        let data:Dictionary<String,Any> = [CONSTANT.DBPROVIDER.EMAIL:email,
                                           CONSTANT.DBPROVIDER.PASSWORD:password]
        userRef.child(withID).setValue(data)
    }
    
    deinit {
        printE("\(self) \(#function)")
    }
}
