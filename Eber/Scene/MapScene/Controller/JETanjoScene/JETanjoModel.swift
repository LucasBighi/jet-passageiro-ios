//
//  JETanjoModel.swift
//  JET
//
//  Created by Lucas Marques Bighi on 14/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation

class JETanjoResponse {
    var friendsList = [JETanjoModel]()

    init(fromDictionary dictionary: [String: Any]) {
        if let list = dictionary["friends_list"] as? [[String: Any]] {
            for dic in list {
                let value = JETanjoModel(fromDictionary: dic)
                friendsList.append(value)
            }
        } else if let list = dictionary["friend_list"] as? [[String: Any]] {
            for dic in list {
                let value = JETanjoModel(fromDictionary: dic)
                friendsList.append(value)
            }
        }
    }
}

class JETanjoModel {
    var id: String
    var firstName: String
    var lastName: String
    var picturePath: String

    init(fromDictionary dictionary: [String: Any]) {
        id = dictionary["_id"] as? String ?? ""
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        picturePath = dictionary["picture"] as? String ?? ""
    }
}
