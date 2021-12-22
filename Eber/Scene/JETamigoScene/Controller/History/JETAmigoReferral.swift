//
//  JETAmigoReferral.swift
//  JET
//
//  Created by Lucas Marques Bighi on 14/12/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation

class JETAmigoReferral: ModelNSObj {

    var message: String!
    var entryLevel: Int!
    var username: String!
    var stringDate: String!
    var date: Date!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        message = dictionary["message"] as? String
        date = dictionary["data"] as? Date
        entryLevel = dictionary["entry_level"] as? Int
        username = dictionary["userName"] as? String
        stringDate = (dictionary["user_create_time"] as? String ) ?? ""
        date = stringDate.toDate(format: DateFormat.WEB)
    }
}

