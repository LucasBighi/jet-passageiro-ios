//
//    HistoryResponse.swift
//
//    Create by MacPro3 on 12/9/2018
//    Copyright © 2018. All rights reserved.


import Foundation


class JETAmigoResponse: ModelNSObj {

    var success: Bool!
    var refferals: [JETAmigoReferral]!

    init(fromDictionary dictionary: [String:Any]){
        success = dictionary["success"] as? Bool
        refferals = [JETAmigoReferral]()
        if let refferalsArray = dictionary["refferals_history_messages"] as? [[String:Any]]{
            for dic in refferalsArray {
                let value = JETAmigoReferral(fromDictionary: dic)
                refferals.append(value)
            }
        }
    }
}
